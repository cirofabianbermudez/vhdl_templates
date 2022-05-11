-- Librerias
library IEEE;
use IEEE.std_logic_1164.all;

-- Entidad
entity cod_b is
	port(
	R_suma: in  std_logic_vector(3 downto 0);
	
	Un,Dec: out std_logic_vector(3 downto 0)
	);	
end;	 

-- Arquitectura
architecture arch of cod_b is	 
	
begin
	
	
	with R_suma select
	Dec <= "0000" when "0000" |"0001" | "0010"|"0011"|"0100"|"0101"|"0110"|"0111"|"1000"|"1001",
	"0001" when "1010" |"1011" | "1100"|"1101"|"1110"|"1111",
	"0000" when others;
	
with R_suma select
Un <= "0000" when "0000" |"1010",
	  "0001" when "0001" |"1011",
	  "0010" when "0010" |"1100",
      "0011" when "0011" |"1101",
      "0100" when "0100" |"1110",	 
	  "0101" when "0101" |"1111",	  
	  "0110" when "0110",		  
	  "0111" when "0111",
	  "1000" when "1000",
	  "1001" when "1001",  
	  "0000" when others;
	
	
	
end;