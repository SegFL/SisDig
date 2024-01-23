----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.01.2024 12:06:37
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_bench is
--  Port ( );
end test_bench;

architecture Behavioral of test_bench is


component ROM is
    generic(N:integer:=8;DIR_SIZE:integer:=10);
    Port ( clk : in STD_LOGIC;
           dir : in STD_LOGIC_VECTOR (DIR_SIZE-1 downto 0);
           data : out STD_LOGIC_VECTOR (N-1 downto 0));
end component;


signal clk:std_logic:='0';
signal dir: std_logic_vector(10-1 downto 0):=(others=>'0');
signal data: std_logic_vector(8-1 downto 0):=(others=>'0');


begin

clk<= not clk after 5 ns;
dir<="0000000000" after 20 ns, "0000000001" after 50 ns, "0000000010" after 100 ns;


inst:  ROM
    Port map( 
    clk =>clk,
           dir=>dir,
           data=>data
           );



end Behavioral;
