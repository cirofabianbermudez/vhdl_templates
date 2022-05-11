library ieee;
use ieee.std_logic_1164.all;
use	ieee.numeric_std.all;

entity cont_0 is
	generic(n	: integer := 4);
	port(
		RST	:	in	std_logic;
		CLK	:	in	std_logic;
		OPC	:	in	std_logic_vector(1 downto 0);		-- Selector
		K	:	in	std_logic_vector(n-1 downto 0);
		S   :   out std_logic_vector(n-1 downto 0);
		Z	:	out	std_logic
	);
end;


architecture arch of cont_0 is
signal Qp, Qn, Qmux	: std_logic_vector(n-1 downto 0);
signal Zp			: std_logic;
constant zero		: std_logic_vector(n-1 downto 0) := (others =>'0');
begin

	-- Comparador
	Zp <= '1' when Qp = zero else '0';
	Z <= Zp;		
		
	with OPC select
	Qn <=     K                                when "00", 			-- Carga
    		  std_logic_vector(unsigned(Qp)-1) when "01",		    -- Resta
    		  std_logic_vector(unsigned(Qp)+1) when "10",			-- Suma
			  Qp when others;
		
	process(RST, CLK)
	begin
		if RST = '1' then
			Qp <= (others => '0'); 
		elsif rising_edge(CLK) then
			Qp <= Qn;
		end if;	 
	
	end process;
	S<=Qp;
	
end arch;
