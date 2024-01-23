----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.01.2024 19:50:56
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



component RAM is
    generic(N:integer:=8;M:integer:=10);
    Port ( clk_wr,clk_rd : in STD_LOGIC;
           wr_en : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (N-1 downto 0);
           data_out : out STD_LOGIC_VECTOR (N-1 downto 0);
           wr_add : in STD_LOGIC_VECTOR (M-1 downto 0);
           rd_add : in STD_LOGIC_VECTOR (M-1 downto 0)
          );
end component;


signal clk_wr,clk_rd:std_logic:='0';
signal wr_en :std_logic:='1';
signal data_in,data_out: std_logic_vector(8-1 downto 0):=(others=>'0');
signal wr_add,rd_add:std_logic_vector(10-1 downto 0):=(others=>'0');


begin
clk_wr<=not clk_wr after 5 ns;
clk_rd<=not clk_rd after 10 ns;


data_in<="10011100"after 50 ns, "011000110" after 100 ns,"111001111" after 150 ns;
wr_add<="0000000000"after 50 ns,"0000000001"after 70 ns,"0000000001"after 100 ns,"0000000010"after 150 ns;
rd_add<="0000000000" after 10 ns,"0000000001"after 70 ns,"0000000001"after 100 ns,"0000000010"after 150 ns;
inst:RAM 
    generic map(8,10)
    Port map( clk_wr=>clk_wr,
           clk_rd=>clk_rd,
           wr_en=>wr_en,
           data_in=>data_in,
           data_out=>data_out,
           wr_add=>wr_add, 
           rd_add=>rd_add
          );


end Behavioral;
