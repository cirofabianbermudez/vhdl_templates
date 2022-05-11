--librerias
library ieee;
use ieee.std_logic_1164.all;

entity top is
	port(
	bcd 		: 	in 	std_logic_vector(3 downto 0);
	seg	: 	out	std_logic_vector(6 downto 0);	-- abcdefg
	an: out std_logic_vector(3 downto 0)
	);
end;		 

architecture arch of top is

--component cod_7seg is
--	port(
--	bcd 		: 	in 	std_logic_vector(3 downto 0);
--	seg	: 	out	std_logic_vector(6 downto 0)	-- abcdefg
--	);
--end component;

begin
 --comp_7seg : cod_7seg port map(bcd => bcd, seg => seg);
 --comp_7seg : cod_7seg port map(bcd, seg);
 comp_7seg  : entity work.cod_7seg port map(bcd, seg);
					 
  an<="0000";
end;