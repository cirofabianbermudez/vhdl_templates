library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
	generic( n : integer := 3 );
	port(
        A,B	 : in   std_logic_vector(n-1 downto 0);
        S	     : out  std_logic_vector(n downto 0) 
	);
end;	

architecture arch of adder is
begin	
	S <= std_logic_vector( unsigned('0'&A) + unsigned('0'&B) );
end arch;		