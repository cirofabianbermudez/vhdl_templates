library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM_SL1P is
	generic(
	m : integer := 8; -- numero de bits
	n : integer := 2; -- lineas de direccion
	k : integer := 4  -- numero de localidades
	);
	port( 
	CLK: in std_logic;
	AE : in  std_logic_vector(n-1 downto 0); -- direccion de acceso
	WE : in  std_logic;						 -- escritura
	DE : in  std_logic_vector(m-1 downto 0); -- dato de entrada
	DS : out std_logic_vector(m-1 downto 0) -- dato de salida
	);
end RAM_SL1P;

architecture Arreglo_generico of RAM_SL1P is
subtype Ancho_del_regitro is std_logic_vector(m-1 downto 0);
type Memoria is array (natural range <>) of Ancho_del_regitro;
signal Memoria_RAM : Memoria(0 to k-1);	   -- 2**n-1   
signal AS : std_logic_vector(n-1 downto 0);
begin										  
	-- lectura
	DS <= Memoria_RAM(to_integer(unsigned(AS)));
	
	Escritura:process(CLK)												    
	begin
		if(CLK'event and CLK = '1') then	
			if(WE = '1') then
				Memoria_RAM(to_integer(unsigned(AE))) <= DE;	
			end if;	
			AS <= AE;
		end if;
	end process Escritura;
	
end Arreglo_generico;
