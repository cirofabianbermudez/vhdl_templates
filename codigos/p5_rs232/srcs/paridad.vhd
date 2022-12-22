library ieee;
use ieee.std_logic_1164.all;

entity paridad is
	port(
	D : in std_logic_vector(7 downto 0);
	P : out std_logic
	);	
end paridad;		


architecture simple of paridad is
begin
	P <= (D(0) XOR D(1)) XOR (D(2) XOR D(3)) XOR (D(4) XOR D(5)) XOR (D(6) XOR D(7));
end simple;
