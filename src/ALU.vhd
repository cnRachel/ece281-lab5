----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2025 02:50:18 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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

entity ALU is
    Port ( i_A : in STD_LOGIC_VECTOR (7 downto 0);
           i_B : in STD_LOGIC_VECTOR (7 downto 0);
           i_op : in STD_LOGIC_VECTOR (2 downto 0);
           o_result : out STD_LOGIC_VECTOR (7 downto 0);
           o_flags : out STD_LOGIC_VECTOR (3 downto 0));
end ALU;

architecture Behavioral of ALU is

    signal result : std_logic_vector(7 downto 0);
    signal sum    : std_logic_vector(8 downto 0);
    signal N,Z,C,V, add_ov, sub_ov: std_logic;

begin

    process(i_A, i_B, i_op)
    begin
        
        sum <= "000000000";
        
        case(i_op) is
            when "000" =>
                sum <= std_logic_vector(('0' & unsigned(i_A)) + ('0' & unsigned(i_B)));
                result <= std_logic_vector(unsigned(i_A) + unsigned(i_B));
            when "001" =>
                result <= std_logic_vector(unsigned(i_A) - unsigned(i_B));
                sum <= std_logic_vector(('0' & unsigned(i_A)) - ('0' & unsigned(i_B)));
            when "010" =>
                result <= i_A and i_B;
            when "011" =>
                result <= i_A or i_B;
            when others =>
                result <= std_logic_vector(unsigned(i_A) + unsigned(i_B));
                
        end case;
    end process;
        o_result <= result;
        
        N <= result(7);
        Z <= '1' when result = x"00" else '0';
        
        add_ov <= (i_A(7)and i_B(7) and (not result(7))) or ((not i_A(7)) and (not i_B(7)) and result(7)); 
        sub_ov <= (i_A(7) and (not i_B(7)) and (not result(7))) or ((not i_A(7))and i_B(7) and result(7));
        
        with i_op select
            V <= add_ov when "000",
                 sub_ov when "001",
                 '0' when others;
        with i_op select
            C <= sum(8) when "000",
                 not sum(8) when "001",
                 '0' when others;
        
        
        o_flags <= N & Z & C & V;

end Behavioral;
