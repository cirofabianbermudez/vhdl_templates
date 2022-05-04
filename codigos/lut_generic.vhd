-- Librerias
library IEEE;
use IEEE.std_logic_1164.all;

-- Entidad
entity lut_generic is
	port(
	X2, X1, X0 : in  std_logic;
	-- X : in  std_logic_vector(2 downto 0);
	Y		   : out std_logic
	);	
end;	 

-- Arquitectura
architecture arch of lut_generic is	 
	-- signal aux1, aux2, aux3 : std_logic;
	--signal t_signal : std_logic_vector(2 downto 0);

begin
	-- TIPO 1
	Y <=  ((not X2) and (not X1) and X0) or ((not X2) and X1 and (not X0)) or (X2 and (not X1) and (not X0));
	
	-- TIPO 2
	--aux1 <= ((not X2) and (not X1) and X0);
	--aux2 <= ((not X2) and X1 and (not X0));
	--aux3 <= (X2 and (not X1) and (not X0));
	--Y <= aux1 or aux2 or aux3;
	
	-- TIPO 3 
	--t_signal <= X2 & X1 & X0; -- & es el operador concatenacion
	
	--with t_signal select
		--Y <= '1' when "001" | "010" | "100", '0' when others;  
	
	
end;