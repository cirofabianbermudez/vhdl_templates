library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity main is
	generic( 
		n : integer := 64;
		m : integer := 16
		);
    port( 
        CLK      : in  std_logic;
        RST      : in  std_logic;
        START    : in  std_logic;
		DAC_SCLK : out STD_LOGIC;
		DAC_SYNC : out STD_LOGIC;
		DAC_DIN  : out STD_LOGIC;
	    DAC_LDAC : out STD_LOGIC;
		DAC_RST  : out STD_LOGIC
    );
end ;

architecture arch of main is
	signal y1n : std_logic_vector(n-1 downto 0);
	signal y1nt : std_logic_vector(m-1 downto 0);
	signal EOW,WR,STEP : std_logic;
	signal t1 : std_logic_vector(25 downto 0);
	signal clk_slow : std_logic;
	signal zero : std_logic_vector(m-1 downto 0) := (others =>'0');
begin 
	t1 <= "00000000000000000000000000"; -- 1s con 100 MHz
	CLK_50MHZ 	:entity work.div_freq generic map(n => 26) 	port map(RST,CLK,'1',t1,clk_slow);
	SYSPWL      :entity work.pwl      generic map(n => 64)  port map(clk_slow, RST, STEP,y1n);

	-- Truncamiento	
	y1nt <= y1n(n-1 downto 48);
	
-- El formato es  A(a ,b ) = (8,7)
--               Ap(ap,bp) = (8,55)
-- lim_izq = bp + a = 55 + 8 = 63
-- lim_der = bp - b = 55 - 7 = 48


	DAC_inter	: entity work.DAC7565  port map(RST,clk_slow,WR,EOW,'0',y1nt,zero,zero,zero,DAC_SCLK,DAC_SYNC,DAC_DIN,DAC_LDAC,DAC_RST);  
													  --WR	 --DRST
	CU	: entity work.cu_main port map(RST,clk_slow,START,EOW,STEP,WR); 
end arch;





