----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.01.2024 11:49:35
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
use ieee.numeric_std.all ;

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





component debounce_fsm is
    port(
        sw,clk,reset: in std_logic;
        db :out std_logic
    );
end component;


    signal clk,sw,reset,db : std_logic:='0';
    signal  control : unsigned(2-1 downto 0):="00";
begin

clk<=not clk after 10 ns; --peridod de 20ns 
sw<=not sw after 10 ms when control="01" else 
    not sw after 50 ns when control="10" else
    not sw after 50 ms;

PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      control <= "01" AFTER 20 ms;
      control <= "10" AFTER 200 ns;
      -- Otros valores o acciones según sea necesario
    END IF;
  END PROCESS;



dut: debounce_fsm
    port map(
        sw=>sw,
        clk=>clk, 
        db=>db,
        reset=>reset
    );





end Behavioral;
