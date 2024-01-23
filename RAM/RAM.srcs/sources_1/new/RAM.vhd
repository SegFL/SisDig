----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.01.2024 19:12:14
-- Design Name: 
-- Module Name: RAM - Behavioral
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
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM is
    generic(N:integer:=8;M:integer:=10);
    Port ( clk_wr,clk_rd : in STD_LOGIC;
           wr_en : in STD_LOGIC;
           data_in : in STD_LOGIC_VECTOR (N-1 downto 0);
           data_out : out STD_LOGIC_VECTOR (N-1 downto 0);
           wr_add : in STD_LOGIC_VECTOR (M-1 downto 0);
           rd_add : in STD_LOGIC_VECTOR (M-1 downto 0)
          );
end RAM;

architecture Behavioral of RAM is

    type matrix is array (2**M-1 downto 0) of std_logic_vector(N-1 downto 0);


signal mem: matrix:=(others=>(others=>'0'));
begin

process(clk_wr,wr_en)
begin
    if(clk_wr'event and clk_wr='1' and wr_en='1') then
        mem(to_integer(unsigned(wr_add)))<=data_in;
    end if;
end process;


process(clk_rd)
begin
    if(clk_rd'event and clk_rd='1')then
        data_out<=mem(to_integer(unsigned(rd_add))) ;
    end if;
end process;
end Behavioral;
