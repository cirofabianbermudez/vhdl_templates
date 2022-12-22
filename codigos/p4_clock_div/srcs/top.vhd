library ieee;
use 	ieee.std_logic_1164.all;
use	ieee.numeric_std.all;

entity luces is
	port(
		CLK	:	in	std_logic;
		LED	:	out	std_logic;
		SEL	:	in	std_logic_vector(1 downto 0)
	);
end luces;


architecture programable of luces is
signal v1,v2,v3,v4, mux_c :	std_logic_vector(26-1 downto 0);

-- mux
component mux_4_1_nb 
	generic(n : integer := 26); 		-- Tamanio de bundle
	port(
		I0,I1,I2,I3 : in 	STD_LOGIC_VECTOR(n-1 downto 0);
		SEL 		: in	STD_LOGIC_VECTOR(1 downto 0); 
		MUX_OUT		: out	STD_LOGIC_VECTOR(n-1 downto 0)
	);
end component mux_4_1_nb;

-- contador programable
component contador_programable4 
	generic(n	: integer := 26); -- con 25 bits si me alcanza para contar hasta el numero que quiero
	port(
		RST	:	in	std_logic;
		CLK	:	in	std_logic;
		H	:	in	std_logic;		-- Hab mux 1
		K	:	in	std_logic_vector(n-1 downto 0);
		Z	:	out	std_logic
	);
end component contador_programable4;

begin
	v1 <= "10111110101111000001111111"; -- 2s
	v2 <= "01011111010111100000111111";	-- 1s
	v3 <= "00000000000000000000000001";  -- 0.5s
	v4 <= "00000000000000000000000000";  -- 0.25s
	
	
	mux4_1	:	mux_4_1_nb						port map(I0 => v1, I1 => v2, I2 => v3, I3 => v4, SEL => SEL, MUX_OUT => mux_c);
	clk1s 	:	contador_programable4 		port map(RST => '0', CLK => CLK, H => '1', K => mux_c, Z => LED);
	

end programable;
