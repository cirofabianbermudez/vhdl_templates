library IEEE;
use IEEE.std_logic_1164.all;  

entity mux_4_1 is  
	generic(n : integer :=32 ); --- arquitectura de n-bits
	port( 
		f0,f1,f2,f3:in std_logic_vector(n-1 downto 0);	
		SEL: in std_logic_vector(1 downto 0);
		F_OUT:out std_logic_vector(n-1 downto 0)
	);
end;  
--Arquitectura
architecture arch of mux_4_1 is	 
constant zero: std_logic_vector(n-1 downto 0):=(others=>'0');

begin							 
	
F_OUT<=     f0 when SEL="00" else 
			f1 when SEL="01" else 
			f2 when SEL="10" else
			f3 when SEL="11" else 
		    zero;
	
end;
