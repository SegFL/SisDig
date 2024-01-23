----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.01.2024 11:38:17
-- Design Name: 
-- Module Name: mod_m_counter - Behavioral
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
use ieee.numeric_std.all;


entity mod_m_counter is
    generic(N:integer:=4;M:integer:=10);--numero de bits, mod M
    port(
        clk,reset:in std_logic;
        max_tick: out std_logic;
        q:out std_logic_vector(N-1 downto 0)
    );
end mod_m_counter;

architecture Behavioral of mod_m_counter is

    signal r_reg,r_next: unsigned(N-1 downto 0);
    
begin

    process(clk,reset)
    begin
        if(reset='1')then
            r_reg<=(others=>'0');
        elsif(clk'event and clk='1')then
            r_reg<=r_next;
        end if;
    end process;
    
    r_next<= (others=>'0') when r_reg=(M-1) else r_reg+1;
    
    q<= std_logic_vector(r_reg);
    max_tick<='1' when r_reg=(M-1) else '0';
    

end Behavioral;
