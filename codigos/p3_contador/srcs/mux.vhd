library IEEE;
use IEEE.std_logic_1164.all;	 

entity mux_4_1 is
	generic(n : integer := 8); 		-- Tamanio de bundle
	port(
	I0,I1,I2,I3 : in std_logic_vector(n-1 downto 0);
	SEL : in std_logic_vector(1 downto 0);
	MUX_OUT : out std_logic_vector(n-1 downto 0)
	);	
end;	 

architecture arch of mux_4_1 is	
	constant zero : std_logic_vector(n-1 downto 0) := (others => '0');
begin

	-- Conditional signal assignment
	MUX_OUT <=	I0	when SEL = "00" else
				I1	when SEL = "01" else
				I2	when SEL = "10" else
				I3	when SEL = "11" else
				zero; 
				
	
end;