
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
port (clk: in std_logic;
A,B: in std_logic_vector(2 downto 0);
seg7: out std_logic_vector(6 downto 0);
anod: out std_logic_vector(3 downto 0)
      );
end top;

architecture Behavioral of top is
signal bcd, uni, dec,suma: std_logic_vector(3 downto 0);
signal sel:std_logic;

begin
 comp_mux  : entity work.mux_2_1 generic map(n => 4) port map(uni,dec,sel, bcd);

 comp_7seg  : entity work.cod_7seg port map(bcd, seg7);
 
 comp_codificador: entity work.cod_b port map(suma,uni,dec);
 
 comp_sumador: entity work.adder port map(A,B,suma);
 
 comp_anodos: entity work.an_control port map(sel,anod);
 
 comp_reloj: entity work.div_freq generic map(n => 25) port map('0',clk,'1',"0000011001011011100110100",sel);

--1011111010111100000111111

end Behavioral;
