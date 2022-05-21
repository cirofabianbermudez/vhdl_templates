library ieee;
use ieee.std_logic_1164.all;

entity encoder is
	port(
	cond 		: 	in 	std_logic_vector(3 downto 0);	--valores del condicional
	sel	        : 	out	std_logic_vector(1 downto 0) --valores del selector
	);
end;		 

architecture arch of encoder is
begin
	with cond select

	sel <=   "00" when "0001", --  "1"     
			 "01" when "0010", --  "2" 
			 "10" when "0100", --  "4" 
			 "11" when "1000", --  "8" 
			 "00" when others;
					 
end arch;