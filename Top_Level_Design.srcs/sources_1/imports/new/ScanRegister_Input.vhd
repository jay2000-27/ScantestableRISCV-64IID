----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.08.2024 00:12:13
-- Design Name: 
-- Module Name: ScanRegister_Input - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ScanRegister_Input is
    Port ( 
--           TCLK_i : in STD_LOGIC;
--           TRST_i : in STD_LOGIC;
           TDI_ip_i  : in STD_LOGIC;
           TDO_ip_o : out STD_LOGIC;
           MODE_i : in STD_LOGIC;
           CLOCK_DR_i : in STD_LOGIC;
           SHIFT_DR_i : in STD_LOGIC;
           UPDATE_DR_i : in STD_LOGIC;
           DATA_IN1_i : in STD_LOGIC_VECTOR (31 downto 0);
           DATA_OUT1_o : out STD_LOGIC_VECTOR (31 downto 0));
end ScanRegister_Input;

architecture Behavioral of ScanRegister_Input is

signal datareg1_s : std_logic_vector(31 DOWNTO 0);
signal datareg2_s : std_logic_vector(31 DOWNTO 0);
signal buff_s : std_logic_vector(32 DOWNTO 0);
begin

buff_s(0) <= TDI_ip_i;

gen_R1: for i in 0 to 31 generate
    CAPTURE: process(SHIFT_DR_i, CLOCK_DR_i)
    begin
      if rising_edge(CLOCK_DR_i) then
        if SHIFT_DR_i = '1' then
          datareg1_s(i) <= buff_s(i);
        else
          datareg1_s(i) <= DATA_IN1_i(i);  
        end if;
      end if; 
    end process; 
    buff_s(i+1) <= datareg1_s(i);
    UPDATE: process(UPDATE_DR_i, MODE_i)
        begin
          if rising_edge(UPDATE_DR_i) then
            datareg2_s(i) <= datareg1_s(i);
          end if;
          if MODE_i = '1' then
            DATA_OUT1_o(i) <= datareg2_s(i);
          else
            DATA_OUT1_o(i) <= DATA_IN1_i(i);
          end if;
        end process;  
      end generate gen_R1; 
    TDO_ip_o <= buff_s(32); 
end Behavioral;
