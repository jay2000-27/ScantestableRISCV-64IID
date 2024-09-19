----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 18.08.2024 15:01:06
-- Design Name: 
-- Module Name: TAP_FSM - Behavioral
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

entity TAP_FSM is
    Port ( TCLK_i : in STD_LOGIC;--BASE CLOCK
           TRST_i : in STD_LOGIC;--ASYNC RESET
           TMS_i : in STD_LOGIC;--MODE CONTROL EXTERNAL INPUT
           IR_SHIFT_o : out STD_LOGIC;--FOR MUX EITHER TDI/TDO
           IR_CLOCK_o : out STD_LOGIC;--CLOCK FOR IR SHIFT REG
           IR_UPDATE_o : out STD_LOGIC;--CLOCK FOR IR HOLD REG
           DR_SHIFT_o : out STD_LOGIC;--FOR MUX EITHER TDI/TDO TO DATA REG
           DR_CLOCK_o : out STD_LOGIC;--CLOCK THE DR SHIFT REG
           DR_UPDATE_o : out STD_LOGIC;--ACTIVATE THE DR HOLD REG
           JTAG_RST_o : out STD_LOGIC;--SOFTWARE RESET OF JTAG
           IRDR_SELECT_o : out STD_LOGIC;--SELECT BETWEEN DR OR IR TDO OUTPUT
           TDO_ENA_o : out STD_LOGIC);--DRIVES TDO EITHER TO HIGH IMPEDENCE 'Z' OR ENABLE
end TAP_FSM;

architecture Behavioral of TAP_FSM is

type state_type_t is (reset_state_st, run_test_idle_st,
                      select_dr_scan_st, capture_dr_st, shift_dr_st, exit1_dr_st, pause_dr_st, exit2_dr_st, update_dr_st,
                      select_ir_scan_st, capture_ir_st, shift_ir_st, exit1_ir_st, pause_ir_st, exit2_ir_st, update_ir_st
                      ); --! The definition of possible states
signal state_s, nextstate_s : state_type_t; --! The actual state and the next state

signal TRST_s: std_logic;
signal IR_SHIFT_s : std_logic; --! For Mux: either shift tdi/tdo or capture data
signal IR_CLOCK_s : std_logic; --! Clock the IR shift register (Latch?)
signal IR_UPDATE_s   : std_logic; --! Clock (activate) the IR hold register
signal ir_cap_s   : std_logic; --! Load parallel data to IR

signal DR_SHIFT_s : std_logic; --! For Mux: either shift tdi/tdo or capture data
signal DR_CLOCK_s : std_logic; --! Clock the DR shift register (Latch?)
signal DR_UPDATE_s   : std_logic; --! Clock (activate) the DR hold register
signal dr_cap_s   : std_logic; --! Load parallel data to DR

signal JTAG_RST_s : std_logic; --! Reset state; also software reset
signal IRDR_SELECT_s : std_logic; --! Select either IR or DR for TDO
signal TDO_ENA_s : std_logic; --! Select TDO or 'Z'

begin
trst_s <= TRST_i;
  
-------------------------------------------------------------------------------
--! Clock the states
-------------------------------------------------------------------------------
  pos_proc_delay : process(TCLK_i, TRST_s)
  begin
    if (TRST_s='1') then
      state_s <= reset_state_st;
    elsif (TCLK_i'event and TCLK_i='1' ) then--CHANGE DONE HERE 1
      state_s <= nextstate_s;
    end if;
  end process; 
-------------------------------------------------------------------------------
-- END: Clock the states
-------------------------------------------------------------------------------
  
-------------------------------------------------------
--! Processes TAP FSM
-------------------------------------------------------
  fsm_tap : process(state_s, tms_i)
  begin
    nextstate_s <= state_s;
    case state_s is
      when reset_state_st      => if(tms_i = '0')then
                                    nextstate_s <= run_test_idle_st;
                                  end if;
      when run_test_idle_st    => if (tms_i = '1') then
                                    nextstate_s <= select_dr_scan_st;
                                  end if;
      when select_dr_scan_st   => if (tms_i = '1') then
                                    nextstate_s <= select_ir_scan_st;
                                  else -- '0'
                                    nextstate_s <= capture_dr_st;
                                  end if;
      when capture_dr_st       => if (tms_i = '0') then
                                    nextstate_s <= shift_dr_st;
                                  else -- '1'
                                    nextstate_s <= exit1_dr_st;
                                  end if;
      when shift_dr_st         => if (tms_i = '1') then
                                    nextstate_s <= exit1_dr_st;
                                  end if;
      when exit1_dr_st         => if (tms_i = '0') then
                                    nextstate_s <= pause_dr_st;
                                  else -- '1'
                                    nextstate_s <= update_dr_st;
                                  end if;
      when pause_dr_st         => if (tms_i = '1') then
                                    nextstate_s <= exit2_dr_st;
                                  end if;
      when exit2_dr_st         => if (tms_i = '0') then
                                    nextstate_s <= shift_dr_st;
                                  else -- '1'
                                    nextstate_s <= update_dr_st;
                                  end if;
      when update_dr_st        => if (tms_i = '0') then
                                    nextstate_s <= run_test_idle_st;
                                  else -- '1'
                                    nextstate_s <= select_dr_scan_st;
                                  end if;
      when select_ir_scan_st   => if (tms_i = '1') then
                                    nextstate_s <= reset_state_st;
                                  else -- '0'
                                    nextstate_s <= capture_ir_st;
                                  end if;
      when capture_ir_st       => if (tms_i = '0') then
                                    nextstate_s <= shift_ir_st;
                                  else -- '1'
                                    nextstate_s <= exit1_ir_st;
                                  end if;
      when shift_ir_st         => if (tms_i = '1') then
                                    nextstate_s <= exit1_ir_st;
                                  end if;
      when exit1_ir_st         => if (tms_i = '0') then
                                    nextstate_s <= pause_ir_st;
                                  else -- '1'
                                    nextstate_s <= update_ir_st;
                                  end if;
      when pause_ir_st         => if (tms_i = '1') then
                                    nextstate_s <= exit2_ir_st;
                                  end if;
      when exit2_ir_st         => if (tms_i = '0') then
                                    nextstate_s <= shift_ir_st;
                                  else -- '1'
                                    nextstate_s <= update_ir_st;
                                  end if;
      when update_ir_st        => if (tms_i = '0') then
                                    nextstate_s <= run_test_idle_st;
                                  else -- '1'
                                    nextstate_s <= select_dr_scan_st;
                                  end if;
      when others              => nextstate_s <= reset_state_st;
    end case;
  end process;
-------------------------------------------------------
-- END: Processes TAP FSM
-------------------------------------------------------

-------------------------------------------------------------------------------
--! Output processing
-------------------------------------------------------------------------------

  IR_SHIFT_o     <= IR_SHIFT_s;
  IR_UPDATE_s       <= '1'        when (state_s = update_ir_st)    else '0';
  IR_UPDATE_o       <= IR_UPDATE_s;
  ir_cap_s       <= '1'        when (state_s = capture_ir_st)   else '0';  --xx
  IR_CLOCK_o     <= IR_CLOCK_s;
  JTAG_RST_o     <= JTAG_RST_s;
  DR_SHIFT_o     <= DR_SHIFT_s;
  DR_UPDATE_s       <= '1'        when (state_s = update_dr_st)    else '0';
  DR_UPDATE_o       <= DR_UPDATE_s;
  dr_cap_s       <= '1'        when (state_s = capture_dr_st)   else '0';  --xx
  DR_CLOCK_o     <= DR_CLOCK_s;
  IRDR_SELECT_s  <= '0' when ( (state_s = exit2_dr_st)   or (state_s = exit1_dr_st)       or (state_s = shift_dr_st) or
                               (state_s = pause_dr_st)   or (state_s = select_ir_scan_st) or (state_s = update_dr_st) or
                               (state_s = capture_dr_st) or (state_s = select_dr_scan_st) ) else '1';
  TDO_ENA_o     <= TDO_ENA_s;
  IRDR_SELECT_o <= IRDR_SELECT_s;

  neg_sync_signals : process(TCLK_i, TRST_s)
  begin
    if (TRST_s='1') then
      TDO_ENA_s  <= '0';
      IR_SHIFT_s <= '0';
      IR_CLOCK_s <= '0';
      DR_SHIFT_s <= '0';
      DR_CLOCK_s <= '0';
      JTAG_RST_s <= '1';
    elsif (TCLK_i'event and TCLK_i='0') then
      if (state_s = shift_ir_st) then
        IR_SHIFT_s <= '1';
      else
        IR_SHIFT_s <= '0';
      end if;
      if ((state_s = shift_ir_st) or (state_s = capture_ir_st)) then
        IR_CLOCK_s <= '1';
      else
        IR_CLOCK_s <= '0';
      end if;
      --if ((state_s = shift_dr_st) or (state_s = exit1_dr_st)) then
      if ((state_s = shift_dr_st)) then
        DR_SHIFT_s <= '1';
      else
        DR_SHIFT_s <= '0';
      end if;
      if ((state_s = shift_dr_st) or (state_s = capture_dr_st)) then
        DR_CLOCK_s <= '1';
      else
        DR_CLOCK_s <= '0';
      end if;
      if ((state_s = shift_ir_st) or (state_s = shift_dr_st)) then
        TDO_ENA_s <= '1';
      else
        TDO_ENA_s <= '0';
      end if ;
      if (state_s = reset_state_st) then
        JTAG_RST_s <= '1';
      elsif (state_s = run_test_idle_st) then--CHANGE DONE HERE 2
        JTAG_RST_s <= '0';
      end if ;
    end if;
  end process;--irdr_select_s
-------------------------------------------------------------------------------
-- END: Output processing
-------------------------------------------------------------------------------


end Behavioral;
