library ieee;
use ieee.std_logic_1164.all;

entity paridad2 is
	port(
	D : in std_logic_vector(7 downto 0);
	P : in std_logic;
	DVD : out std_logic
	);	
end paridad2;		


architecture simple2 of paridad2 is
signal t1, t2: std_logic;

begin
	t1 <= (D(0) XOR D(1)) XOR (D(2) XOR D(3)) XOR (D(4) XOR D(5)) XOR (D(6) XOR D(7));
	t2 <= P;
	DVD <= t1 xnor t2; 
end simple2;
