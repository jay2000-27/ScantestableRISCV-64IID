----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.08.2024 18:09:30
-- Design Name: 
-- Module Name: TAP_IR_UNIT - Behavioral
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


--library IEEE;
--use IEEE.STD_LOGIC_1164.ALL;

---- Uncomment the following library declaration if using
---- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
--use work.TAP_P.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx leaf cells in this code.
----library UNISIM;
----use UNISIM.VComponents.all;

--entity TAP_IR_UNIT is
--    Port ( TCLK_i : in STD_LOGIC;
--           TRST_i : in STD_LOGIC;
--           IR_RST_i : in STD_LOGIC;
--           DATA_OUT_o : OUT STD_LOGIC;
--           SER_IN_i : in STD_LOGIC;
--           SER_OUT_o : out STD_LOGIC;
--           SHIFT_IR_i : in STD_LOGIC;
--           CLOCK_IR_i : in STD_LOGIC;
--           UPDATE_IR_i : in STD_LOGIC
--         );
--end TAP_IR_UNIT;
----------------------------------------------
----The code is converted such that only serial input is accepted 
----This is based  on my knowledge reading the book based on VLSI test principles. 
----Though the original refence code from Professor Siggelkov
---- has provision for parallel data in. It is tried to be avoided 
--architecture Behavioral of TAP_IR_UNIT is

--signal inter_data_s : std_logic;
--signal data_out_s   : std_logic;
--begin

--  --! Shifts the serial data
--  IR_SHIFT_PROCESS : process(TCLK_i,TRST_i)
--  begin
--    if (TRST_i='1') then
--      inter_data_s <= '0';
--    elsif (TCLK_i'event and TCLK_i='1') then
--      if (CLOCK_IR_i='1') then
--        if (SHIFT_IR_i='1') then
--          inter_data_s <= SER_IN_i;
--        end if;
--      end if;
--    end if;
--  end process;

--  --! Makes the parallel data visible
--  IR_UPDATE_PROCESS : process(TCLK_i,TRST_i,IR_RST_i)
--  begin
--    if (TRST_i='1') then
--      data_out_s <= IR_RST_i;
--    elsif (TCLK_i 'event and TCLK_i='1') then
--      if (UPDATE_IR_i='1') then
--        data_out_s <= inter_data_s;
--      end if;
--    end if;
--  end process;
  
--  SER_OUT_o  <= inter_data_s;
--  DATA_OUT_o <= data_out_s;



--end Behavioral;
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

entity TAP_IR_UNIT is
    Port ( TCLK_i : in STD_LOGIC;
           TRST_i : in STD_LOGIC;
           IR_RST_i : in STD_LOGIC;
           DATA_OUT_o : OUT STD_LOGIC;
           SER_IN_i : in STD_LOGIC;
           SER_OUT_o : out STD_LOGIC;
           SHIFT_IR_i : in STD_LOGIC;
           CLOCK_IR_i : in STD_LOGIC;
           UPDATE_IR_i : in STD_LOGIC
         );
end TAP_IR_UNIT;
--------------------------------------------
--The code is converted such that only serial input is accepted 
--This is based  on my knowledge reading the book based on VLSI test principles. 
--Though the original refence code from Professor Siggelkov
-- has provision for parallel data in. It is tried to be avoided 
architecture Behavioral of TAP_IR_UNIT is

signal inter_data_s : std_logic;
signal data_out_s   : std_logic;
begin

  --! Shifts the serial data
  IR_SHIFT_PROCESS : process(TCLK_i,TRST_i,CLOCK_IR_i,SHIFT_IR_i,SER_IN_i)
  begin
    if (TRST_i='1') then
      inter_data_s <= '0';
    elsif rising_edge(TCLK_i) then
      if (CLOCK_IR_i='1') then
        if (SHIFT_IR_i='1') then
          inter_data_s <= SER_IN_i;
        end if;
      end if;
    end if;
  end process;

  --! Makes the parallel data visible
  IR_UPDATE_PROCESS : process(TCLK_i,TRST_i,IR_RST_i,UPDATE_IR_i)
  begin
    if (TRST_i='1') then
      data_out_s <= IR_RST_i;
    elsif rising_edge(TCLK_i) then
      if (UPDATE_IR_i='1') then
        data_out_s <= inter_data_s;
      end if;
    end if;
  end process;
  
  SER_OUT_o  <= inter_data_s;
  DATA_OUT_o <= data_out_s;



end Behavioral;