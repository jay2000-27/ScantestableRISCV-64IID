----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.07.2024 21:33:39
-- Design Name: 
-- Module Name: RISC_V_Decoder_Top - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RISCV_Decoder_Top is
    Port (
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        Input_instruction : in STD_LOGIC_VECTOR (31 downto 0);
        LOAD_ENABLE_OUT       : out STD_LOGIC;
        SHIFT_ENABLE_OUT      : out STD_LOGIC;
        Decoded_Output    : out STD_LOGIC_VECTOR(49 downto 0)
--        LED_DECODED_OPCODE : out STD_LOGIC_VECTOR (3 downto 0);
--        DECODED_FUNC : out STD_LOGIC_VECTOR(4 downto 0);
--        OTHER_DATA   : out STD_LOGIC
        
        --debug ports for internal signal
--        DEBUG_MY_INSTRUCTION : out STD_LOGIC_VECTOR (28 downto 0);
--        DEBUG_Decoded_R : out STD_LOGIC_VECTOR (49 downto 0);
--        DEBUG_Decoded_RW : out STD_LOGIC_VECTOR (49 downto 0);
--        DEBUG_Decoded_S  : out STD_LOGIC_VECTOR(49 downto 0);
--        DEBUG_Decoded_B  : out STD_LOGIC_VECTOR(49 downto 0);
--        DEBUG_Decoded_J  : out STD_LOGIC_VECTOR(49 downto 0);
--        DEBUG_Decoded_ULUI : out STD_LOGIC_VECTOR(49 downto 0);
--        DEBUG_Decoded_UAUIPC : out STD_LOGIC_VECTOR(49 downto 0);
--        DEBUG_Decoded_IR : out STD_LOGIC_VECTOR(49 downto 0);
--        DEBUG_Decoded_IRW : out STD_LOGIC_VECTOR(49 downto 0);
--        DEBUG_Decoded_IF : out STD_LOGIC_VECTOR(49 downto 0);
--        DEBUG_Decoded_IECSR : out STD_LOGIC_VECTOR(49 downto 0);
--        DEBUG_Decoded_IL : out STD_LOGIC_VECTOR(49 downto 0);
--        DEBUG_Decoded_JALR : out STD_LOGIC_VECTOR(49 downto 0);
--        DEBUG_Decoded_storagedata : out STD_LOGIC_VECTOR(40 downto 0) --Value entering shift register





    );
end RISCV_Decoder_Top;
architecture Behavioral of RISCV_Decoder_top is
    signal CLK_S              : STD_LOGIC;
    signal RST_S              : STD_LOGIC;
    signal sig_my_instruction : STD_LOGIC_VECTOR (28 downto 0);
    signal sig_Decoded_R : STD_LOGIC_VECTOR (49 downto 0);
    signal sig_Decoded_RW : STD_LOGIC_VECTOR (49 downto 0);
    signal sig_Decoded_S : STD_LOGIC_VECTOR(49 downto 0);
    signal sig_Decoded_B : STD_LOGIC_VECTOR(49 downto 0);
    signal sig_Decoded_J : STD_LOGIC_VECTOR(49 downto 0);
    signal sig_Decoded_ULUI: STD_LOGIC_VECTOR(49 downto 0);
    signal sig_Decoded_UAUIPC: STD_LOGIC_VECTOR(49 downto 0);
    signal sig_Decoded_IR : STD_LOGIC_VECTOR(49 downto 0);
    signal sig_Decoded_IRW : STD_LOGIC_VECTOR(49 downto 0);
    signal sig_Decoded_IF  : STD_LOGIC_VECTOR(49 downto 0);
    signal sig_Decoded_IECSR : STD_LOGIC_VECTOR(49 downto 0);
    signal sig_Decoded_IL    : STD_LOGIC_VECTOR(49 downto 0);
    signal sig_Decoded_JALR  : STD_LOGIC_VECTOR(49 downto 0);
    signal sig_opcode : STD_LOGIC_VECTOR (3 downto 0);
    signal sig_R_enable : STD_LOGIC;
    signal sig_RW_enable : STD_LOGIC;
    signal sig_S_enable : STD_LOGIC;
    signal sig_B_enable : STD_LOGIC;
    signal sig_J_enable : STD_LOGIC;
    signal sig_ULUI_enable: STD_LOGIC;
    signal sig_UAUIPC_enable: STD_LOGIC;
    signal sig_IR_enable : STD_LOGIC;
    signal sig_IRW_enable : STD_LOGIC;
    signal sig_IF_enable : STD_LOGIC;
    signal sig_IECSR_enable: STD_LOGIC;
    signal sig_IL_enable : STD_LOGIC;
    signal sig_JALR_enable : STD_LOGIC;    
    signal sig_loadregister_enable: std_logic;
    signal sig_register_enable: std_logic;
    signal DECODED            : std_logic_vector(49 downto 0);
    signal storage_data    : STD_LOGIC_VECTOR(40 downto 0);
    signal serial_out_s           : STD_LOGIC; --! Serial output from shift register, not given as output     

begin
    CLK_S <= CLK;
    RST_S <= RST;
        -- Instantiate Initial_Decoder
        E1: entity work.Initial_Decoder
            port map (
                CLK           => CLK_S,
                RST           => RST_S,
                instruction_in => Input_instruction,
                my_instruction => sig_my_instruction
            );
    
        -- Extract Opcode for Routing
        sig_opcode <= sig_my_instruction(3 downto 0);
    
        -- Decode Routing
        sig_R_enable <= '1' when sig_opcode = "0001" else '0';
        sig_RW_enable <= '1' when sig_opcode = "0010" else '0';
        sig_S_enable <= '1' when sig_opcode = "0011" else '0';
        sig_B_enable <= '1' when sig_opcode = "0100" else '0';
        sig_J_enable <= '1' when sig_opcode = "0101" else '0';
        sig_ULUI_enable <= '1' when sig_opcode ="0110" else '0';
        sig_UAUIPC_enable<= '1' when sig_opcode ="0111" else '0';
        sig_IR_enable <= '1' when sig_opcode = "1000" else '0';
        sig_IRW_enable <='1' when sig_opcode ="1001" else '0';
        sig_IF_enable <= '1' when sig_opcode = "1010" else '0';
        sig_IECSR_enable <= '1' when sig_opcode ="1011" else '0';
        sig_IL_enable    <= '1' when sig_opcode = "1100" else '0';
        sig_JALR_enable <= '1' when sig_opcode = "1101" else '0';        
    -- Instantiate R_Component
        E2: entity work.R_component
            port map (
                CLK => CLK_S,
                RST => RST_S,
                instruction_in_R => sig_my_instruction,
                ENABLE_R          => sig_R_enable,
                Decoded_R => sig_Decoded_R
            );
    -- Instantiate R_word_component
            E3: entity work.R_word_component
                port map (
                    RST               => RST_S,
                    CLK               => CLK_S,
                    instruction_in_RW => sig_my_instruction,
                    ENABLE_RW         => sig_RW_enable,
                    Decoded_RW => sig_Decoded_RW
                );
    -- Instantiate S_component
            E4: entity work.S_component
                port map (
                     CLK         => CLK_S,
                     RST         => RST_S,
                     instruction_in_S => sig_my_instruction,
                     ENABLE_S         => sig_S_enable,
                     Decoded_S => sig_Decoded_S
                );
     --Instantiate B_component
             E5: entity work.B_component 
                 port map (
                     CLK => CLK_S,
                     RST => RST_S,
                     instruction_in_B => sig_my_instruction,
                     ENABLE_B         => sig_B_enable,
                     Decoded_B => sig_Decoded_B
                   );
       --Instantiate J_component
             E6: entity work.J_component
                 port map (
                     CLK              => CLK_S,
                     RST              => RST_S,
                     instruction_in_J => sig_my_instruction,
                     ENABLE_J         => sig_J_enable,
                     Decoded_J        => sig_Decoded_J
                     );       
              E7: entity work.U_LUI_component
                    port map(
                     CLK => CLK_S,
                     RST => RST_S,
                     instruction_in_ULUI => sig_my_instruction,
                     ENABLE_ULUI         => sig_ULUI_enable,
                     Decoded_ULUI        => sig_Decoded_ULUI
                   );   
             E8: entity work.U_AUIPC_component
                     port map(
                         CLK                   => CLK_S,
                         RST                   => RST_S,
                         instruction_in_UAUIPC => sig_my_instruction,
                         ENABLE_UAUIPC         => sig_UAUIPC_enable,
                         Decoded_UAUIPC        => sig_Decoded_UAUIPC
                     );  
                     
              E9: entity work.I_R_component
                       port map(
                           CLK               => CLK_S,
                           RST               => RST_S,
                           instruction_in_IR => sig_my_instruction,
                           ENABLE_IR         => sig_IR_enable,
                           Decoded_IR        => sig_Decoded_IR
                       );
        --Instantiate I_R_Word_component
              E10: entity work.I_R_Word_component
                       port map(
                             CLK                 => CLK_S,
                             RST                 => RST_S,
                             instruction_in_IRW => sig_my_instruction,
                             ENABLE_IRW          => sig_IRW_enable,
                             Decoded_IRW        => sig_Decoded_IRW
                         ); 
           --Instantiate I_Fence_Component               
              E11: entity work.I_Fence_component
                           port map(
                               CLK               => CLK_S,
                               RST               => RST_S,
                               instruction_in_IF => sig_my_instruction,
                               ENABLE_IF         => sig_IF_enable,
                               Decoded_IF        => sig_Decoded_IF
                           ); 
          --Instantiate I_ECSR_Component   
                 E12: entity work.I_ECSR_component
                             port map(
                                 CLK                 => CLK_S,
                                 RST                 => RST_S,
                                 instruction_in_IECSR => sig_my_instruction,
                                 ENABLE_IECSR         => sig_IECSR_enable,
                                 Decoded_IECSR        => sig_Decoded_IECSR
                             ); 
        --Instantiate I_L_component
                 E13: entity work.I_L_component
                              port map(
                                   CLK               => CLK_S,
                                   RST               => RST_S,
                                   instruction_in_IL  => sig_my_instruction,
                                   ENABLE_IL          => sig_IL_enable,
                                   Decoded_IL         => sig_Decoded_IL
                               ); 
       --Instantiate I_JALR_component
                   E14: entity work.I_JALR_component
                               port map(
                                   CLK                 => CLK_S,
                                   RST                 => RST_S,
                                   instruction_in_JALR  => sig_my_instruction,
                                   ENABLE_JALR          => sig_JALR_enable,
                                   Decoded_JALR         => sig_Decoded_JALR
                                 );                                                                                                                                           
            -- Map internal signals to debug ports
            
--                DEBUG_MY_INSTRUCTION <= sig_my_instruction;--After initial decoder entering other components
--                DEBUG_Decoded_R <= sig_Decoded_R;--After R_component
--                DEBUG_Decoded_RW <= sig_Decoded_RW;--after r_w_component
--                DEBUG_Decoded_S  <= sig_Decoded_S; --After S_component
--                DEBUG_Decoded_B  <= sig_Decoded_B; --After B_component
--                DEBUG_Decoded_J  <= sig_Decoded_J; --After J_component
--                DEBUG_Decoded_ULUI  <= sig_Decoded_ULUI; --After U_LUI_component
--                DEBUG_Decoded_UAUIPC <= sig_Decoded_UAUIPC;--After U_AUIPC_component
--                DEBUG_Decoded_IR <= sig_Decoded_IR;--After U_AUIPC_component
--                DEBUG_Decoded_IRW <= sig_Decoded_IRW; --After I_R_Word_Component
--                DEBUG_Decoded_IF <= sig_Decoded_IF; --After I_R_Word_Component
--                DEBUG_Decoded_IECSR <= sig_Decoded_IECSR; --After I_R_Word_Component
--                DEBUG_Decoded_IL <= sig_Decoded_IL; --After I_R_Word_Component
--                DEBUG_Decoded_JALR <= sig_Decoded_JALR; --After I_R_Word_Component

              
--                LED_DECODED_OPCODE <= SIG_DECODED_R(3 downto 0);
--                DECODED_FUNC       <= SIG_DECODED_R(12 downto 8);
     -- Route Output Based on Opcode
                    process(CLK,RST,sig_opcode, sig_Decoded_R, 
                    sig_Decoded_R,sig_Decoded_S,sig_Decoded_B,
                    sig_Decoded_J,sig_Decoded_ULUI,sig_Decoded_UAUIPC,
                    sig_Decoded_IR,sig_Decoded_IRW,sig_Decoded_IF,
                    sig_Decoded_IECSR, sig_Decoded_IL,sig_Decoded_JALR)
                    begin
                    if RST = '1' then 
                     --RESET ALL THE OUTPUT SIGNALS DEBUG PORTS
--                       LED_DECODED_OPCODE <= (others => '0');
--                       DECODED_FUNC       <= (others => '0');
--                       OTHER_DATA         <= '0';
                       DECODED            <= (others => '0');
                     elsif rising_edge(CLK) then 
                        case sig_opcode is
                            when "0001" => -- R_component type
                                DECODED <= sig_Decoded_R;
                                sig_loadregister_enable <= '1';
                                sig_register_enable <= '0';
                            when "0010" => -- R_Word_component type
                                DECODED <= sig_Decoded_RW;
                                sig_loadregister_enable <= '1';
                                sig_register_enable <= '0';
                            when "0011" =>--S_component type
                                 DECODED <= sig_Decoded_S;
                                 sig_loadregister_enable <= '1';               
                                 sig_register_enable <= '0'; 
                            when "0100" => --B_component type
                                 DECODED <= sig_Decoded_B;
                                 sig_loadregister_enable <= '1';                
                                 sig_register_enable <= '0'; 
                            when "0101" => --J_component type
                                 DECODED <= sig_Decoded_J;
                                 sig_loadregister_enable <= '1';                
                                 sig_register_enable <= '0';
                            when "0110" => --U_LUI_component type
                                 DECODED <= sig_Decoded_ULUI;
                                 sig_loadregister_enable <= '1';
                                 sig_register_enable <= '0';
                            when "0111" => --U_AUIPC_component type
                                 DECODED <= sig_Decoded_UAUIPC;
                                 sig_loadregister_enable <= '1';
                                 sig_register_enable <= '0'; 
                            when "1000" => --I_R_component type
                                 DECODED <= sig_Decoded_IR;
                                 sig_loadregister_enable <= '1';
                                 sig_register_enable <= '0'; 
                            when "1001" =>--I_R_Word_component type
                                 DECODED <= sig_Decoded_IRW;
                                 sig_loadregister_enable <= '1';
                                 sig_register_enable <= '0'; 
                           when "1010" =>--I_F_component type
                                 DECODED <= sig_Decoded_IF;
                                 sig_loadregister_enable <= '1';
                                 sig_register_enable <= '0';  
                           when "1011" =>--I_ECSR_component type
                                 DECODED <= sig_Decoded_IECSR;
                                 sig_loadregister_enable <= '1';
                                 sig_register_enable <= '0'; 
                           when "1100" =>--I_L_component type
                                 DECODED <= sig_Decoded_IL;
                                 sig_loadregister_enable <= '1';
                                 sig_register_enable <= '0';
                           when "1101" =>--I_JALR_component
                                 DECODED <= sig_Decoded_JALR;
                                 sig_loadregister_enable <= '1';
                                 sig_register_enable <= '0';                                                                                                                                                                                                                                                                                                                          
                           when others => 
                                sig_loadregister_enable <= '0';
                                sig_register_enable  <= '1';
                                
                         end case;
                     end if;
--                     LED_DECODED_OPCODE <= DECODED(3 downto 0);
--                     DECODED_FUNC       <= DECODED(12 downto 8);             
                   end process;
Decoded_Output  <= DECODED;
LOAD_ENABLE_OUT     <= sig_loadregister_enable;
SHIFT_ENABLE_OUT    <= sig_register_enable;
--                   LED_DECODED_OPCODE <= DECODED(3 downto 0);
--                   DECODED_FUNC       <= DECODED(12 downto 8);
--storage_data <= DECODED(49 downto 13) & DECODED(7 downto 4);
----DEBUG_Decoded_storagedata <= storage_data;
--     --Instantiate U_LUI_component
--      E15: entity work.shift_reg_internal
--          port map(
--          CLK_i        => CLK_S,
--          RST_i        => RST_S,
--          LOAD_ENABLE  => sig_loadregister_enable,
--          SHIFT_ENABLE => sig_register_enable,
--          DATA_IN         => storage_data,
--          SERIAL_OUT      => serial_out_s
--          );
--     LED_DECODED_OPCODE <= DECODED(3 downto 0);
--     DECODED_FUNC       <= DECODED(12 downto 8);
--     OTHER_DATA         <= serial_out_s;

end Behavioral;