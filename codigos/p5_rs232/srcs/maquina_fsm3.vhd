library ieee;
use ieee.std_logic_1164.all;

entity maquina_fsm3 is
  port(
    RST	: in  std_logic;
    CLK 	: in  std_logic;
    EOR  : in  std_logic;
    EOT	: in  std_logic;
    OPC	: out std_logic;
    WE 	: out std_logic
  );
end maquina_fsm3;

architecture fsm of maquina_fsm3 is
signal Qp, Qn  : std_logic_vector(2 downto 0);  -- son 6 estados, necesitamos 3 bits
begin

  process(Qp,EOT,EOR) 
  begin
    case Qp is
      when "000" => OPC <= '0'; WE <= '0';
	  	if EOR = '0' then 
		  Qn <= "001";
		elsif EOT = '0' then	
		  Qn <= "100";
		else
		  Qn <= Qp;
		end if;
      when "001" => OPC <= '0'; WE <= '0'; 
	  if EOR = '1' then
		  Qn <= "010";
	  else
		  Qn <= Qp;
	  end if;
	  when "010" => OPC <= '0'; WE <= '1';
	  	Qn <= "011";
	  when "011" => OPC <= '1'; WE <= '0';
	  	Qn <= "000";
	  when "100" => OPC <= '0'; WE <= '0';
	  if EOT = '1' then
		 Qn <= "101"; 
	  else 
		 Qn <= Qp; 
	  end if;
	  when "101" => OPC <= '1'; WE <= '0';
		 Qn <= "000";
      when others => OPC <= '0'; WE <= '0';
		Qn <= "000";
    end case;
  end process;

  -- Registros para estados
  process(RST,CLK)
  begin
    if RST = '1' then
      Qp <= "000";
    elsif rising_edge(CLK) then
      Qp <= Qn;
    end if;
  end process;

end fsm;

