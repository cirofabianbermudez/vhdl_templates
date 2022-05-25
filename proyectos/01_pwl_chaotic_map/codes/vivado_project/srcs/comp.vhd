library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comp is
	generic( n : integer := 64 );
	port(
	A,X	 : in   std_logic_vector(n-1 downto 0);
     C	 : out  std_logic_vector(3 downto 0)
	);
end;	

architecture arch of comp is
signal zero : std_logic_vector(n-1 downto 0) := (others =>'0');
begin
		C(0) <= '1' when signed(X) <= -signed(A) else '0';
		C(1) <= '1' when ( -signed(A) < signed(X)  ) and (signed(x) < signed(zero))  else '0';	
		C(2) <= '1' when (signed(zero) <= signed(X)) and (signed(x) < signed(A)   )  else '0';	   
		C(3) <= '1' when (signed(x) >= signed(A))  else '0';
end arch;		