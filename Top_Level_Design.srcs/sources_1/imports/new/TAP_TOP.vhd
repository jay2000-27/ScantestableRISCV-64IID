----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.08.2024 18:32:49
-- Design Name: 
-- Module Name: TAP_TOP - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
use work.TAP_P.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TAP_TOP is
    Port ( TCLK_i : in STD_LOGIC;--BASE CLOCK
           TRST_N_i : in STD_LOGIC;--ASYNCHRONOUS RESET
           TMS_i : in STD_LOGIC;--MODE SELECT 
           TDI_i : in STD_LOGIC;--DATA_IN
           TDO_o : out STD_LOGIC;--DATA_OUT
           SCAN_TDI_o    : out std_logic; --! Connect external SCAN register
           SCAN_TDO_i    : in  std_logic; --! Connect external SCAN register
           SCANREG_MODE_o  : out std_logic;--control signal to external scan register
           SCANREG_SHIFT_o : out std_logic;--control signal to external scan register
           SCANREG_CLOCK_o : out std_logic;--control signal to external scan register
           SCANREG_UPDATE_o   : out std_logic--control signal to external scan regiser
           );
end TAP_TOP;
--This file details the TAP controller : FSM, IR, BYPASS REGISTER, and access to BSR

architecture Behavioral of TAP_TOP is
--state type
type state_type_t is (reset_state_st, run_test_idle_st,
                      select_dr_scan_st, capture_dr_st, shift_dr_st, exit1_dr_st, pause_dr_st, exit2_dr_st, update_dr_st,
                      select_ir_scan_st, capture_ir_st, shift_ir_st, exit1_ir_st, pause_ir_st, exit2_ir_st, update_ir_st
                      );--The definition of possible states similar to that in FSM

signal state_s, nextstate_s : state_type_t; --The actual state and the next state same like FSM file

signal trst_s : std_logic; -- internal signal for carrying TRST_i
signal trst_combined_s : std_logic;

--Internal signals for controlling IR and DR's 
signal ir_shift_s : std_logic;--For mux : either shift tdi/tdo or capture data
signal ir_clock_s : std_logic;--Clock the IR shift register 
signal ir_update_s : std_logic; --clock (activate) the IR hold register
--Internal signals for controlling DR which is scan register or bypass.
signal dr_shift_s: std_logic;--For mux : either shift tdi/tdo or capture data
signal dr_clock_s: std_logic; --Clock the DR shift register
signal dr_update_s: std_logic; --Clock the DR hold register
signal dr_capture_s: std_logic; --Load parallel data to DR

signal jtag_rst_s : std_logic; --Reset state for software reset
--Unrequired signal for our case 
--signal scanout_ir_s  : std_logic_vector(ir_width_c-1 downto 0);
signal scanin_ir_s   : std_logic_vector(ir_width_c downto 0);
signal dataout_ir_s  : std_logic_vector(ir_width_c-1 downto 0):= "01";

signal tdo_ir_s      : std_logic;--Signal carrying TDO from IR!!
signal tdo_dr_s      : std_logic;--Signal carrying TDO from Scan register
signal tdo_dr_by_s   : std_logic;--Signal carrying TDO from Bypass register


signal ir_rst_s : std_logic_vector(ir_width_c-1 downto 0);

signal tdo_ena_s : std_logic;

signal irdr_select_s : std_logic;

--decoder signals
--signal test_mode_extest_s : std_logic;
--signal sel_byreg_s : std_logic;
signal shift_by_s : std_logic;
signal clock_by_s : std_logic;
--signal shift_bs_s : std_logic; --Removed as the scan register file has become separate
--signal clock_bs_s : std_logic;
--signal update_bs_s : std_logic;

signal sel_dr_s : std_logic_vector(nr_of_dr_sels_c-1 downto 0);
signal tdo_dr_all_s : std_logic_vector(nr_of_dr_c-1 downto 0);

--dummy signals to satisfy ISE
--signal BSR_reg_out_s : std_logic_vector(bs_chain_length_c-1 downto 0);

begin
trst_s <= not TRST_N_i;
trst_combined_s <= jtag_rst_s or trst_s;--Combination of software (OR) hardware reset
tdo_dr_s        <= SCAN_TDO_i;
SCAN_TDI_o      <= TDI_i;

-------------------------------------------------------
--! Processes TAP FSM
-------------------------------------------------------

 TAP_FSM: entity work.TAP_FSM port map(
    TCLK_i        => TCLK_i,
    TRST_i        => trst_s,
    TMS_i         => tms_i,
    IR_SHIFT_o    => ir_shift_s,
    IR_CLOCK_o    => ir_clock_s,
    IR_UPDATE_o      => ir_update_s,
    DR_SHIFT_o    => dr_shift_s,
    DR_CLOCK_o    => dr_clock_s,
    DR_UPDATE_o      => dr_update_s,
    JTAG_RST_o    => jtag_rst_s,
    IRDR_SELECT_o => irdr_select_s,
    TDO_ENA_o     => tdo_ena_s
    );
  
-------------------------------------------------------
-- END: Processes TAP FSM
-------------------------------------------------------

-------------------------------------------------------------------------------
--! Instruction register
--! - Scan-Test01    - "00"
--! - BYPASS         - "01"
-------------------------------------------------------------------------------

  --datain_ir_s <= ir_pardata_c;          --! parallel data in
  ir_rst_s    <= ir_reset_c;            --! reset value
  scanin_ir_s(ir_width_c)  <= tdi_i;    --! connect TDI to the beginning - MSB
  tdo_ir_s <= scanin_ir_s(0);           --! connect TDO to the end - LSB
  generate_ir : for i in 0 to ir_width_c-1 generate
  ir_rg :tap_ir_unit port map --we have removed datain_ir_s in our design as we dont feed parallel instruction.
    (tclk_i,trst_combined_s,ir_rst_s(i),dataout_ir_s(i),scanin_ir_s(i+1),
                                   scanin_ir_s(i),ir_shift_s,ir_clock_s,ir_update_s);

  end generate generate_ir;
   
-------------------------------------------------------------------------------
-- END: Instruction register
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--! Bypass register
-------------------------------------------------------------------------------
--  dr_bypass : tap_bypass port map(tclk_i,trst_combined_s,clock_by_s,shift_by_s,tdi_i,tdo_dr_by_s);
  dr_bypass : entity work.tap_bypass port map
(TCLK_i => tclk_i,
TRST_i => trst_combined_s,
DR_CLOCK_i => clock_by_s,
DR_SHIFT_i => shift_by_s,
TDI_i      => tdi_i,
TDO_o      => tdo_dr_by_s);
-------------------------------------------------------------------------------
-- END: Bypass register
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--! Decoder
-------------------------------------------------------------------------------

  tap_decoder : entity work.TAP_IR_DECODER port map (
       SHIFT_DR_i   => dr_shift_s,  --! Shift DR generated by the FSM - distribute it
       CLOCK_DR_i   => dr_clock_s,  --! Clock DR generated by the FSM - distribute it
       UPDATE_DR_i  => dr_update_s,    --! Update DR generated by the FSM - distribute it
       IR_i         => dataout_ir_s,--! Instruction for decoding from dataout_ir_s
       SELECT_TDO_o => sel_dr_s,            -- select the tdo path; must be extended if more data registers will be needed
       SHIFT_BY_o   => shift_by_s,          -- shift, clock, update
       CLOCK_BY_o   => clock_by_s,          -- shift, clock, update
       SCAN_MODE_o   => SCANREG_MODE_o,          -- shift, clock, update
       SCAN_SHIFT_o   =>SCANREG_SHIFT_o,          -- shift, clock, update
       SCAN_CLOCK_o  => SCANREG_CLOCK_o,
       SCAN_UPDATE_o => SCANREG_UPDATE_o         -- shift, clock, update
);  
-------------------------------------------------------------------------------
-- END: Decoder
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
--! TDO processing
-------------------------------------------------------------------------------
  --chain 0: BYPASS
  --chain 1: Scan-test

  tdo_dr_all_s(0) <= tdo_dr_by_s;
  tdo_dr_all_s(1) <= tdo_dr_s;
 
 
  --TDO_MUX : TDO_MUX port map (tclk_i,trst_s,tdo_ir_s,tdo_dr_all_s,irdr_select_s,tdo_ena_s,sel_dr_s,tdo_o);
  tdo_mux : entity work.TDO_MUX port map (
      TCLK_i        => tclk_i,
      TRST_i        => trst_s,
      TDO_IR_i      => tdo_ir_s,
      TDO_DR_i      => tdo_dr_all_s,
      IRDR_SELECT_i => irdr_select_s,
      TDO_ENA_i     => tdo_ena_s,
      SEL_DR_i      => sel_dr_s,
      TDO_o         => tdo_o
  );

-------------------------------------------------------------------------------
-- END: TDO processing
-------------------------------------------------------------------------------


 
end Behavioral;
