library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity counter_50000000 is
	port(clk, rst, enable : in std_logic;
			countout : out std_logic_vector(25 downto 0));
end counter_50000000;

architecture counter of counter_50000000 is
	signal cntval: std_logic_vector(25 downto 0) := "00000000000000000000000000";

begin
	process(clk, enable)
	begin
		if((clk 'event) and (clk = '1')) then
			if(rst = '1') then
				cntval <= "00000000000000000000000000";
			elsif(enable = '1') then
				cntval <= cntval + '1';
			else
				cntval <= cntval;
			end if;
		end if;
	end process;
	countout <= cntval;
end counter;
			