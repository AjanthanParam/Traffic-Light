library ieee ;
use ieee . std_logic_1164 .all;
use ieee . numeric_std .all ;

ENTITY counter8bit IS
PORT ( clk , rst, enable, load: in std_logic ;
ldVal: in std_logic_vector (7 downto 0);
q: out std_logic_vector (7 downto 0));
END counter8bit ;

ARCHITECTURE rtl OF counter8bit IS
signal cnt : unsigned (7 downto 0) := "00001001";
BEGIN
process (clk)
begin
if (clk ' event ) and (clk = '1') then
if (rst = '1') then
cnt <= "00000000";
elsif (load = '1') then
cnt <= unsigned (ldVal);
elsif (enable = '1') then
cnt <= cnt - "1";
else
cnt <= cnt;
end if;
end if;
end process ;
q <= std_logic_vector (cnt );
END rtl ;