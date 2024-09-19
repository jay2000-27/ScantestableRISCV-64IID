----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.09.2024 20:26:24
-- Design Name: 
-- Module Name: ScanRegister_Output - Behavioral
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

entity ScanRegister_Output is
    Port ( 
--           TCLK_i : in STD_LOGIC;
--           TRST_i : in STD_LOGIC;
           TDI_op_i  : in STD_LOGIC;
           TDO_op_o : out STD_LOGIC;
           MODE_i : in STD_LOGIC;
           CLOCK_DR_i : in STD_LOGIC;
           SHIFT_DR_i : in STD_LOGIC;
           UPDATE_DR_i : in STD_LOGIC;
           DATA_IN2_i : in STD_LOGIC_VECTOR (49 downto 0);
           DATA_OUT2_o : out STD_LOGIC_VECTOR (49 downto 0));
end ScanRegister_Output;

architecture Behavioral of ScanRegister_Output is

signal datareg1_s : std_logic_vector(49 DOWNTO 0);
signal datareg2_s : std_logic_vector(49 DOWNTO 0);
signal buff_s : std_logic_vector(50 DOWNTO 0);
begin

buff_s(0) <= TDI_op_i;

gen_R1: for i in 0 to 49 generate
    CAPTURE: process(SHIFT_DR_i, CLOCK_DR_i)
    begin
      if rising_edge(CLOCK_DR_i) then
        if SHIFT_DR_i = '1' then
          datareg1_s(i) <= buff_s(i);
        else
          datareg1_s(i) <= DATA_IN2_i(i);  
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
            DATA_OUT2_o(i) <= datareg2_s(i);
          else
            DATA_OUT2_o(i) <= DATA_IN2_i(i);
          end if;
        end process;  
      end generate gen_R1; 
    TDO_op_o <= buff_s(50); 
end Behavioral;
