----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/17/2024 11:44:00 AM
-- Design Name: 
-- Module Name: test_bench - Behavioral
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



entity test_bench is
--  Port ( );
end test_bench;



architecture Behavioral of test_bench is


component FIFO is
    generic(
        N: integer:=8;   --numero de bits de cada palabra
        W: integer:=3  --longitud de la FIFO en bits=2**3=8
        );
      Port (
            clk,reset: in std_logic;
            data_in: in std_logic_vector(N-1 downto 0);
            data_out: out std_logic_vector(N-1 downto 0);
            wr:in std_logic;
            rd: in std_logic;
            empty,full: out std_logic
   );
end component;
    
    constant N: integer:=8;
    constant W: integer:=4;
    
    signal clk,reset,wr,rd: std_logic:='0';
    signal empty: std_logic:='1';
    signal full: std_logic:='0';
    signal data_in,data_out: std_logic_vector(N-1 downto 0):=(others=>'0');
    
    
    
begin

clk<=not clk after 5 ns;
reset<='1' after 1 ns, '0' after 5 ns;
--data_in<="10011100" after 5 ns, "11111110" after 15 ns,"10100101" after 25 ns;
--rd<='1' after 15 ns, '0' after 25 ns,'1' after 35 ns, '0' after 45 ns;
--wr<='1' after 5 ns, '0' after 25 ns;
wr<='0' after 1 ns,'1' after 5 ns, '0' after 155 ns;-- escribo 16 datos
rd<='0' after 1 ns,'1' after 155 ns;

data_in<= 
"00000001" after 5 ns,
"00000010" after 15 ns,
"00000011" after 25 ns,
"00000100" after 35 ns,
"00000101" after 45 ns,
"00000110" after 55 ns,
"00000111" after 65 ns,
"00001000" after 75 ns,
"00001001" after 85 ns,
"00001010" after 95 ns,
"00001011" after 105 ns,
"00001100" after 115 ns;



dut: FIFO 
    generic map ( N=>N, W=>W )
      Port map(
            clk=>clk,
            reset=>reset,
            data_in=>data_in,
            data_out=>data_out,
            wr=>wr,
            rd=>rd,
            empty=>empty,
            full=>full
   );
   
end Behavioral;
