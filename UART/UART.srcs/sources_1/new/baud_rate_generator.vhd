----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.01.2024 11:33:28
-- Design Name: 
-- Module Name: baud_rate_generator - Behavioral
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



--The baud rate generator generates a sampling signal 
--whose frequency is exactly 16 times
--the UART designated baud rate.

--To avoid creating a new clock domain and violating the
--synchronous design principle, the sampling signal should function as enable ticks rather
--than the clock signal to the UART receiver

--Fclk=50Mhz

-- Para un baudrate de 19.200, una Fclk=50MHz y 16 muestreos por cada bit transmitido es necesario un contador de modulo 163
--(50e6/(19200*16))=162.7
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity baud_rate_generator is
  Port ( 
    clk : in std_logic;
    tick : out std_logic
  );
end baud_rate_generator;

architecture Behavioral of baud_rate_generator is

--signal clk_i,tick_i: std_logic:='0';
constant contador: integer :=163;

component mod_m_counter is
        generic(N:integer:=4;M:integer:=10);--numero de bits, mod M
        port(
            clk,reset:in std_logic;
            max_tick: out std_logic;
            q:out std_logic_vector(N-1 downto 0)
        );

end component;


begin

    inst: mod_m_counter
        generic map(N=>contador ,M=>8)   --2^8=256
        port map(
            clk=>clk,
            reset=>'0',
            max_tick=>tick,
            q=>open
        ); 

    
end Behavioral;
