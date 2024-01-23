
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FIFO is
    generic(
        N: integer:=8;   --numero de bits de cada palabra
        W: integer:=4  --longitud de la FIFO en bits=2**4=16
        );
      Port (
            clk,reset: in std_logic;
            data_in: in std_logic_vector(N-1 downto 0);
            data_out: out std_logic_vector(N-1 downto 0);
            wr:in std_logic;
            rd: in std_logic;
            empty,full: out std_logic
   );
end FIFO;

architecture Behavioral of FIFO is

    type reg_file_type is array (2**W-1 downto 0) of std_logic_vector(N-1 downto 0);
    
    signal reg_file : reg_file_type;
    signal wr_en : std_logic;
    signal wr_p_succ,wr_p_reg,wr_p_next: std_logic_vector(W-1 downto 0);            --write pointers
    signal r_p_succ,r_p_reg,r_p_next: std_logic_vector(W-1 downto 0);               --read pointers
    signal full_reg,full_next,empty_next: std_logic;                                                -- state flags
    signal empty_reg: std_logic;    
    signal wr_op: std_logic_vector(2-1 downto 0);
begin

process(clk,reset)
begin
    if(reset='1') then
        reg_file<=(others=>(others=>'0'));
    elsif( clk'event and clk='1') then
        if(wr_en='1') then         
                reg_file(to_integer(unsigned(wr_p_reg)))<=data_in;
        end if;
    end if;
end process;

data_out<=reg_file(to_integer(unsigned(r_p_reg)));
wr_en<= wr and (not full_reg);


----------------Registro para actualizar los punteros----------------------

process(clk,reset)
begin
    if(reset='1') then
        wr_p_reg<=(others=>'0');
        r_p_reg<=(others=>'0');
        full_reg<='0';
        empty_reg<='1';
    elsif(clk'event and clk='1') then
        wr_p_reg<=wr_p_next;
        r_p_reg<=r_p_next;
        full_reg<=full_next;
        empty_reg<= empty_next;
    end if;              
end process;


wr_p_succ<=std_logic_vector(unsigned(wr_p_reg)+1);
r_p_succ<=std_logic_vector(unsigned(r_p_reg)+1);



-------------------- Logica de punteros de read y write----------------


wr_op<=wr & rd;--wr_op variable de control para cada operacion

process(wr_p_reg,r_p_reg,wr_p_succ,r_p_succ,wr_op,empty_reg,full_reg)
begin
    wr_p_next<=wr_p_reg;
    r_p_next<=r_p_reg;
    full_next<=full_reg;
    empty_next<=empty_reg;   
    
    case wr_op is
        when "00"=>                     -- no op
        when "01"=>                     -- read
            if(empty_reg/='1') then     -- si no esta vacio leo
                r_p_next<=r_p_succ;
                full_next<='0';
                if(r_p_succ=wr_p_reg) then
                    empty_next<='1';
                end if;
           end if;
       when "10"=>                      --write
             if(full_reg/='1')then
                wr_p_next<=wr_p_succ;
                empty_next<='0';
                if(wr_p_succ=r_p_reg)then
                    full_next<='1';
                end if;
             end if;
       when others=>        --write/read
              wr_p_next<=wr_p_succ;         --no hace falta verificar si esta vacio o llena 
              r_p_next<=r_p_succ;
       end case;
            
end process;

full<=full_reg;
empty<=empty_reg;

end Behavioral;
