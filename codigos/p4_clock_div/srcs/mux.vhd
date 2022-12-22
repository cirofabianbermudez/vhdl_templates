-- Librerias
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;	

-- Entidad
entity mux_4_1_nb is
	generic(n : integer := 25); 		-- Tamanio de bundle
	port(
		I0,I1,I2,I3 : in 	STD_LOGIC_VECTOR(n-1 downto 0);
		SEL 		: in	STD_LOGIC_VECTOR(1 downto 0); 
		MUX_OUT		: out	STD_LOGIC_VECTOR(n-1 downto 0)
	);
end mux_4_1_nb;

-- Arquitectura
architecture arch_mux of mux_4_1_nb is
	constant zero : std_logic_vector(n-1 downto 0) := (others => '0');
begin 
--	---- Selected signal assignment
	with SEL select
		MUX_OUT <=  I0	when "00",
					I1	when "01",
					I2	when "10",
					I3	when "11",
					zero when others;		
	
end	arch_mux;
