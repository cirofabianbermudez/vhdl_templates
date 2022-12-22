library ieee;
use ieee.std_logic_1164.all;		  

entity registro_spo is
	generic(n: integer := 10);
	port(
		RST	:	in	std_logic;
		CLK	:	in	std_logic;
		Rx	:	in	std_logic; 		-- Dato de entrada
		S	:	in	std_logic;		-- Selector
		P	:	out std_logic;		-- Bit de paridad
		R	:	out	std_logic_vector(n-1 downto 0)	-- Salida de 10 bits word
	);	
end registro_spo;


architecture registrosp of registro_spo is
signal Qp, Qn	: std_logic_vector(n-1 downto 0);

begin
	
	-- Combinacional
	with S select
		Qn <= 	Rx & Qp(n-1 downto 1)    when '1',
				   Qp                       when others;
	R <= Qp;
	P <= Qp(9);	  	-- Bit mas significativo es la paridad
	
	
	secuencial: process(RST, CLK)
	begin
		if RST = '1' then 
			Qp <= (others => '0');
		elsif rising_edge(CLK) then
			Qp <= Qn;
		end if;
	end process secuencial;
	
end registrosp;