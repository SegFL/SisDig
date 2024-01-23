-- 14.09.20 ----------------------------------- Susana Canel ----------------------------------- ProdEntN_tb_arch_excel.vhdl
-- TESTBENCH DEL PRODUCTO DE ENTEROS DE N BITS USANDO ARCHIVOS. GENERACION DE UN ARCHIVO DE SALIDA CON FORMATO 
-- COMPATIBLE CON UNA PLANILLA ELECTRONICA COMO, POR EJEMPLO, MICROSOFT OFFICE EXCEL.

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;                    
----------------------------------------------------------------------------------------------------------------------------
entity file_test_bench is
end entity file_test_bench;
----------------------------------------------------------------------------------------------------------------------------
architecture Test of file_test_bench is 
  ------------------------------------------------------
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
  -------------------------------------------------------
  constant BITS          : positive := 8;
  constant M          : positive := 10;
  signal   a_t           : std_logic_vector(  BITS-1 downto 0) := (others=>'0');
 signal   add_a_t           : std_logic_vector(M-1 downto 0);
  signal   b_t           : std_logic_vector(  BITS-1 downto 0) := (others=>'0');
  signal   add_b_t           : std_logic_vector(M-1 downto 0);
 

  file     inputhandle   : text;             
  file     outputhandle  : text;             



signal         clk_wr            :std_logic;
signal         clk_rd            :std_logic;
signal         wr_en             :std_logic;
signal         data_in           :std_logic_vector(BITS-1 downto 0);
signal         data_out          :std_logic_vector(BITS-1 downto 0);
signal         wr_add            :std_logic_vector(M-1 downto 0);
signal         rd_add            :std_logic_vector(M-1 downto 0);

begin

dut: RAM 
    generic map(N=> BITS,M=>M)
    Port map( 
            clk_wr=>clk_wr,
           clk_rd=>clk_rd ,
           wr_en=>wr_en ,
           data_in=>data_in ,
           data_out=> data_out ,
           wr_add=>wr_add ,
           rd_add=>rd_add
          );


  Prueba: 
  process is
    variable numeroDeLinea     : integer := 0;        
    variable estado            : file_open_status;    
    variable buffer1           : line;                
    variable buffer2           : line;                
    variable auxA              : integer;             
    variable auxB              : integer;             
    variable auxP              : integer;             

  begin
    report "Verificando el funcionamiento de lectrura y escritura de una memora RAM de 8 BITS de datos y 10 BITS de tamaño de palabra"
    severity note;
    ------------------------------------------------------------------------------------------------------------------------
    file_open( estado, inputhandle, "input_file.mem", read_mode );               
    assert estado=open_ok
      report "No se pudo abrir el archivo con los datos"
      severity failure;
    file_open( estado, outputhandle, "output_file.txt", write_mode );   -- archivo de salida con extension para planilla excel         
    assert estado=open_ok
      report "No se pudo crear el archivo para escribir los resultados"
      severity failure;

    write( buffer2, string'( "ESCRITURA Y LECTRUA DE MEMORIA RAM DE 8 BITS" & LF)); -- LF: line feed, caracter predefinido, ASCII 10 decimal (0A)
    writeline( outputhandle, buffer2 );

    write( buffer2, string'( "a_t" &  HT ) );                          -- HT: horizontal tab, salta a la proxima posicion de tabulado,      
    writeline( outputhandle, buffer2 );
    write( buffer2, string'( "b_t" &  HT ) );                          -- ASCII 9 decimal (09)
    writeline( outputhandle, buffer2 );
    write( buffer2, string'( "add_a_t" &  HT ) ); 
    writeline( outputhandle, buffer2 );
    write( buffer2, string'( "add_b_t" & LF ) ); 
    writeline( outputhandle, buffer2 );

    --------------------------------------------------------------------------------------------------------------------------------
    while not( endfile( inputhandle ) ) loop
     readline( inputhandle, buffer1 );   
--     read( buffer1, auxA );
--     read( buffer1, auxB );
--     read( buffer1, auxP );
--                                                                       
--     a_t <= std_logic_vector( to_signed( auxA, a_t'length ) );
--     add_a_t <= std_logic_vector( to_signed( auxB, add_a_t'length ) );
--     wait for 2 ns;
--
--     write( buffer2, integer'image ( auxA ) &  HT );   
--     write( buffer2, integer'image ( auxB ) &  HT );   
--     write( buffer2, integer'image ( auxP ) ); 
--     writeline ( outputhandle, buffer2 );
--
--     numeroDeLinea := numeroDeLinea + 1;
--  

    end loop;	
    ------------------------------------------------------------------------------------------------------------------------

    file_close(  inputhandle );                                    -- cierre de archivos
    file_close( outputhandle );

    report "Verificacion exitosa!"
    severity note;
    wait;	
  end process Prueba;
end architecture Test;
----------------------------------------------------------------------------------------------------------------------------
