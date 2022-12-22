library ieee;
use ieee.std_logic_1164.all;

entity transmision is
	port(
	RST : in  std_logic;
	CLK : in  std_logic;
	STT : in  std_logic;
	D   : in  std_logic_vector(7 downto 0);
	EOT : out std_logic;
	Tx  : out std_logic
	);	
end transmision;

architecture bloques of transmision is
signal baudios  :  std_logic_vector(14-1 downto 0);

component maquina_fsm
  port(
    RST	: in  std_logic;
    CLK : in  std_logic;
    B   : in  std_logic;
    STT : in  std_logic;
    EOT : out std_logic;
    M   : out std_logic_vector(3 downto 0)
  );
end component;

component contador_prog 
	generic(n	: integer := 14);
	port(
		RST	:	in	std_logic;
		CLK	:	in	std_logic;
		H	:	in	std_logic;		-- Hab mux 1
		K	:	in	std_logic_vector(n-1 downto 0);
		Z	:	out	std_logic
	);
end component;


component paridad
  port(
    D	: in  std_logic_vector(7 downto 0);
    P   : out std_logic
  );
end component;

component mux_salida
  port(
    M  : in std_logic_vector(3 downto 0);
    D  : in std_logic_vector(7 downto 0);
    P  : in std_logic;
    Tx : out std_logic
  );
end component;

signal dato : std_logic_vector(7 downto 0);
signal M	: std_logic_vector(3 downto 0);
signal P, B	: std_logic;
begin
	
  baudios <= "10100010110010";		-- 9600 10100010110000   10100010101111
  dato <= D;							-- x"41";
  ModDivisor    : contador_prog port map( RST => '0', CLK => CLK, H => '1', K => baudios, Z => B);
  ModMaquinaFSM : maquina_fsm   port map( RST => RST, CLK => CLK, B => B, STT => STT, EOT => EOT, M => M);
  ModParidad    : paridad       port map( D => dato, P => P);
  ModMuxsalida  : mux_salida    port map( M => M, D => dato, P => P, Tx => Tx);

end bloques;

