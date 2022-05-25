library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity DAC7565 is
	 port(
		 RST : in STD_LOGIC;
		 CLK : in STD_LOGIC;
		 WR : in STD_LOGIC;
		 EOW : out STD_LOGIC;
		 DRST : in STD_LOGIC;
		 Ch0 : in STD_LOGIC_VECTOR(15 downto 0);
         Ch1 : in STD_LOGIC_VECTOR(15 downto 0);
         Ch2 : in STD_LOGIC_VECTOR(15 downto 0);
         Ch3 : in STD_LOGIC_VECTOR(15 downto 0);
		 DAC_SCLK : out STD_LOGIC;
		 DAC_SYNC : out STD_LOGIC;
		 DAC_DIN : out STD_LOGIC;
		 DAC_LDAC : out STD_LOGIC;
		 DAC_RST : out STD_LOGIC
	     );
end;

architecture arch of DAC7565 is
   signal EOC,EOS,EOT,ENT : std_logic;
   signal SE              : std_logic_vector(1 downto 0);
   signal ENS,ENC         : std_logic_vector(1 downto 0);
   signal SB              : std_logic_vector(4 downto 0);
   signal CMD             : std_logic_vector(5 downto 0);
   signal DAT,D0,D1,D2,D3 : std_logic_vector(15 downto 0);
   signal STREAM          : std_logic_vector(23 downto 0);
begin

   DAC_LDAC <= '0';
   DAC_RST  <= NOT DRST;   
   STREAM   <= "00" & CMD & NOT DAT;

   ChMux: process(SE,D0,D1,D2,D3)
   begin
      case SE is
         when   "00" =>   DAT <= D0;       -- Canal 0
                          CMD <= "000000"; 
         when   "01" =>   DAT <= D1;       -- Canal 1
                          CMD <= "000010"; 
         when   "10" =>   DAT <= D2;       -- Canal 2
                          CMD <= "000100"; 
         when others =>   DAT <= D3;       -- Canal 3
                          CMD <= "100110";
      end case;
   end process ChMux;
   
   RegCh0:   entity work.dacGReg     generic map (16) port map (RST,CLK,WR,Ch0,D0);
   RegCh1:   entity work.dacGReg     generic map (16) port map (RST,CLK,WR,Ch1,D1);
   RegCh2:   entity work.dacGReg     generic map (16) port map (RST,CLK,WR,Ch2,D2);
   RegCh3:   entity work.dacGReg     generic map (16) port map (RST,CLK,WR,Ch3,D3);
   
   Shifter:  entity work.dacGShifter generic map (24,5) port map (SB,STREAM,DAC_DIN);

   ChCount:  entity work.dacGCount   generic map (2) port map (RST,CLK,ENC,"11",EOC,SE);
   BitCount: entity work.dacGCount   generic map (5) port map (RST,CLK,ENS,"10111",EOS,SB);
   ISPFreq:  entity work.dacGTimer   generic map (3) port map (RST,CLK,ENT,"100",EOT);
   
   Control:  entity work.dacFSM port map (RST,CLK,WR,EOW,EOC,EOS,EOT,ENC,ENS,ENT,DAC_SYNC,DAC_SCLK); 

end arch;