library ieee ;
use ieee . std_logic_1164 .all;

entity test_traffic_light_controller is
end test_traffic_light_controller ;

architecture test of test_traffic_light_controller is

component traffic_light_controller_qrtz IS
PORT ( CLOCK_50 : IN STD_LOGIC ;
KEY: in std_logic_vector(3 downto 0);  -- pushbuttons
HEX0, HEX2, HEX3 : out std_logic_vector(6 downto 0));
END component ;

signal clk: std_logic := '1';

signal KEY: std_logic_vector(3 downto 0);  -- pushbuttons
signal HEX0, HEX2, HEX3 : std_logic_vector(6 downto 0);

begin
ct10 : traffic_light_controller_qrtz port map (clk, KEY, HEX0, HEX2, HEX3);
clk <= not clk after 0.5 ns;
KEY(0) <= '1', '0' after 3 ns , '1' after 25 ns , '0' after 40 ns , '1' after 70 ns,'0' after 95 ns, '1' after 105 ns;
KEY(3 downto 1) <= "000";
end test ;