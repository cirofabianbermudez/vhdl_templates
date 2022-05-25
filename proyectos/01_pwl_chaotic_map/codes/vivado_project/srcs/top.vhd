library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity pwl is 
	generic( n : integer := 64);  -- Tamanio de palabra
	port(	
		CLK   : in  std_logic;
		RST   : in  std_logic;
		START : in  std_logic;
		XOUT  : out std_logic_vector(n-1 downto 0)
);
end;

architecture Behavioral of pwl is		 
	signal SEL :std_logic;
	signal SEL2, HAB: std_logic_vector(1 downto 0);	 
	signal C1 : std_logic_vector(3 downto 0);
	signal Xn,Xn_1,M1,M2,S1,S2,A1,A2,Fx: std_logic_vector(n-1 downto 0);
	signal m1_rom, m2_rom, b1_rom, b2_rom, a_rom, x0_rom : std_logic_vector(n-1 downto 0);
begin		

	
--Bloque Mux1 para escoger entre condicion inicial y xn
comp_mux01  : entity work.mux generic map(n => 64) port map(x0_rom,Xn_1,SEL,Xn);

--Bloque de la maquina de estados	 
comp_cu: entity work.cu port map(RST,CLK,START,HAB,SEL);   
	
--Bloque comparador para determinar el intervalo donde se encuentra Xn
comp_comp  : entity work.comp generic map(n => 64) port map(a_rom,Xn,C1);		
	
--Bloque del segundo selector para determinar el valor de f	 
 comp_cod  : entity work.encoder  port map(C1,SEL2);	 
	 
--Bloque para guardar los valores de los parametros
comp_rom : entity work.rom generic map(n => 64) port map(m1_rom,m2_rom,b1_rom,b2_rom,a_rom,x0_rom);	
	
--BLoques multiplicadores 
 comp_mult01   : entity work.mult generic map(n => 64) port map(m1_rom,Xn,M1);
 
 comp_mult02   : entity work.mult generic map(n => 64) port map(m2_rom,Xn,M2);

--Bloques sumadores
 comp_adder01  : entity work.adder generic map(n => 64) port map(M1,b1_rom,A1); 	  
	 
 comp_adder02  : entity work.adder generic map(n => 64) port map(M2,b2_rom,A2); 
	 
--Bloques restadores	
 comp_sub01    : entity work.sub generic map(n => 64) port map(M1,b1_rom,S1);	
	
 comp_sub02    : entity work.sub generic map(n => 64) port map(M2,b2_rom,S2);

	 
 --Bloque para escoger el umbral adecuado	 	 				
comp_mux_PWL  : entity work.mux_4_1 generic map(n => 64) port map(A1,A2,S2,S1,SEL2,Fx);  
	
--Bloque de registro que permite obtener las iteraciones o pararlas	 
comp_ff_hab: entity work.ff_hab generic map(n => 64)  port map(RST,CLK,HAB,Fx,Xn_1);	
	
--Salida  
XOUT <= Xn_1;	

end Behavioral;
