----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.07.2024 18:25:18
-- Design Name: 
-- Module Name: Initial_Decoder - Behavioral
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

entity Initial_Decoder is
    Port (
        CLK            : in STD_LOGIC;
        RST            : in STD_LOGIC;
        instruction_in : in STD_LOGIC_VECTOR (31 downto 0);
        my_instruction : out STD_LOGIC_VECTOR (28 downto 0)
    );
end Initial_Decoder;

architecture Behavioral of Initial_Decoder is
    signal opcode : STD_LOGIC_VECTOR(6 downto 0);
    signal my_opcode : STD_LOGIC_VECTOR(3 downto 0);
    signal temp_instruction : STD_LOGIC_VECTOR(28 downto 0);
begin

    process(CLK, RST)
    begin
        if (RST = '1') then
            opcode <= (others => '0');
            my_opcode <= (others => '0');
            temp_instruction <= (others => '0');
        elsif rising_edge(CLK) then
            -- Extract the opcode from the instruction
            opcode <= instruction_in(6 downto 0);

            -- Assign the upper bits of the instruction to temp_instruction
--            temp_instruction(28 downto 4) <= instruction_in(31 downto 7);

            -- Initialize my_opcode to a default value
--            my_opcode <= "1111";  -- Default case for unknown/invalid

            -- Decode opcode using if-elsif statements
            if opcode = "0110011" then
                my_opcode <= "0001";  -- R_component type
            elsif opcode = "0111011" then
                my_opcode <= "0010";  -- R_word_component type
            elsif opcode = "0100011" then
                my_opcode <= "0011";  -- S_component type
            elsif opcode = "1100011" then
                my_opcode <= "0100";  -- B_component type
            elsif opcode = "1101111" then
                my_opcode <= "0101";  -- J_component type
            elsif opcode = "0110111" then
                my_opcode <= "0110";  -- U_LUI_component type
            elsif opcode = "0010111" then
                my_opcode <= "0111";  -- U_AUIPC_component type
            elsif opcode = "0010011" then
                my_opcode <= "1000";  -- I_R_component type
            elsif opcode = "0011011" then
                my_opcode <= "1001";  -- I_R_word_component type
            elsif opcode = "0001111" then
                my_opcode <= "1010";  -- I_fence_component type
            elsif opcode = "1110011" then
                my_opcode <= "1011";  -- I_ECSR_component type
            elsif opcode = "0000011" then
                my_opcode <= "1100";  -- I_L_component type
            elsif opcode = "1100111" then
                my_opcode <= "1101";  -- I_JALR_component type
            else 
                my_opcode <= "1111"; -- For load serial out
            end if;

            -- Assign the decoded opcode to the lower bits of temp_instruction
            temp_instruction(3 downto 0) <= my_opcode;
            temp_instruction(28 downto 4) <= instruction_in(31 downto 7);

            -- Assign the fully constructed temp_instruction to the output
            my_instruction <= temp_instruction;
        end if;
    end process;

end Behavioral;