----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.09.2024 21:39:26
-- Design Name: 
-- Module Name: Top_Level_Design - Behavioral
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

entity Top_Level_Design is
Port (

CLK_in : in STD_LOGIC;--Overall clock
RST_in : in STD_LOGIC;--Reset for Instruction Decoder design
RST_TAP: in STD_LOGIC;--Reset for TAP controller
TDI_in : in STD_LOGIC;--Tap controller port
TMS_in : in STD_LOGIC;--Tap controller port
TDO_out : out STD_LOGIC;--Tap controller port 
Instruction_input : in STD_LOGIC_VECTOR(31 downto 0);--Instruction decoder port 
LED_DECODED       : out STD_LOGIC_VECTOR(3 downto 0);--Instruction decoder port
DECODED_FUNC      : out STD_LOGIC_VECTOR(4 downto 0);--Instruction decoder port
OTHER_DATA        : out STD_LOGIC--Instruction decoder port

 );
end Top_Level_Design;

architecture Behavioral of Top_Level_Design is

signal CLK_S              : STD_LOGIC;
signal RST_IN_S           : STD_LOGIC;
signal RST_TAP_S          : STD_LOGIC;
signal TDI_in_S           : STD_LOGIC;
signal TMS_in_S           : STD_LOGIC;
signal TDO_out_S          : STD_LOGIC;
signal TDO_SCAN_S         : STD_LOGIC;
signal sig_Instruction_input : STD_LOGIC_VECTOR(31 downto 0);
signal TDI_ip_i_S         : STD_LOGIC;
signal TDO_ip_o_S         : STD_LOGIC;
signal Mode_i_S           : STD_LOGIC;
signal CLOCK_DR_S       : STD_LOGIC;
signal SHIFT_DR_S       : STD_LOGIC;
signal UPDATE_DR_S       : STD_LOGIC;
signal DATA_OUT1_o_S       : STD_LOGIC_VECTOR(31 downto 0);
signal Decoded_Output_S    : STD_LOGIC_VECTOR(49 downto 0);
signal Decoded_processing : STD_LOGIC_VECTOR(49 downto 0);
signal storage_data       : STD_LOGIC_VECTOR(40 downto 0);
signal serial_out_s       : STD_LOGIC;
signal LOAD_ENABLE_S      : STD_LOGIC;
signal SHIFT_ENABLE_S     : STD_LOGIC;


begin
CLK_S  <= CLK_in;
RST_IN_S<= RST_in;
RST_TAP_S <= RST_TAP;
sig_Instruction_input <= Instruction_input;

--Instantiate for Scan register Input 
P1 : entity work.ScanRegister_Input 
port map(
TDI_ip_i    => TDI_ip_i_S,
TDO_ip_o    => TDO_ip_o_S,
MODE_i      => MODE_i_S,
CLOCK_DR_i  => CLOCK_DR_S,
SHIFT_DR_i  => SHIFT_DR_S,
UPDATE_DR_i => UPDATE_DR_S,
DATA_IN1_i  => sig_Instruction_input,
DATA_OUT1_o => DATA_OUT1_o_S
);

P2: entity work.RISCV_Decoder_Top 
port map(
CLK        => CLK_S,
RST        => RST_IN_S,
LOAD_ENABLE_OUT => LOAD_ENABLE_S,
SHIFT_ENABLE_OUT => SHIFT_ENABLE_S,
Input_instruction => sig_Instruction_input,
Decoded_Output    => Decoded_Output_S 
); 

P3: entity work.ScanRegister_Output
port map(
TDI_op_i    => TDO_ip_o_S,
TDO_op_o    => TDO_SCAN_S,
MODE_i      => MODE_i_S,
CLOCK_DR_i  => CLOCK_DR_S,
SHIFT_DR_i  => SHIFT_DR_S,
UPDATE_DR_i => UPDATE_DR_S,
DATA_IN2_i  => Decoded_Output_S,
DATA_OUT2_o => Decoded_processing
);

P4 : entity work.TAP_TOP
port map(
TCLK_i      => CLK_S,
TRST_N_i    => RST_TAP_S,
TMS_i       => TMS_in,
TDI_i       => TDI_in,
TDO_o       => TDO_out,
SCAN_TDI_o  => TDI_ip_i_S,
SCAN_TDO_i  => TDO_SCAN_S,
SCANREG_MODE_o => MODE_i_S,
SCANREG_SHIFT_o =>SHIFT_DR_S,
SCANREG_CLOCK_o =>CLOCK_DR_S,
SCANREG_UPDATE_o =>UPDATE_DR_S

);


--Output assignments
storage_data <= Decoded_processing(49 downto 13) & Decoded_processing(7 downto 4);
     --Instantiate U_LUI_component
      P5: entity work.shift_reg_internal
          port map(
          CLK_i        => CLK_S,
          RST_i        => RST_IN_S,
          LOAD_ENABLE  => LOAD_ENABLE_S,
          SHIFT_ENABLE => SHIFT_ENABLE_S,
          DATA_IN         => storage_data,
          SERIAL_OUT      => serial_out_s
          );
LED_DECODED <= Decoded_processing(3 downto 0);
DECODED_FUNC       <= Decoded_processing(12 downto 8);
OTHER_DATA         <= serial_out_s;
end Behavioral;
