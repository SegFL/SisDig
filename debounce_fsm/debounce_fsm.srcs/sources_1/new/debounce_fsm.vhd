----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.01.2024 09:58:06
-- Design Name: 
-- Module Name: debounce_fsm - Behavioral
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



------------------------
--La entrada del modulo es la señal sw, cuando esta este estable por un tiempo mayor a 3*(2**N)*(Tclk)
-- la salida db se actualizara en funcion de sw.
-- El modulo controla que sw permaneza constante 3 veces (una vez cada (2**N)*(Tclk) )
-- antes de actualizar la salida (db)
-----------------------

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

entity debounce_fsm is
    port(
        sw,clk,reset: in std_logic;
        db :out std_logic
    );
end debounce_fsm;

architecture Behavioral of debounce_fsm is


    constant N :integer:=19;        --2**19*(20ns)=10ms
    signal q_reg,q_next :unsigned(N-1 downto 0):=(others=>'0');
    signal m_tick: std_logic:='0';
    
    type db_state_type is (zero,wait0_0,wait0_1,wait0_2,one,wait1_0,wait1_1,wait1_2);    
    
    signal state_reg, state_next: db_state_type;
begin


---------------------counter-------------------
process(clk)
begin
    if (clk'event and clk='1') then
        q_reg<=q_next;
    end if;
end process;

q_next<=q_reg + 1;
m_tick<= '1' when q_reg=0 else '0';         --    


---------------------state register-------------------
process(clk,reset)
begin
    if(reset='1') then
        state_reg<=zero;
    elsif (clk'event and clk='1') then
        state_reg<=state_next;
    end if;
end process;

---------------------   fsm -------------------
process(state_reg,m_tick)
begin
                        -- por dafault cada vez que arranca el process pongo todo a '0'
state_next<=state_reg;
db<='0';
case state_reg is
    when zero=> 
        if(sw='1') then 
            state_next<=wait1_0; 
        end if;
    when wait1_0=> 
        if(sw='0') then 
            state_next<=zero; 
        elsif(m_tick='1') then
            state_next<=wait1_1;
        end if;
    when wait1_1=> 
        if(sw='0') then 
            state_next<=zero; 
        elsif(m_tick='1')then
            state_next<=wait1_2;
        end if;
     when wait1_2=>
        if(sw='0') then
            state_next<=zero;
        elsif ( m_tick='1') then
            state_next<=one;
        end if;
     when one =>
        db<='1';
        if(sw='0') then
            state_next<=wait0_0;
        end if;
     when wait0_0=>
        if(sw='1') then
            state_next<=one;
        elsif(m_tick='1') then
            state_next<=wait0_1;
        end if;
     when wait0_1=>
        if(sw='1') then
            state_next<=one;
        elsif(m_tick='1') then
            state_next<=wait0_2;
        end if;
     when wait0_2=>
        if(sw='1') then
            state_next<=one;
        elsif (m_tick='1')then
            state_next<= zero;
         end if;
     end case;


end process;

end Behavioral;
