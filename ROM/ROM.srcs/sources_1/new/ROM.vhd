----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12.01.2024 11:39:55
-- Design Name: 
-- Module Name: ROM - Behavioral
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





--N: cantidad de bits por palabra
--DIR_SIZE:cantidad de bits de direccion o sea 2^DIR_SIZE palabras 


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;



entity ROM is
    generic(N:integer:=8;DIR_SIZE:integer:=10);
    Port ( clk : in STD_LOGIC;
           dir : in STD_LOGIC_VECTOR (DIR_SIZE-1 downto 0);
           data : out STD_LOGIC_VECTOR (N-1 downto 0));
end ROM;

architecture Behavioral of ROM is
    

    type rom_type is array(2**DIR_SIZE-1  downto 0) of std_logic_vector(N-1 downto 0);
    constant mem: rom_type:=
        (0=>x"aa",1=>x"ab",2=>x"ac",others=>x"00");
    
begin

    process(clk)
    begin
        if(clk'event and clk='1') then
            data<= mem(to_integer(unsigned(dir)));        
        end if;
    end process;
end Behavioral;
