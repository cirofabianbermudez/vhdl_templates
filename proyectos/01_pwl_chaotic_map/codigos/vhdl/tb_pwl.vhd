library ieee;
use ieee.std_logic_1164.all;

entity tb_pwl is
	generic(n : integer := 64);
end entity;

architecture tb of tb_pwl is
	signal		RST,CLK,START	:	std_logic := '0';
	signal		xn			    :	std_logic_vector(n-1 downto 0);
begin 
	
	UUT	: entity work.top generic map(n => 64) port map(CLK,RST,START,xn);
	RST <= '1', '0' after 20 ns;
	CLK <= not CLK after 10 ns;				-- La mitad del perido que es 20 ns
	
	
	START <= '1' after 200 ns, '0' after 200000 ns;
	
	-- NOTA: Simular por almenos 1000 ns	   
	-- wait for 10 ns;
end architecture;
