----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.01.2024 12:13:58
-- Design Name: 
-- Module Name: uart_rx - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

--D_Bits:   7,8,9
--SB_TICKS:
    --#Bits de stop     SB_TICKS
    --      1               16
    --      1.5             24
    --      2               32

entity uart_rx is
    generic(
        D_BIT: integer:=8;   --#data bits
        SB_TICK:integer:=16;     --#ticks dot stop bits
        SAMPLING_TICKS: integer:=4  --#bits para el contador de s_reg(depende del oversampling que se hace de cada bit)
    );
     Port (
        clk,reset,s_tick : in std_logic;
        rx : in std_logic;              -- cuando no se esta transmitiendo deberia estar en '1' =idle
        rx_done_tick: out std_logic;
        d_out: out std_logic_vector(D_BIT-1 downto 0)
      );
end uart_rx;

architecture Behavioral of uart_rx is

    type state_type is (idle,start,data,stop);
    
    signal n_reg,n_next: unsigned(3-1 downto 0):=(others=>'0');             --contador de bits recibidos(si se tuvieran 9 bits de datos se deberia cambiar por (4-1 downto 0))
    signal s_reg,s_next: unsigned(SAMPLING_TICKS-1 downto 0):=(others=>'0');  --contador de ticks de muestreo 
    signal b_reg,b_next: std_logic_vector(D_BIT-1 downto 0);                           --registro de datos recibidos
    signal state_reg,state_next: state_type;
begin

process(clk,reset)
begin 
    if(reset='1') then
        state_reg<=idle;
        s_reg<=(others=>'0');
        n_reg<=(others=>'0');
        b_reg<=(others=>'0');  
    elsif( clk'event and clk='1') then
        state_reg<=state_next;
        s_reg<=s_next;
        n_reg<=n_next;
        b_reg<=b_next;     
    end if;
end process;


process(state_reg,s_reg,n_reg,b_reg,s_tick,rx)
begin
    state_next<=state_reg;
    s_next<=s_reg;
    n_next<=n_reg;
    b_next<=b_reg;
    rx_done_tick<='0';

    case state_reg is
        when idle =>
            if(rx='0') then
                state_next<=start;
                s_next<=(others=>'0');
            end if;
            
        when start=>
            if(s_tick='1') then
                if(s_reg=7) then
                    state_next<= data;
                    s_next<=(others=>'0');
                    n_next<=(others=>'0');
                else
                    s_next <= s_reg + 1;
                end if;
            end if;
            
         when data=>
            if(s_tick='1') then
                if(s_reg=15) then
                    s_next<=(others=>'0');
                    b_next<=rx & b_reg(D_BIT-1 downto 1);
                    if(n_reg=D_BIT-1) then
                        state_reg<=stop;
                    else 
                        n_next<=n_reg+1;
                    end if;           
                else
                    s_next<=s_reg+1;
                end if;
            end if;
          
         when stop=>
            if(s_tick='1') then
                if(s_reg=SB_TICK-1) then
                    state_next<=idle;
                    rx_done_tick<='1';
                else
                    s_next<=s_reg + 1;
                end if;
            end if;
        end case;
            
            
end process;

d_out<=b_reg;

end Behavioral;
