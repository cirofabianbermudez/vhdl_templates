library ieee;
use ieee.std_logic_1164.all;

entity maquina_fsm is
  port(
    RST	: in  std_logic;
    CLK : in  std_logic;
    B   : in  std_logic;
    STT : in  std_logic;
    EOT : out std_logic;
    M   : out std_logic_vector(3 downto 0)
  );
end maquina_fsm;

architecture fsm of maquina_fsm is
signal Qp, Qn  : std_logic_vector(3 downto 0);  -- son 12 estados, necesitamos 4 bits
begin
  
  process(Qp,STT,B) 
  begin
    case Qp is
      when "0000" => EOT <= '1'; M <= "0000";
	if STT = '1' then 
	  Qn <= "0001";
	else 
	  Qn <= Qp;
	end if;
      when "0001" => EOT <= '0'; M <= "0000";
	if B = '1' then 
	  Qn <= "0010";
	else 
	  Qn <= Qp;
	end if;
      when "0010" => EOT <= '0'; M <= "0001";
	if B = '1' then 
	  Qn <= "0011";
	else 
	  Qn <= Qp;
	end if;
      when "0011" => EOT <= '0'; M <= "0010";
	if B = '1' then 
	  Qn <= "0100";
	else 
	  Qn <= Qp;
	end if;
      when "0100" => EOT <= '0'; M <= "0011";
	if B = '1' then 
	  Qn <= "0101";
	else 
	  Qn <= Qp;
	end if;
      when "0101" => EOT <= '0'; M <= "0100";
	if B = '1' then 
	  Qn <= "0110";
	else 
	  Qn <= Qp;
	end if;
      when "0110" => EOT <= '0'; M <= "0101";
	if B = '1' then 
	  Qn <= "0111";
	else 
	  Qn <= Qp;
	end if;
      when "0111" => EOT <= '0'; M <= "0110";
	if B = '1' then 
	  Qn <= "1000";
	else 
	  Qn <= Qp;
	end if;
      when "1000" => EOT <= '0'; M <= "0111";
	if B = '1' then 
	  Qn <= "1001";
	else 
	  Qn <= Qp;
	end if;
      when "1001" => EOT <= '0'; M <= "1000";
	if B = '1' then 
	  Qn <= "1010";
	else 
	  Qn <= Qp;
	end if;
      when "1010" => EOT <= '0'; M <= "1001";
	if B = '1' then 
	  Qn <= "1011";
	else 
	  Qn <= Qp;
	end if;
      when "1011" => EOT <= '0'; M <= "1010";
	if B = '1' then 
	  Qn <= "0000";
	else 
	  Qn <= Qp;
	end if;
      when others => EOT <= '1'; M <= "0000";
	Qn <= "0000";
    end case;
  end process;

  -- Registros para estados
  process(RST,CLK)
  begin
    if RST = '1' then
      Qp <= "0000";
    elsif rising_edge(CLK) then
      Qp <= Qn;
    end if;
  end process;

end fsm;

