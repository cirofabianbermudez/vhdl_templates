library ieee;
use ieee.std_logic_1164.all;


entity sistema is
	port(
		RST	:	in		std_logic;
		CLK	:	in		std_logic;
		STT	:	in 	std_logic;
		Rx		:	in 	std_logic;
		Tx		:	out	std_logic;
		AUX	:	out	std_logic_vector(1 downto 0);		-- para DVD y para Qn(0)
		D		:	out	std_logic_vector(7 downto 0)
	);
end sistema;

architecture Behavioral of sistema is


component recepcion
	port(
	RST : in  std_logic;
	CLK : in  std_logic;
	Rx  : in  std_logic;
   D   : out std_logic_vector(9 downto 0);
	EOR : out std_logic;
	DVD : out std_logic
	);	
end component;


component transmision
	port(
	RST : in  std_logic;
	CLK : in  std_logic;
	STT : in  std_logic;
	D   : in  std_logic_vector(7 downto 0);
	EOT : out std_logic;
	Tx  : out std_logic
	);	
end component;


component RAM_SL1P
	generic(
		m : integer := 8; -- numero de bits
		n : integer := 10; -- lineas de direccion
		k : integer := 1024  -- numero de localidades
	);
	port( 
		CLK: in std_logic;
		AE : in  std_logic_vector(n-1 downto 0); -- direccion de acceso   LISTO
		WE : in  std_logic;						 		-- escritura				LISTO
		DE : in  std_logic_vector(m-1 downto 0); -- dato de entrada			LISTO
		DS : out std_logic_vector(m-1 downto 0) -- dato de salida			LISTO
	);
end component;

component maquina_fsm3
  port(
    RST	: in  std_logic;
    CLK 	: in  std_logic;
    EOR  : in  std_logic;
    EOT	: in  std_logic;
    OPC	: out std_logic;
    WE 	: out std_logic
  );
end component;

component contador_ADHB
	generic(n : integer := 10);
	port(
		RST : in		std_logic;
		CLK : in		std_logic;
		OPC : in		std_logic;
		Q	 : out	std_logic_vector(n-1 downto 0)
	);
end component;

signal EOR_BUS, EOT_BUS, OPC_BUS, WE_BUS : std_logic;
signal DE_BUS	: std_logic_vector(9 downto 0);
signal DS_BUS	: std_logic_vector(7 downto 0);
signal AE_BUS	: std_logic_vector(9 downto 0);
begin 

  ModRecepcion		: recepcion 		port map(RST => RST, CLK => CLK, Rx  => Rx, D => DE_BUS, EOR => EOR_BUS, DVD => AUX(1));
  ModTransmision	: transmision		port map(RST => RST, CLK => CLK, STT => STT, D => DS_BUS, EOT => EOT_BUS, Tx => Tx);
  ModMaquina		: maquina_fsm3	   port map(RST => RST, CLK => CLK, EOR => EOR_BUS, EOT => EOT_BUS, OPC => OPC_BUS, WE => WE_BUS);
  ModTContador		: contador_ADHB	port map(RST => RST, CLK => CLK, OPC => OPC_BUS, Q => AE_BUS);
  ModRAM				: ram_sl1p			port map(CLK => CLK, AE => AE_BUS, WE => WE_BUS, DE => DE_BUS(8 downto 1), DS => DS_BUS);
  
  D <= DE_BUS(8 downto 1);
  AUX(0) <=  DE_BUS(0);

end Behavioral;