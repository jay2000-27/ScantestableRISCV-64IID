----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.08.2024 22:47:28
-- Design Name: 
-- Module Name: TDO_MUX - Behavioral
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
use work.TAP_P.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TDO_MUX is
    Port ( TCLK_i : in STD_LOGIC;--BASE CLOCK
           TRST_i : in STD_LOGIC;--ASYNCHRONOUS RESET
           TDO_IR_i : in STD_LOGIC;--TDO FROM INSTRUCTION REGISTER --Value 0 or 1
           TDO_DR_i : in STD_LOGIC_VECTOR(nr_of_dr_c-1 downto 0);--TDO FROM DATA REGISTER --From tap top itself 
           --TDO_DR_i zeroth bit for TDO data from bypass and 1st bit from Scan register 
           IRDR_SELECT_i : in STD_LOGIC;--SELECT FOR IR OR DR--From FSM file
           --Zero for data register related states and 1 for instruction register related states
           TDO_ENA_i : in STD_LOGIC;--SELECT TDO OR 'Z'--From FSM , value is 1 only during shift dr or shift ir states else Z
           SEL_DR_i : in STD_LOGIC_VECTOR(nr_of_dr_sels_c-1 downto 0);--WHICH DR--Select TDO from tap_ir_decoder 
           --SEL_DR_i 0 for bypass during bypass instruction , 1 during Scan chain instruction 
           TDO_o : out STD_LOGIC);--SERIAL OUT
end TDO_MUX;

architecture Behavioral of TDO_MUX is
signal tdo_del_s     : std_logic; --! To neg. edge delayed TDO
signal tdo_dr_s      : std_logic; --! All DR TDOs
signal tdo_int_s     : std_logic; --! Selected IR, DR TDO; not tristate
signal irdr_select_s : std_logic; --! Selector for IR or DR TDO
signal sel_dr_s      : std_logic_vector(nr_of_dr_sels_c-1 downto 0); --! Selector for the active DR
signal tdo_dr_all_s  : std_logic_vector(nr_of_dr_c-1 downto 0);      --! All DR chains

begin

  irdr_select_s <= IRDR_SELECT_i;
  sel_dr_s      <= SEL_DR_i;
  tdo_dr_all_s  <= TDO_DR_i;

  tdo_dr_s <= tdo_dr_all_s(to_integer(unsigned(sel_dr_s))); 
  --tdo_dr_s <= tdo_dr_by_s when ( dataout_ir_s="11111111" ) else  --BYPASS
  --            tdo_dr_id_s when ( dataout_ir_s="00000100" ) else  --IDCODE
  --            tdo_dr_by_s;
  tdo_int_s <= tdo_dr_s when ( irdr_select_s='0' ) else
               TDO_IR_i;

  --! Synchronise TDO to falling edge of TCK
  neg_sync_tdo : process(TCLK_i, TRST_i)
  begin
    if (trst_i='1') then
      tdo_del_s <= '1';
    elsif (TCLK_i'event and TCLK_i='0') then
      tdo_del_s <= tdo_int_s;
    end if;
  end process;

  --! Enable TDO with signal tdo_ena_s
  TDO_o <= tdo_del_s when (TDO_ENA_i = '1') else 'Z';

end Behavioral;