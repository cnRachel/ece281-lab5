----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:42:49 PM
-- Design Name: 
-- Module Name: controller_fsm - FSM
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

entity controller_fsm is
    Port ( 
           i_clk   : in STD_LOGIC;
           i_reset : in STD_LOGIC;
           i_adv : in STD_LOGIC;
           o_cycle : out STD_LOGIC_VECTOR (3 downto 0));
end controller_fsm;

architecture FSM of controller_fsm is

    type sm_cycle is (CLEAR, LOAD_A, LOAD_B, EXECUTE);
    signal f_state : sm_cycle := CLEAR;

begin

    state_reg : process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_reset = '1' then
                f_state <= CLEAR;
            else
                case f_state is
                    when CLEAR =>
                        if i_adv = '1' then f_state <= LOAD_A; end if;
                    when LOAD_A =>
                        if i_adv = '1' then f_state <= LOAD_B; end if;
                    when LOAD_B =>
                        if i_adv = '1' then f_state <= EXECUTE; end if;
                    when EXECUTE =>
                        if i_adv = '1' then f_state <= CLEAR; end if;
                end case;
            end if;
        end if;
    end process state_reg;
    
    o_cycle <= "0001" when f_state = CLEAR else
               "0010" when f_state = LOAD_A else
               "0100" when f_state = LOAD_B else
               "1000"; --EXECUTE
        


end FSM;
