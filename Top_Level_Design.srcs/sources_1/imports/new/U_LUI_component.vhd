----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.07.2024 19:05:06
-- Design Name: 
-- Module Name: U_LUI_component - Behavioral
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

entity U_LUI_component is
    Port ( CLK         : in STD_LOGIC;
           RST         : in STD_LOGIC;
           ENABLE_ULUI : in STD_LOGIC;
           instruction_in_ULUI : in STD_LOGIC_VECTOR (28 downto 0);
           Decoded_ULUI : out STD_LOGIC_VECTOR (49 downto 0));
end U_LUI_component;

architecture Behavioral of U_LUI_component is

signal instr_var : STD_LOGIC_VECTOR(28 downto 0);
signal opcode : STD_LOGIC_VECTOR(3 downto 0);
signal func3  : STD_LOGIC_VECTOR(2 downto 0);
signal func7  : STD_LOGIC_VECTOR(6 downto 0);
signal func   : STD_LOGIC_VECTOR(8 downto 0);
signal reg_write_rd : STD_LOGIC_VECTOR(4 downto 0);
signal reg_read_rs1 : STD_LOGIC_VECTOR(4 downto 0);
signal reg_read_rs2 : STD_LOGIC_VECTOR(5 downto 0);
signal second_source_select : STD_LOGIC;
signal mem_reg_select : STD_LOGIC_VECTOR(1 downto 0);
signal mem_read_write : STD_LOGIC_VECTOR(1 downto 0); 
signal immediate      : STD_LOGIC_VECTOR(20 downto 0);

begin
instr_var <= instruction_in_ULUI;
--process(RESET_ULUI,ENABLE_ULUI,instruction_in_ULUI)
process(CLK,RST,ENABLE_ULUI,instruction_in_ULUI)
begin 
if RST='1' then 
  Decoded_ULUI <=  (others => '0');
elsif rising_edge(CLK) then 
 if ENABLE_ULUI = '1' then
   opcode                  <= instr_var(3 downto 0);
   func3                   <= (others => '0');
   func7                   <= (others => '0');
   immediate(19 downto 0) <= instr_var(28 downto 9);
   immediate(20)           <= '0';
   reg_write_rd            <= instr_var(8 downto 4);
   reg_read_rs1            <= (others => '0');
   reg_read_rs2            <= (others => '0');
   second_source_select    <= '1';
   mem_reg_select          <= "00";--PC instruction
   --set to read but it is a dont care state. Control expected to be done in further steps
   mem_read_write          <= "00";
   func(2 downto 0)        <= func3;
   if func7(0) = '1' or
      func7(1) = '1' or
      func7(2) = '1' or
      func7(3) = '1' or
      func7(4) = '1' or
      func7(5) = '1' or
      func7(6) = '1' then 
      func(3)  <= '1';
   else 
      func(3)  <= '0';
      
   end if;
   func(5 downto 4) <= mem_reg_select;
   func(7 downto 6) <= mem_read_write;
   func(8)          <= second_source_select;
   

end if;
Decoded_ULUI(3 downto 0)   <= opcode;
Decoded_ULUI(12 downto 4)  <= func;
Decoded_ULUI(17 downto 13) <= reg_write_rd;
Decoded_ULUI(22 downto 18) <= reg_read_rs1;
Decoded_ULUI(28 downto 23) <= reg_read_rs2;
Decoded_ULUI(49 downto 29) <= immediate;
end if;
end process;


end Behavioral;
