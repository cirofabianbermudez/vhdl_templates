library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--OPC
--00 hold
--01 inc
--10 dec
--11 clear

entity contador_ADHB is
	generic(n : integer := 4);
	port(
		RST : in	std_logic;
		CLK : in	std_logic;
		OPC : in	std_logic;
		Q	: out	std_logic_vector(n-1 downto 0)
	);
end contador_ADHB;


architecture contador of contador_ADHB is
signal Qp, Qn	:	std_logic_vector(n-1 downto 0);
begin
	process(RST, CLK)
	begin
		if RST = '1' then 
			QP <= (others => '0');
		elsif rising_edge(CLK) then 
			Qp <= Qn;
		end if;
	end process;
	
	
	Qn <= Qp when OPC = '0' else std_logic_vector(unsigned(Qp)+1);	
	
--	with OPC select
--	Qn <= 	Qp 									when "00",
--			std_logic_vector(unsigned(Qp)+1)	when "01",
--			(others => '0') 					when others;
		
	Q <= Qp;
	
end contador;
