library ieee;
use ieee.std_logic_1164.all;
use	ieee.numeric_std.all;

entity contador_programable4 is
	generic(n	: integer := 4);
	port(
		RST	:	in	std_logic;
		CLK	:	in	std_logic;
		H	:	in	std_logic;		-- Hab mux 1
		K	:	in	std_logic_vector(n-1 downto 0);
		Z	:	out	std_logic
	);
end contador_programable4;


architecture programable of contador_programable4 is
signal Qp, Qn, Qmux	: std_logic_vector(n-1 downto 0);
signal Zp			: std_logic;
signal Zi, Zn		: std_logic;
constant zero		: std_logic_vector(n-1 downto 0) := (others =>'0');
begin
	-- Comparador 2
	Zn <= not(Zi) when Zp = '1' else Zi;
	Z <= Zi;
	
	-- Comparador
	Zp <= '1' when Qp = zero else '0';
		
	-- Mux1
	Qmux <=	Qp 	when H = '0' else std_logic_vector(unsigned(Qp)-1);
	
	-- Mux2
	Qn <= Qmux when Zp = '0' else K;
			
	process(RST, CLK)
	begin
		if RST = '1' then
			Qp <= (others => '0'); 
			Zi <= '0';
		elsif rising_edge(CLK) then
			Qp <= Qn;
			Zi <= Zn;
		end if;
	end process;
	
	
end programable;
