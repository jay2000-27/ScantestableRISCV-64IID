----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.09.2024 18:10:51
-- Design Name: 
-- Module Name: tb_Top_Level_Design - Behavioral
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

entity tb_Top_Level_Design is
--  Port ( );
end tb_Top_Level_Design;

architecture Behavioral of tb_Top_Level_Design is

component Top_Level_Design
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
end component;

--Signals for driving the UUT

signal CLK_in : STD_LOGIC := '0';
signal RST_in : STD_LOGIC := '0';
signal RST_TAP : STD_LOGIC := '1';
signal TDI_in  : STD_LOGIC ;
signal TMS_in :  STD_LOGIC :='0';
signal TDO_out : STD_LOGIC;
signal Instruction_input : STD_LOGIC_VECTOR(31 downto 0):= (others => '0');
signal LED_DECODED       : STD_LOGIC_VECTOR(3 downto 0):= (others => '0');
signal DECODED_FUNC      : STD_LOGIC_VECTOR(4 downto 0):= (others => '0');
signal OTHER_DATA        : STD_LOGIC:= '0';

--CLOCK PERIOD DEFINITION
constant CLK_PERIOD : time := 10ns;

begin

--CLOCK PROCESS
clk_process: process
begin 
     CLK_in <= '0';
     wait for CLK_PERIOD/2 ;
     CLK_in <= '1';
     wait for CLK_PERIOD/2;
end process clk_process;

--Instantiate the Unit under test (UUT)

UUT: Top_Level_Design
     Port map(
       CLK_in => CLK_in,
       RST_in => RST_in,
       RST_TAP => RST_TAP,
       TDI_in  => TDI_in,
       TMS_in  => TMS_in,
       TDO_out => TDO_out,
       Instruction_input => Instruction_input,
       LED_DECODED       => LED_DECODED,
       DECODED_FUNC      => DECODED_FUNC,
       OTHER_DATA        => OTHER_DATA   
     );


--STIMULUS PROCESS 
stim_proc: process
begin
--Initialize signals
RST_in <= '1';--RESET SIGNAL FOR INSTRUCTION DECODER 
RST_TAP <= '0'; --RESET SIGNAL FOR TAP CONTROLLER 
wait for 20ns;
TMS_in   <= '0';
TDI_in   <= '0';
RST_in <= '0'; --RELEASING RESET SIGNAL FOR INSTRUCTION DECODER
wait for 20 ns;

--TEST CASE 1 Apply direct parallel input 
--R_component ADD INSTRUCTION 
--Instruction_input  <= "00000000011100110000001010110011"; 
--S_component SW instruction (testing)
Instruction_input  <= "01010100011100110010101010100011"; 

wait for 40 ns;

--Apply reset before next test case
RST_in <= '1';
wait for 20 ns;
RST_in <= '0';
wait for 20 ns;

--TEST CASE 2 Applying input through TDI , 
-- Try applying same bit stream 
--Releasing reset
RST_TAP <= '1'; 
wait for clk_period;

--Test sequence
--Example : Load instruction "00" (Scan instruction)
--Move TAP to ShiftIR state and provide input bits
TMS_in <= '1'; -- Move to Select DR Scan
wait for clk_period;
TMS_in <= '1'; -- Move to Select IR Scan
wait for clk_period;
TMS_in <= '0'; -- Move to Capture IR
wait for clk_period;
TMS_in <= '0'; -- Move to Shift IR
wait for clk_period;
TDI_in <= '0'; -- Send bit "0"
wait for clk_period/2;
TDI_in <= '0'; --Send bit '0' --SCAN INSTRUCTION 
wait for clk_period/2;
--SCAN INSTRUCTION SENT, NOW THE FSM SHOULD BE MOVED TO SHIFT_DR STATE USING TMS
--It should remain in SHIFT_DR state until the total length of scan chain here for convenience we assume it as one bit

TMS_in <= '1'; -- Move to EXIT IR
wait for clk_period;       
TMS_in <= '1'; -- Move to Update IR
wait for clk_period;
TMS_in <= '0';-- MOVE TO RUN TEST IDLE 
wait for clk_period; 
TMS_in <= '1'; --SELECT DR SCAN
wait for clk_period;
TMS_in <= '0'; --CAPTURE DR
wait for clk_period;
TMS_in <= '0'; --SHIFT DR STATE
wait for clk_period*32;
--Pushing instruction bitstream starting from MSB "00000000011100110000001010110011";
TDI_in <= '0'; -- MOVING '0'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '0'; -- MOVING '0'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '0'; -- MOVING '0'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '0'; -- MOVING '0'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '0'; -- MOVING '0'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '0'; -- MOVING '0'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '0'; -- MOVING '0'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '0'; -- MOVING '0'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '0'; -- MOVING '0'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '1'; -- MOVING '1'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '1'; -- MOVING '1'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '1'; -- MOVING '1'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '0'; -- MOVING '0'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '0'; -- MOVING '0'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '1'; -- MOVING '1'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '1'; -- MOVING '1'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '0'; -- MOVING '0'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '0'; -- MOVING '0'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '0'; -- MOVING '0'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '0'; -- MOVING '0'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '0'; -- MOVING '0'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '0'; -- MOVING '0'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '1'; -- MOVING '1'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '0'; -- MOVING '0'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '1'; -- MOVING '1'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '0'; -- MOVING '0'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '1'; -- MOVING '1'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '1'; -- MOVING '1'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '0'; -- MOVING '0'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '0'; -- MOVING '0'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '1'; -- MOVING '1'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
TDI_in <= '1'; -- MOVING '1'  THROUGH THE SCAN CHAIN REGISTER
wait for clk_period;
--Shifting of bits done
--Move to UPDATE DR STATE so that the data moves inside our design
TMS_in  <= '1'; --EXIT1 DR STATE
wait for clk_period;
TMS_in  <= '1'; --UPDATE DR STATE
wait for clk_period;
TMS_in  <= '0'; --RUN TEST IDLE STATE
wait for clk_period;  

----Finish simulation
wait;
end process;



--

end Behavioral;
