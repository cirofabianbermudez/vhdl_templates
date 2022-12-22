library ieee;
use ieee.std_logic_1164.all;

entity recepcion is
	port(
	RST : in  std_logic;
	CLK : in  std_logic;
	Rx  : in  std_logic;
--	RDD : in  std_logic;
--   D   : out std_logic_vector(8 downto 0);
   D   : out std_logic_vector(9 downto 0);
	EOR : out std_logic;
	DVD : out std_logic
	);	
end recepcion;

architecture bloques2 of recepcion is
signal baudios  :  std_logic_vector(12-1 downto 0);

component maquina_fsm2 
  port(
    RST	: in  std_logic;
    CLK : in  std_logic;
    Rx  : in  std_logic;
    B   : in  std_logic;
    --RDD : in  std_logic;
    EOR : out std_logic;
    S   : out std_logic
  );
end component;

component contador_prog 
	generic(n	: integer := 12);
	port(
		RST	:	in	std_logic;
		CLK	:	in	std_logic;
		H	:	in	std_logic;		-- Hab mux 1
		K	:	in	std_logic_vector(n-1 downto 0);
		Z	:	out	std_logic
	);
end component;

component paridad2 
	port(
	D : in std_logic_vector(7 downto 0);
	P : in std_logic;
	DVD : out std_logic
	);	
end component;

component registro_spo
	generic(n: integer := 10);
	port(
		RST	:	in	std_logic;
		CLK	:	in	std_logic;
		Rx	:	in	std_logic; 		-- Dato de entrada
		S	:	in	std_logic;		-- Selector
		P	:	out std_logic;		-- Bit de paridad
		R	:	out	std_logic_vector(n-1 downto 0)	-- Salida de 10 bits word
	);	
end component;


signal R		: std_logic_vector(9 downto 0);
signal B, S, P	: std_logic;
begin
	
  baudios <= "101000110000";		-- 4 veces mas rapido IMPORTANTE 1302 !!!!!! con ese valor funciona 10100010110 1303 funcina MUCHO mejor
  ModDivisor    : contador_prog port map( RST => RST, CLK => CLK, H => '1', K => baudios, Z => B);	-- listo
  ModMaquinaFSM : maquina_fsm2  port map( RST => RST, CLK => CLK, Rx => Rx, B => B, EOR => EOR, S => S); 
  ModRegistrosp : registro_spo  port map( RST => RST, CLK => CLK, Rx => Rx, S => S, P => P, R => R);
  ModParidad    : paridad2      port map( D => R(8 downto 1), P => P, DVD => DVD);
 
  D <= R;
end bloques2;
