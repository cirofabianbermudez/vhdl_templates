library IEEE;
use IEEE.std_logic_1164.all;	 

entity mux_4_1 is
	generic(n : integer := 8); 		-- Tamanio de bundle
	port(
	I0,I1,I2,I3 : in std_logic_vector(n-1 downto 0);
	SEL : in std_logic_vector(1 downto 0);
	MUX_OUT : out std_logic_vector(n-1 downto 0)
	);	
end;	 

architecture arch of mux_4_1 is	
	constant zero : std_logic_vector(n-1 downto 0) := (others => '0');
begin

	-- Conditional signal assignment
	MUX_OUT <=	I0	when SEL = "00" else
				I1	when SEL = "01" else
				I2	when SEL = "10" else
				I3	when SEL = "11" else
				zero; 
				
--	with SEL select
--		MUX_OUT <=  I0	when "00",
--					I1	when "01",
--					I2	when "10",
--					I3	when "11",
--					zero when others;


--	-- Case syntax 
--	process(SEL,I0,I1,I2,I3) is
--	begin
--		case SEL is
--			when "00"	=> 	MUX_OUT <=	I0;
--		 	when "01" 	=>	MUX_OUT <=	I1;
--		  	when "10" 	=>	MUX_OUT <=	I2;
--		  	when "11" 	=>	MUX_OUT <=	I3;
--			when others	=>	MUX_OUT <=	zero; -- Cambia dinamicamente dependiendo de
--		end case;
--	end process;	 
	
	
--		-- if elsif else syntax	 
--	process(SEL,I0,I1,I2,I3) is
--	begin
--		if 	   SEL = "00" then 
--			MUX_OUT <=	I0;
--		elsif  SEL = "01" then
--			MUX_OUT <=	I1;
--		elsif  SEL = "10" then
--			MUX_OUT <=	I2;
--		elsif  SEL = "11" then
--			MUX_OUT <=	I3;
--		else
--			MUX_OUT <=	zero;
--		end if;		
--	end process;
	
	
end;