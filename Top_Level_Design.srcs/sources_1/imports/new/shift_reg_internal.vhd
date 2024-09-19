----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.08.2024 18:55:23
-- Design Name: 
-- Module Name: shift_reg_internal - Behavioral
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

entity shift_reg_internal is
    Port ( CLK_i        : in STD_LOGIC;--Clock input
           RST_i        : in STD_LOGIC;--Asynchronous input
           LOAD_ENABLE  : in STD_LOGIC;--Load enable input
           SHIFT_ENABLE : in STD_LOGIC;--Shift enable input
           DATA_IN : in STD_LOGIC_VECTOR (40 downto 0);--41 bit 
           SERIAL_OUT: out STD_LOGIC --Serial output 
--           data_out : out STD_LOGIC_VECTOR (40 downto 0)
           );
end shift_reg_internal;

architecture Behavioral of shift_reg_internal is
  signal shift_reg : STD_LOGIC_VECTOR(40 downto 0):= (others => '0'); --41 bit internal register 
  signal serial_out_s : STD_LOGIC;
begin
  process(CLK_i, RST_i)
  begin 
      if RST_i = '1' then 
         shift_reg <= (others => '0'); --Clear the shift register on reset
      elsif rising_edge(CLK_i) then
          if LOAD_ENABLE = '1' then 
             shift_reg <= DATA_IN; --LOAD PARALLEL DATA INTO THE SHIFT REGISTER
          elsif SHIFT_ENABLE = '1' then 
             SERIAL_OUT <= shift_reg(40);   --Serial shifting out of data
             shift_reg  <= shift_reg(39 downto 0) & '0'; --Shift left and insert 0 at LSB
          end if;
      end if;
end process;
--SERIAL_OUT <= shift_reg(41);   --Serial shifting out of data

end Behavioral;
