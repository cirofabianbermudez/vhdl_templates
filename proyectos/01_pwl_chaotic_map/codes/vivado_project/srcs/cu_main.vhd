library ieee;
use ieee.std_logic_1164.all;

entity cu_main is
  port(
    RST     : in   std_logic;
    CLK     : in   std_logic;
    START   : in   std_logic;
	EOW	    : in   std_logic;
    STEP    : out  std_logic;
    WR      : out  std_logic
  );
end;

architecture fsm of cu_main is
    signal Qp, Qn  : std_logic_vector(2 downto 0); -- porque son 5 estados
begin
  
  process(Qp,START,EOW) 
  begin
    case Qp is
     when "000" => STEP <= '0'; WR <= '0';         
        if START = '1' then 
          Qn <= "001";
        else 
          Qn <= Qp;
        end if;
     when "001" => STEP <= '1'; WR <= '0';                 
          Qn <= "010";
     when "010" => STEP <= '0'; WR <= '0';          
          Qn <= "011";
     when "011" => STEP <= '0'; WR <= '1';         
	      Qn <= "100";
	 when "100" => STEP <= '0'; WR <= '0';            
        if EOW = '1' then 
          Qn <= "000";
        else 
          Qn <= Qp;
        end if;
     when others => STEP <= '0';  WR <= '0';         
        Qn <= "000";
    end case;
  end process;

  -- Registros para estados
  process(RST,CLK)
  begin
    if RST = '1' then
      Qp <= (others => '0');
    elsif rising_edge(CLK) then
      Qp <= Qn;
    end if;
  end process;

end fsm;

