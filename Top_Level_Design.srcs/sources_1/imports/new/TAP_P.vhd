----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.08.2024 21:40:14
-- Design Name: 
-- Module Name: TAP_P - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

package TAP_P is
--constant ir_width_c      : integer := 8; --! width of IR
constant ir_width_c      : integer := 2; --! width of IR
--Width of IR register is reduced to 2 bits since we will use only Bypass and Scan test instructions. 
--constant ir_pardata_c    : std_logic_vector(1 downto 0) := "11010001"; --! parallel data at IR (HERE IT IS AVOIDED SINCE WE DONT HAVE PARALLEL IN)
constant ir_reset_c      : std_logic_vector(1 downto 0) := "00"; --! IR reset: BYPASS
--constant ir_pardata_c    : std_logic_vector(7 downto 0) := "11010001"; --! parallel data at IR
--constant ir_reset_c      : std_logic_vector(7 downto 0) := "00000100"; --! IR reset: IDCODE
--constant id_width_c      : integer := 8; --! IDCODE
--constant id_code_c       : std_logic_vector(id_width_c-1 downto 0) := "01001111";
--constant id_codexx_c     : std_logic_vector(id_width_c-1 downto 0) := "11111111";
--constant nr_of_dr_c      : integer := 5;  --! Then number of existing data registers minus BYPASS and IDCODE; actually: BSCAN, ASTEST, scan-path
constant nr_of_dr_c      : integer := 2;  --! Then number of existing data registers minus BYPASS and IDCODE; actually: BSCAN, ASTEST, scan-path
--constant nr_of_dr_sels_c : integer := 3;  --! The number of data register selector bits
constant nr_of_dr_sels_c : integer := 1;  --! The number of data register selector bits
--constant bsr_length_c   : integer := 8;--Sample length for our BSR 
--constant bs_chain_length_c : integer := 30;  --! The lengt of the boundary scan (PINs)
----! Parallel value with which the BS-DR will be loaded (tests only)
--constant bs_par_val_c : std_logic_vector(bs_chain_length_c-1 downto 0) := "001100110011001100110011001100";
----! Serial value with which the BS-DR will be loaded (tests only)
--constant bs_ser_val_c : std_logic_vector(bs_chain_length_c-1 downto 0) := "001100110011111111110011001100";
constant dbg_chain_length_c : integer := 16;  --! The lengt of the debug scan chain
--! Parallel value with which the DBG-DR will be loaded (tests only)
constant dbg_par_val_c : std_logic_vector(dbg_chain_length_c-1 downto 0) := x"dead";
--! Serial value with which the DBG-DR will be loaded (tests only)
constant dbg_ser_val_c : std_logic_vector(dbg_chain_length_c-1 downto 0) := x"beef";

  
component TAP_BYPASS
port(
  TCLK_i       : in  std_logic;
  TRST_i      : in  std_logic;
  DR_CLOCK_i  : in  std_logic;
  DR_SHIFT_i  : in  std_logic;
  TDI_i       : in  std_logic;
  TDO_o       : out std_logic
  );
end component;

component TDO_MUX
port(
  TCLK_i    : in  std_logic;
  TRST_i    : in  std_logic;
  TDO_IR_i    : in  std_logic;
  TDO_DR_i    : in  std_logic_vector(nr_of_dr_c-1 downto 0);
  IRDR_SELECT_i  : in  std_logic;
  TDO_ENA_i  : in  std_logic;
  SEL_DR_i    : in  std_logic_vector(nr_of_dr_sels_c-1 downto 0);
  TDO_o       : out std_logic
  
  );
end component;

--component TAP_DR_UNIT
--port(
--  CLK_i       : in  std_logic;
--  TRST_i      : in  std_logic;
--  DATA_IN_i   : in  std_logic;
--  DATA_OUT_o  : out std_logic;
--  SERIAL_IN_i    : in  std_logic;
--  SERIAL_OUT_o   : out std_logic;
--  SHIFT_DR_i  : in  std_logic;
--  MODE_i      : in  std_logic;
--  CLOCK_DR_i  : in  std_logic;
--  UPDATE_DR_i    : in  std_logic  
--  );
--end component;

--component TAP_BSR
--generic(bsr_length_g : integer := 30);
--port(
--  CLK_i       : in  std_logic;
--  TRST_i      : in  std_logic;
--  DATA_IN_i   : in  std_logic_vector(bsr_length_g-1 downto 0);
--  DATA_OUT_o  : out std_logic_vector(bsr_length_g-1 downto 0);
--  SERIAL_IN_i1    : in  std_logic;
--  SERIAL_OUT_o1   : out std_logic;
--  SHIFT_DR_i  : in  std_logic;
--  MODE_i      : in  std_logic;
--  CLOCK_DR_i  : in  std_logic;
--  UPDATE_DR_i    : in  std_logic  
--  );
--end component;

component TAP_IR_UNIT
port(
  TCLK_i       : in  std_logic;
  TRST_i      : in  std_logic;
  IR_RST_i    : in  std_logic;
--data_in_i   : in  std_logic;
  DATA_OUT_o  : out std_logic;
  SER_IN_i    : in  std_logic;
  SER_OUT_o   : out std_logic;
  SHIFT_IR_i  : in  std_logic;
  CLOCK_IR_i  : in  std_logic;
  UPDATE_IR_i    : in  std_logic
  );
end component;

component TAP_IR_DECODER
port (SHIFT_DR_i  : in  std_logic;
      CLOCK_DR_i  : in  std_logic;
      UPDATE_DR_i : in  std_logic;
      IR_i        : in  std_logic_vector(ir_width_c-1 downto 0);
      test_mode_o : out std_logic;
      SELECT_TDO_o : out std_logic_vector(nr_of_dr_sels_c-1 downto 0);
      SHIFT_BY_o  : out std_logic;
      CLOCK_BY_o  : out std_logic;
      SHIFT_BS_o  : out std_logic;
      CLOCK_BS_o  : out std_logic;
      UPDATE_BS_o : out std_logic
      --debug0 DR chain
--      dbg0_mode_o  : out std_logic;
--      dbg0_shift_o : out std_logic;
--      dbg0_clock_o : out std_logic;
--      dbg0_upd_o   : out std_logic;
--      --scan chain01 DR chain control and mode
--      dbg1_mode_o  : out std_logic;
--      dbg1_shift_o : out std_logic;
--      dbg1_clock_o : out std_logic;
--      dbg1_upd_o   : out std_logic
      );
end component;

component TAP_FSM
port(
  TCLK_i         : in  std_logic; --! Base clock
  TRST_i        : in  std_logic; --! Asynchronous reset
  TMS_i         : in  std_logic; --! Mode select
  IR_SHIFT_o    : out std_logic; --! For Mux: either shift tdi/tdo or capture data; Monitor only
  IR_CLOCK_o    : out std_logic; --! Clock the IR shift register (Latch?); Monitor only
  IR_UPDATE_o      : out std_logic; --! Clock (activate) the IR hold register; Monitor only
  DR_SHIFT_o    : out std_logic; --! For Mux: either shift tdi/tdo or capture data
  DR_CLOCK_o    : out std_logic; --! Clock the DR shift register (Latch?)
  DR_UPDATE_o      : out std_logic; --! Clock (activate) the DR hold register
  JTAG_RST_o    : out std_logic; --! SW-reset of the FSM
  IRDR_SELECT_o : out std_logic; --! Selects between DR or IR TDO output
  TDO_ENA_o     : out std_logic  --! Drives TDO either to 'Z' or to enable
  );
end component;
--! Clock is 10MHz  -> divider 1042 (half: 521)
--! Clock is 50MHz  -> divider 5208 (half: 2604)
--! Clock is 100MHz -> divider 10417 (half: 5208)



end;

package body TAP_P is


  
end package body;
