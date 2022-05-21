
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity restador is 
    generic( n : integer := 4  );  -- Tamanio de palabra
port (    X,U0,U1,U2,U3 : in   std_logic_vector(n-1 downto 0);
          --R0,R1,R2,R3: out std_logic_vector(n-1 downto 0);
          Vr:out std_logic_vector(3 downto 0)
);

end;

architecture Behavioral of restador is		 

signal  R0,R1,R2,R3: std_logic_vector(n-1 downto 0) ; 


begin			 
--Bloques restadores	
comp_sub01    : entity work.sub generic map(n => 4) port map(U0,X,R0);	
	
comp_sub02    : entity work.sub generic map(n => 4) port map(U1,X,R1); 

comp_sub03    : entity work.sub generic map(n => 4) port map(U2,X,R2);

comp_sub04    : entity work.sub generic map(n => 4) port map(U3,X,R3);

	 
 Vr<=R0(n-1) & R1(n-1)& R2(n-1) & R3(n-1); 

end Behavioral;
