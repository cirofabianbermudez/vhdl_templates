library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mult is
    generic( n  :   integer := 64);
    port(
        A   : in    std_logic_vector(n-1 downto 0);
        B   : in    std_logic_vector(n-1 downto 0);
        M   : out   std_logic_vector(n-1 downto 0)
    );
end;    

architecture arch of mult is
signal temp : std_logic_vector(2*n-1 downto 0);
begin   												  
    temp <= std_logic_vector(signed(A)*signed(B));
    M <= temp(118 downto 55);
end arch;

-- El formato es  A(a ,b ) = (8,55)
--               Ap(ap,bp) = (16,110)
-- lim_izq = bp + a = 110 + 8 = 118
-- lim_der = bp - b = 110 - 55 = 55	