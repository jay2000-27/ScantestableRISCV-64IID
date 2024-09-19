----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.08.2024 21:23:14
-- Design Name: 
-- Module Name: TAP_IR_DECODER - Behavioral
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

--entity TAP_IR_DECODER is
--    Port ( SHIFT_DR_i : in STD_LOGIC;
--           CLOCK_DR_i : in STD_LOGIC;
--           UPDATE_DR_i : in STD_LOGIC;
--           IR_i : in STD_LOGIC_VECTOR(ir_width_c-1 downto 0);
--            --EXTEST mode
--         --  test_mode_o : out STD_LOGIC; -- TO THE BOUNDARY SCAN REGISTER CHAIN
--           --TEST_MODE_o  : out STD_LOGIC; --to BSCAN-Register-Chain
--           SELECT_TDO_o : out STD_LOGIC_VECTOR(nr_of_dr_sels_c-1 downto 0);--Selects the appropriate DR for TDO mux
--           --BYPASS REGISTER CONTROL
--           SHIFT_BY_o : out STD_LOGIC;
--           CLOCK_BY_o : out STD_LOGIC;
--           --SCAN REGISTER CONTROL
--           SCAN_MODE_o : out STD_LOGIC;
--           SCAN_SHIFT_o : out STD_LOGIC;
--           SCAN_CLOCK_o : out STD_LOGIC;
--           SCAN_UPDATE_o : out STD_LOGIC);
--end TAP_IR_DECODER;

--architecture Behavioral of TAP_IR_DECODER is
--type instruction_t is (bypass_st, scanchain01_st);
----type instruction_t is (extest_st, intest_st, sample_preload_st, runbist_st, idcode_st, usercode_st, clamp_st, highz_st, bypass_st, astest_st, scanchain01_st);
--signal instr_s : instruction_t;

--begin

--  --! Decode the IR
-- process(IR_i)
--   begin
--     if    ( IR_i = std_logic_vector(to_unsigned(  0,ir_width_c)) ) then
--       instr_s <= scanchain01_st;         --: BSCAN
--     elsif ( IR_i = std_logic_vector(to_unsigned(  1,ir_width_c)) ) then
--       instr_s <= bypass_st;         --chain 2: BYPASS
--     else
--       instr_s <= bypass_st;         --chain 0: BYPASS
--     end if;
--   end process ;


--  --! EXTEST mode
----   test_mode_o <= '1'  when (instr_s = extest_st)  else '0';

--  --! Generate the selector for the TDO-MUX
--  select_tdo_o  <= std_logic_vector(to_unsigned(0,nr_of_dr_sels_c)) when( (instr_s = bypass_st) )else -- BY
--                   std_logic_vector(to_unsigned(1,nr_of_dr_sels_c)) when(instr_s = scanchain01_st) else -- SCAN REGISTER
--                   std_logic_vector(to_unsigned(0,nr_of_dr_sels_c));
--  --! BYPASS register control
--  shift_by_o  <= shift_dr_i;
--  clock_by_o  <= clock_dr_i  when (instr_s = bypass_st) else '0'; -- or instr_s = idcode_st)         else '0';

--  --! BS register control
----  shift_bs_o  <= shift_dr_i;
----  clock_bs_o  <= clock_dr_i  when ( (instr_s = extest_st) or
----                                    (instr_s = intest_st) or
----                                    (instr_s = sample_preload_st) ) else '0';
----  update_bs_o <= update_dr_i when ( (instr_s = extest_st) or
----                                    (instr_s = intest_st) or
----                                    (instr_s = sample_preload_st) ) else '0';
--  -- Wenn der astest (debug) oben mit hinein kommt, kann ich obige Signale für
--  -- das Debugregister verwenden, ich benötige lediglich ein zusätzliches
--  -- dbg0_mode-Signal um den Multiplexor des Debug-DR zu schalten. Allerdings
--  -- würde dann der Inhalt des Debug-DRs zerstört, wenn ich einen EXTEST fahre.
--  -- Also: eigene Signale (shift, clock, upd) für den Debugmode.

----  --! DEBUG register control and mode
----  dbg0_mode_o   <= '1'         when (instr_s = astest_st) else '0';
----  dbg0_shift_o  <= shift_dr_i;
----  dbg0_clock_o  <= clock_dr_i  when (instr_s = astest_st) else '0';
----  dbg0_upd_o    <= update_dr_i when (instr_s = astest_st) else '0';

--  --! Scan Chain 01
--  SCAN_MODE_o   <= '1'         when (instr_s = scanchain01_st) else '0';
--  SCAN_SHIFT_o  <= shift_dr_i  when (instr_s = scanchain01_st) else '0';
--  SCAN_CLOCK_o  <= clock_dr_i  when (instr_s = scanchain01_st) else '0';
--  SCAN_UPDATE_o    <= update_dr_i when (instr_s = scanchain01_st) else '0';
  

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

entity TAP_IR_DECODER is
    Port ( SHIFT_DR_i : in STD_LOGIC;
           CLOCK_DR_i : in STD_LOGIC;
           UPDATE_DR_i : in STD_LOGIC;
           IR_i : in STD_LOGIC_VECTOR(ir_width_c-1 downto 0);
            --EXTEST mode
         --  test_mode_o : out STD_LOGIC; -- TO THE BOUNDARY SCAN REGISTER CHAIN
           --TEST_MODE_o  : out STD_LOGIC; --to BSCAN-Register-Chain
           SELECT_TDO_o : out STD_LOGIC_VECTOR(nr_of_dr_sels_c-1 downto 0);--Selects the appropriate DR for TDO mux
           --BYPASS REGISTER CONTROL
           SHIFT_BY_o : out STD_LOGIC;
           CLOCK_BY_o : out STD_LOGIC;
           --SCAN REGISTER CONTROL
           SCAN_MODE_o : out STD_LOGIC;
           SCAN_SHIFT_o : out STD_LOGIC;
           SCAN_CLOCK_o : out STD_LOGIC;
           SCAN_UPDATE_o : out STD_LOGIC);
end TAP_IR_DECODER;

architecture Behavioral of TAP_IR_DECODER is
type instruction_t is (bypass_st, scanchain01_st);
--type instruction_t is (extest_st, intest_st, sample_preload_st, runbist_st, idcode_st, usercode_st, clamp_st, highz_st, bypass_st, astest_st, scanchain01_st);
signal instr_s : instruction_t;

begin

  --! Decode the IR
 process(IR_i)
   begin
     if    ( IR_i = std_logic_vector(to_unsigned(  0,ir_width_c)) ) then
       instr_s <= scanchain01_st;         --: BSCAN
     elsif ( IR_i = std_logic_vector(to_unsigned(  1,ir_width_c)) ) then
       instr_s <= bypass_st;         --chain 2: BYPASS
     else
       instr_s <= bypass_st;         --chain 0: BYPASS
     end if;
   end process ;


  --! EXTEST mode
--   test_mode_o <= '1'  when (instr_s = extest_st)  else '0';

  --! Generate the selector for the TDO-MUX
  select_tdo_o  <= std_logic_vector(to_unsigned(0,nr_of_dr_sels_c)) when( (instr_s = bypass_st) )else -- BY
                   std_logic_vector(to_unsigned(1,nr_of_dr_sels_c)) when(instr_s = scanchain01_st) else -- SCAN REGISTER
                   std_logic_vector(to_unsigned(0,nr_of_dr_sels_c));
  --! BYPASS register control
  shift_by_o  <= shift_dr_i;
  clock_by_o  <= clock_dr_i  when (instr_s = bypass_st) else '0'; -- or instr_s = idcode_st)         else '0';

  --! Scan Chain 01
  SCAN_MODE_o   <= '1'         when (instr_s = scanchain01_st) else '0';
  SCAN_SHIFT_o  <= shift_dr_i  when (instr_s = scanchain01_st) else '0';
  SCAN_CLOCK_o  <= clock_dr_i  when (instr_s = scanchain01_st) else '0';
  SCAN_UPDATE_o    <= update_dr_i when (instr_s = scanchain01_st) else '0';
  

end Behavioral;