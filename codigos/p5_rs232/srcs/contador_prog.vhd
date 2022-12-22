library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity contador_prog is
	generic(n	: integer := 4);
	port(
		RST	:	in	std_logic;
		CLK	:	in	std_logic;
		H		:	in	std_logic;			-- Hab mux 1
		K		:	in	std_logic_vector(n-1 downto 0);
		Z		:	out	std_logic
	);
end contador_prog;

architecture programable of contador_prog is
signal Qp, Qn, Qmux	: std_logic_vector(n-1 downto 0);
signal Zp				:	std_logic;
constant zero			: std_logic_vector(n-1 downto 0) := (others =>'0');
begin
	Zp <= '1' when Qp = zero else '0';
	
	Z <= Zp;

	-- Mux1
	Qmux <=	Qp 	when H = '0' else std_logic_vector(unsigned(Qp)-1);
	
	-- Mux2
	Qn <= Qmux when Zp = '0' else K;
		
	process(RST, CLK)
	begin
		if RST = '1' then
			Qp <= (others => '0');
		elsif rising_edge(CLK) then
			Qp <= Qn;	
		end if;
	end process;
end programable;
