----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.01.2024 11:23:28
-- Design Name: 
-- Module Name: uart - Behavioral
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

--Because of the oversampling,the baud rate can only be a small 
--fraction of the system clock rate, and thus this scheme is
--not appropriate for a high data rate


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;





entity uart is
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
end uart;

architecture Behavioral of uart is

    signal tick: std_logic;
    signal rx_done_tick:std_logic;
    signal tx_fifo_out: std_logic_vector(8-1 downto 0);
    signal rx_data_out: std_logic_vector(8-1 downto 0);    
    signal tx_empty,tx_fifo_not_empty: std_logic;   
    signal tx_done_tick: std_logic;
    
    
begin
    baud_gen_unit: entity work.mod_m_counter(Behavioral)
        generic map(M=>DVSR,N=> DVSR_BIT)
        port map(clk=>clk,reset=>reset,q=>open,
                   max_tick=>tick);
                   
    uart_rx_unit: entity work.uart_rx(Behavioral)
       generic map(D_BIT=>D_BIT,SB_TICK=>SB_TICK)
       port map(clk=>clk,reset=>reset,rx=>rx,
       s_tick=>tick, rx_done_tick=>rx_done_tick,
       d_out=>rx_data_out);  
                   
    fifo_rx_unit:entity work.FIFO(Behavioral)
        generic map(N=>D_BIT,W=>FIFO_W)
        port map(clk=>clk,reset=>reset,rd=>rd_uart,
            wr=>rx_done_tick,data_in=>rx_data_out,
            empty=>rx_empty,full=>open,data_out=>r_data);
            
    fifo_tx_unit: entity work.FIFO(Behavioral)
        generic map(N=>D_BIT,W=>FIFO_W)
        port map(clk=>clk,reset=>reset,rd=>tx_done_tick,
            wr=>wr_uart,data_in=>w_data,empty=>tx_empty,
            full=>tx_full, data_out=>tx_fifo_out);
            
        uart_tx_unit: entity work.uart_tx(Behavioral)
            generic map(DBIT=>D_BIT,SB_TICK=>SB_TICK)
            port map(clk=>clk,reset=>reset,
            tx_start=>tx_fifo_not_empty,
            s_tick=>tick,din=>tx_fifo_out,
            tx_done_tick=>tx_done_tick, tx=>tx);
            
            
            
      tx_fifo_not_empty<=not tx_empty;


end Behavioral;
