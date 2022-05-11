----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.05.2022 16:06:20
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity top is
Port (
clk: in std_logic;
rst: in std_logic;
k: in std_logic_vector(3 downto 0);
sel: in std_logic_vector(1 downto 0);
sel_speed: in std_logic_vector(1 downto 0);
led: out std_logic_vector(3 downto 0);
z: out std_logic);
end top;

architecture Behavioral of top is
signal slowclock: std_logic;
signal speed,s1,s2,s3,s4 : std_logic_vector(24 downto 0);
begin
comp_reloj: entity work.div_freq generic map(n => 25) port map(rst,clk,'1',speed,slowclock);
comp_contador: entity work.cont_0 generic map(n=>4) port map(rst,slowclock,sel,k,led,z);


s1 <= "1011111010111100000111111";
s2 <= "0101111101011110000011111";
s3 <= "0010111110101111000001111";
s4 <= "0001011111010111100000111";

comp_mux: entity work.mux_4_1 generic map(n=>25) port map(s1,s2,s3,s4,sel_speed,speed);
end Behavioral;
