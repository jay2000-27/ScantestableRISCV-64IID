----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.08.2024 22:23:30
-- Design Name: 
-- Module Name: TAP_BYPASS - Behavioral
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
use work.TAP_P.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TAP_BYPASS is
    Port ( TCLK_i : in STD_LOGIC;--BASE CLOCK
           TRST_i : in STD_LOGIC;--ASYNCHRONOUS RESET
           DR_CLOCK_i : in STD_LOGIC;--DATA REGISTER CLOCK ENABLE
           DR_SHIFT_i : in STD_LOGIC;--DATA REGISTER SHIFT STATE
           TDI_i : in STD_LOGIC;--DATA IN
           TDO_o : out STD_LOGIC);--SERIAL OUT
end TAP_BYPASS;

architecture Behavioral of TAP_BYPASS is

begin
DR_BYPASS: process(TCLK_i,TRST_i)
begin
 if(TRST_i = '1') then 
    TDO_o <= '0';
 elsif rising_edge(TCLK_i) then 
    if (DR_CLOCK_i = '1') then 
        TDO_o <= TDI_i and DR_SHIFT_i;
    end if;
 end if;
 end process;

end Behavioral;
