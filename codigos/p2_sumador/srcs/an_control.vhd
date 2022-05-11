library IEEE;
use IEEE.std_logic_1164.all;	 

entity an_control is
	port(
	 SEL : in std_logic;
	 ANODOS : out std_logic_vector(3 downto 0)
	);	
end;	 

architecture arch of an_control is	
	
begin

  ANODOS <= "1110" when SEL = '0' else "1101";	
	
end;