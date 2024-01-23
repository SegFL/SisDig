----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/22/2024 06:33:30 PM
-- Design Name: 
-- Module Name: uart_test_bench - Behavioral
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

entity uart_test_bench is
end uart_test_bench;



architecture Behavioral of uart_test_bench is

COMPONENT vio_0
  PORT (
    clk : IN STD_LOGIC;
    probe_in0 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_in1 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_in2 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_in3 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_in4 : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_in5 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    probe_out0 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_out1 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_out2 : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    probe_out3 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0) 
  );
END COMPONENT;


component uart is
    generic(
        D_BIT: integer:=8;
        SB_TICK: integer:= 16;
        DVSR:integer:=163;
        DVSR_BIT:integer:=8;
        FIFO_W: integer :=2
    );
    port(
        clk,reset:  in std_logic;
        rd_uart,wr_uart: in std_logic;
        rx: in std_logic;
        w_data: in std_logic_vector(8-1 downto 0);
        tx_full, rx_empty: out std_logic;
        r_data: out std_logic_vector(8-1 downto 0);
        tx: out std_logic
    );
end component;

    signal clk,reset : std_logic_vector(0 downto 0):="0";
    signal probe_in0,probe_in1, probe_in2,probe_in3,probe_in4,probe_out0,probe_out1,probe_out2: std_logic_vector(0 downto 0):="0";
    signal probe_in5,probe_out3 :std_logic_vector(8-1 downto 0):=(others=>'0'); 

    
begin
clk<=not clk after 5 ns;

DUT: uart
    port map(
        clk=>clk(0),
        reset=>reset(0),
        rd_uart=>probe_out0(0),
        wr_uart=>probe_out1(0),
        rx=>probe_out2(0),
        w_data=>probe_out3,
        tx_full=>probe_in0(0),
        rx_empty=>probe_in1(0),
        r_data=>probe_in5,
        tx=>probe_in2(0)
    );

your_instance_name : vio_0
  PORT MAP (
    clk => clk(0),
    probe_in0 => probe_in0,
    probe_in1 => probe_in1,
    probe_in2 => probe_in2,
    probe_in3 => probe_in3,
    probe_in4 => probe_in4,
    probe_in5 => probe_in5,
    probe_out0 => probe_out0,
    probe_out1 => probe_out1,
    probe_out2 => probe_out2,
    probe_out3 => probe_out3
  );


  

end Behavioral;
