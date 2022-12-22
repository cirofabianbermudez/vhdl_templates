library ieee;
use ieee.std_logic_1164.all;

entity mux_salida is
  port(
    M  : in std_logic_vector(3 downto 0);
    D  : in std_logic_vector(7 downto 0);
    P  : in std_logic;
    Tx : out std_logic
    );
end mux_salida;

architecture seleccion of mux_salida is
begin

	with M select
		Tx <=  	 '1'   when "0000",
					 '0'   when "0001",
					 D(0)  when "0010",
					 D(1)  when "0011",
					 D(2)  when "0100",
					 D(3)  when "0101",
					 D(4)  when "0110",
					 D(5)  when "0111",
					 D(6)  when "1000",
					 D(7)  when "1001",
					 P     when "1010",
					 '1'   when others;
	
end seleccion;
