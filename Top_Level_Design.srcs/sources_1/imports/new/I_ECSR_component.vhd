----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.07.2024 17:54:32
-- Design Name: 
-- Module Name: I_ECSR_component - Behavioral
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

entity I_ECSR_component is
    Port ( CLK          : in STD_LOGIC;
           RST          : in STD_LOGIC;
           ENABLE_IECSR : in STD_LOGIC;
           instruction_in_IECSR : in STD_LOGIC_VECTOR (28 downto 0);
           Decoded_IECSR : out STD_LOGIC_VECTOR (49 downto 0));
end I_ECSR_component;

architecture Behavioral of I_ECSR_component is

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
instr_var <= instruction_in_IECSR;
--process(RESET_IECSR,ENABLE_IECSR,instruction_in_IECSR)
process(CLK,RST,ENABLE_IECSR,instruction_in_IECSR)
begin 
if RST='1' then 
  Decoded_IECSR  <=  (others => '0');
elsif rising_edge(CLK) then 
  if ENABLE_IECSR ='1' then 
   opcode     <= instr_var(3 downto 0);
   func3      <= instr_var(11 downto 9);
   func7      <= (others => '0');
   reg_write_rd  <= instr_var(8 downto 4);
   reg_read_rs1 <= instr_var(16 downto 12);--For reg_read_rs1 and zimm
   reg_read_rs2 <= (others => '0');
   second_source_select <= '0';
   mem_read_write  <= "00";
      
   if func3 = "000"  then 
--   and reg_write_rd = "00000" and reg_read_rs1 = "00000"
   --It is a condition for ecall or ebreak
     immediate(11 downto 0) <= instr_var(28 downto 17);
     mem_reg_select  <= "00";
--     immediate(20 downto 12)<= (others => '0');   
   elsif func3 ="001" or func3 = "010" or func3 ="011" then 
   --It is a condition for csrrs, csrrw, csrrc
     mem_reg_select <= "10";
     immediate(11 downto 0) <= instr_var(28 downto 17);
--     immediate(20 downto 12)<= (others => '0');   

   elsif func3 = "101" or func3 = "110" or func3 = "111" then
   --for other possible values which is condition for csrrsi, csrrwi, csrrci
     mem_reg_select <= "10";
     immediate(11 downto 0) <= instr_var (28 downto 17);
--     immediate(20 downto 12)<= (others => '0');   

   end if;
   immediate(20 downto 12)<= (others => '0');   
   func(2 downto 0) <= func3;
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
Decoded_IECSR(3 downto 0) <= opcode;
Decoded_IECSR(12 downto 4)<= func;
Decoded_IECSR(17 downto 13) <= reg_write_rd;
Decoded_IECSR(22 downto 18) <= reg_read_rs1;
Decoded_IECSR(28 downto 23) <= reg_read_rs2;
Decoded_IECSR(49 downto 29) <= immediate;
end if;
end process;

end Behavioral;