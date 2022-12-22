library ieee;
use ieee.std_logic_1164.all;

entity maquina_fsm2 is
  port(
    RST	: in  std_logic;
    CLK : in  std_logic;
    Rx  : in  std_logic;
    B   : in  std_logic;
    --RDD : in  std_logic;
    EOR : out std_logic;
    S   : out std_logic
  );
end maquina_fsm2;

architecture fsm2 of maquina_fsm2 is
signal Qp, Qn  : std_logic_vector(5 downto 0);  -- son 48 estados, necesitamos 6 bits
begin
  
  process(Qp,Rx,B) 
  begin
    case Qp is
      when "000000" => EOR <= '1'; S <= '0';	 --S0	 -- Comprobar inicio
		if Rx = '0' then 
		  Qn <= "000001";
		else 
		  Qn <= Qp;
		end if;
	  -- ############################################################ Ready
      when "000001" => EOR <= '0'; S <= '0';	 -- S1	 -- INICIO
	    if B = '1' then 
		  Qn <= "000010";
		else 
		  Qn <= Qp;
		end if;
      when "000010" => EOR <= '0'; S <= '0';	 -- S2
	    if B = '1' then 
		  Qn <= "000011";
		else 
		  Qn <= Qp;
		end if;
      when "000011" => EOR <= '0'; S <= '1';	 -- S3	 -- LOAD	  Bit de inicio
	  	  Qn <= "000100";
      when "000100" => EOR <= '0'; S <= '0';	 -- S4
	  	if B = '1' then 
		  Qn <= "000101";
		else 
		  Qn <= Qp;
		end if;
      when "000101" => EOR <= '0'; S <= '0';	 -- S5	 -- FIN
	  	if B = '1' then 
		  Qn <= "000110";
		else 
		  Qn <= Qp;
		end if;	
		
	  -- ############################################################ Ready
      when "000110" => EOR <= '0'; S <= '0';	 -- S6	 -- INICIO
	  	if B = '1' then 
		  Qn <= "000111";
		else 
		  Qn <= Qp;
		end if;
      when "000111" => EOR <= '0'; S <= '0';	 -- S7
	  	if B = '1' then 
		  Qn <= "001000";
		else 
		  Qn <= Qp;
		end if;
      when "001000" => EOR <= '0'; S <= '1';	 -- S8	  -- LOAD	 D0
			Qn <= "001001";
      when "001001" => EOR <= '0'; S <= '0';     -- S9
	  	if B = '1' then 
		  Qn <= "001010";
		else 
		  Qn <= Qp;
		end if;
      when "001010" => EOR <= '0'; S <= '0';	 -- S10	  -- FIN
	  	if B = '1' then 
		  Qn <= "001011";
		else 
		  Qn <= Qp;
		end if;
	  
	  -- ############################################################ Ready
	  when "001011" => EOR <= '0'; S <= '0';	 -- S11	 -- INICIO
	  	if B = '1' then 
		  Qn <= "001100";
		else 
		  Qn <= Qp;
		end if;
      when "001100" => EOR <= '0'; S <= '0';	 -- S12
	  	if B = '1' then 
		  Qn <= "001101";
		else 
		  Qn <= Qp;
		end if;
      when "001101" => EOR <= '0'; S <= '1';	 -- s13	  -- LOAD	 D1
			Qn <= "001110";
      when "001110" => EOR <= '0'; S <= '0';     -- S14
	  	if B = '1' then 
		  Qn <= "001111";
		else 
		  Qn <= Qp;
		end if;
      when "001111" => EOR <= '0'; S <= '0';	 -- S15	  -- FIN
	  	if B = '1' then 
		  Qn <= "010000";
		else 
		  Qn <= Qp;
		end if;
	  
	  -- ############################################################ Ready
	  when "010000" => EOR <= '0'; S <= '0';	 -- S16	 -- INICIO
	  	if B = '1' then 
		  Qn <= "010001";
		else 
		  Qn <= Qp;
		end if;
      when "010001" => EOR <= '0'; S <= '0';	 -- S17
	  	if B = '1' then 
		  Qn <= "010010";
		else 
		  Qn <= Qp;
		end if;
      when "010010" => EOR <= '0'; S <= '1';	 -- S18	  -- LOAD	 D2
	 	 Qn <= "010011";
      when "010011" => EOR <= '0'; S <= '0';     -- S19
	  	if B = '1' then 
		  Qn <= "010100";
		else 
		  Qn <= Qp;
		end if;
      when "010100" => EOR <= '0'; S <= '0';	 -- S20	  -- FIN
	  	if B = '1' then 
		  Qn <= "010101";
		else 
		  Qn <= Qp;
		end if;
	  
	  -- ############################################################ Ready
	  when "010101" => EOR <= '0'; S <= '0';	 -- S21	 -- INICIO
	  	if B = '1' then 
		  Qn <= "010110";
		else 
		  Qn <= Qp;
		end if;
      when "010110" => EOR <= '0'; S <= '0';	 -- S22	
	  	if B = '1' then 
		  Qn <= "010111";
		else 
		  Qn <= Qp;
		end if;
      when "010111" => EOR <= '0'; S <= '1';	 -- S23	  -- LOAD	 D3
	  	 Qn <= "011000";
      when "011000" => EOR <= '0'; S <= '0';     -- S24
	  	if B = '1' then 
		  Qn <= "011001";
		else 
		  Qn <= Qp;
		end if;
      when "011001" => EOR <= '0'; S <= '0';	 -- S25	  -- FIN
	  	if B = '1' then 
		  Qn <= "011010";
		else 
		  Qn <= Qp;
		end if;
	  
	  -- ############################################################  Ready
	  when "011010" => EOR <= '0'; S <= '0';	 -- S26	 -- INICIO
	  	if B = '1' then 
		  Qn <= "011011";
		else 
		  Qn <= Qp;
		end if;
      when "011011" => EOR <= '0'; S <= '0';	 -- S27
	  	if B = '1' then 
		  Qn <= "011100";
		else 
		  Qn <= Qp;
		end if;
      when "011100" => EOR <= '0'; S <= '1';	 -- S28	  -- LOAD	 D4
	  	Qn <= "011101";
      when "011101" => EOR <= '0'; S <= '0';     -- S29
	  	if B = '1' then 
		  Qn <= "011110";
		else 
		  Qn <= Qp;
		end if;
      when "011110" => EOR <= '0'; S <= '0';	 -- S30	  -- FIN
	  	if B = '1' then 
		  Qn <= "011111";
		else 
		  Qn <= Qp;
		end if;
	  
	  -- ############################################################ Ready
	  when "011111" => EOR <= '0'; S <= '0';	 -- S31	 -- INICIO
	  	if B = '1' then 
		  Qn <= "100000";
		else 
		  Qn <= Qp;
		end if;
      when "100000" => EOR <= '0'; S <= '0';	 -- S32
	  	if B = '1' then 
		  Qn <= "100001";
		else 
		  Qn <= Qp;
		end if;
      when "100001" => EOR <= '0'; S <= '1';	 -- S33	  -- LOAD   D5
	  	Qn <= "100010";
      when "100010" => EOR <= '0'; S <= '0';     -- S34
	  	if B = '1' then 
		  Qn <= "100011";
		else 
		  Qn <= Qp;
		end if;
      when "100011" => EOR <= '0'; S <= '0';	 -- S35	  -- FIN 
	  	if B = '1' then 
		  Qn <= "100100";
		else 
		  Qn <= Qp;
		end if;
	  
	  -- ############################################################ Ready
	  when "100100" => EOR <= '0'; S <= '0';	 -- S36	 -- INICIO
	  	if B = '1' then 
		  Qn <= "100101";
		else 
		  Qn <= Qp;
		end if;
      when "100101" => EOR <= '0'; S <= '0';	 -- S37
	  	if B = '1' then 
		  Qn <= "100110";
		else 
		  Qn <= Qp;
		end if;
      when "100110" => EOR <= '0'; S <= '1';	 -- S38	  -- LOAD	D6
	  	Qn <= "100111";
      when "100111" => EOR <= '0'; S <= '0';     -- S39
	  	if B = '1' then 
		  Qn <= "101000";
		else 
		  Qn <= Qp;
		end if;
      when "101000" => EOR <= '0'; S <= '0';	 -- S40	  -- FIN 
	  	if B = '1' then 
		  Qn <= "101001";
		else 
		  Qn <= Qp;
		end if;
	
      -- ############################################################ Ready
	  when "101001" => EOR <= '0'; S <= '0';	 -- S41	 -- INICIO
	  	if B = '1' then 
		  Qn <= "101010";
		else 
		  Qn <= Qp;
		end if;
      when "101010" => EOR <= '0'; S <= '0';	 -- S42
	  	if B = '1' then 
		  Qn <= "101011";
		else 
		  Qn <= Qp;
		end if;
      when "101011" => EOR <= '0'; S <= '1';	 -- S43	  -- LOAD  D7
	  	Qn <= "101100";
      when "101100" => EOR <= '0'; S <= '0';     -- S44	
	  	if B = '1' then 
		  Qn <= "101101";
		else 
		  Qn <= Qp;
		end if;
      when "101101" => EOR <= '0'; S <= '0';	 -- S45	  -- FIN
	  	if B = '1' then 
		  Qn <= "101110";
		else 
		  Qn <= Qp;
		end if;
	  
	  -- ############################################################ Ready
	  when "101110" => EOR <= '0'; S <= '0';	 -- S46	 -- INICIO 
	  	if B = '1' then 
		  Qn <= "101111";
		else 
		  Qn <= Qp;
		end if;
      when "101111" => EOR <= '0'; S <= '0';	 -- S47
	  	if B = '1' then 
		  Qn <= "110000";
		else 
		  Qn <= Qp;
		end if;
      when "110000" => EOR <= '0'; S <= '1';	 -- S48	  -- LOAD	Bit de paridad
	  	Qn <= "110001";		-- "110001";
		when "110001" => EOR <= '0'; S <= '0';     -- S49	
	  	if B = '1' then 
		  Qn <= "110010";
		else 
		  Qn <= Qp;
		end if;
      when "110010" => EOR <= '0'; S <= '0';	 -- S50	  -- FIN
	  	if B = '1' then 
		  Qn <= "110011";
		else 
		  Qn <= Qp;
		end if;
		
		-- ############################################################
		when "110011" => EOR <= '0'; S <= '0';	 -- S51	 -- INICIO 
	  	if B = '1' then 
		  Qn <= "110100";
		else 
		  Qn <= Qp;
		end if;
      when "110100" => EOR <= '0'; S <= '0';	 -- S52
	  	if B = '1' then 
		  Qn <= "000000";
		else 
		  Qn <= Qp;
		end if;	
	  when others => EOR <= '1'; S <= '0';
		Qn <= "000000";
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

end fsm2;

