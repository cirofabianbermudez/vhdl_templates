library IEEE;
use IEEE.std_logic_1164.all;	 

entity mux_2_1 is
	generic(n : integer := 4); 		-- Tamanio de bundle
	port(
	I0,I1 : in std_logic_vector(n-1 downto 0);
	SEL : in std_logic;
	MUX_OUT : out std_logic_vector(n-1 downto 0)
	);	
end;	 

architecture arch of mux_2_1 is	
	
begin

  MUX_OUT <= I0 when SEL = '0' else I1;	
	
end;