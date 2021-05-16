library ieee;
use ieee.std_logic_1164.all;
	
entity Seven_Segment is
	port (SW: in std_logic_vector(3 downto 0);
		  	  HEX_out: out std_logic_vector(6 downto 0));
end Seven_Segment;
	
architecture top of Seven_Segment  IS
	begin 
	
		HEX_out(0) <= (((NOT SW(3)) AND (NOT SW(2)) AND (NOT SW(1)) AND SW(0)) OR ((NOT SW(3)) AND SW(2) AND (NOT SW(1)) AND (NOT SW(0))) OR (SW(3) AND SW(2) AND (NOT SW(1)) AND SW(0)) OR (SW(3) AND (NOT SW(2)) AND SW(1) AND SW(0)));
		HEX_out(1) <= (((NOT SW(3)) AND SW(2) AND (NOT SW(1)) AND SW(0)) OR (SW(3) AND SW(2) AND (NOT SW(0))) OR (SW(3) AND SW(1) AND SW(0)) OR (SW(2) AND SW(1) AND (NOT SW(0))));
		HEX_out(2) <= (((NOT SW(3)) AND (NOT SW(2)) AND SW(1) AND (NOT SW(0))) OR (SW(3) AND SW(2) AND (NOT SW(0))) OR (SW(3) AND SW(2) AND SW(1)));
		HEX_out(3) <= (((NOT SW(3)) AND SW(2) AND (NOT SW(1)) AND (NOT SW(0))) OR (SW(3) AND (NOT SW(2)) AND SW(1) AND (NOT SW(0))) OR (SW(2) AND SW(1) AND SW(0)) OR ((NOT SW(2)) AND (NOT SW(1)) AND SW(0)));
		HEX_out(4) <= (((NOT SW(2)) AND (NOT SW(1)) AND SW(0)) OR ((NOT SW(3)) AND SW(0)) OR ((NOT SW(3)) AND SW(2) AND (NOT SW(1))));
		HEX_out(5) <= ((SW(3) AND SW(2) AND (NOT SW(1)) AND SW(0)) OR ((NOT SW(3)) AND (NOT SW(2)) AND SW(0)) OR ((NOT SW(3)) AND (NOT SW(2)) AND SW(1)) OR ((NOT SW(3)) AND SW(1) AND SW(0)));
		HEX_out(6) <= (((NOT SW(3)) AND (NOT SW(2)) AND (NOT SW(1))) OR ((NOT SW(3)) AND SW(2) AND SW(1) AND SW(0)) OR (SW(3) AND SW(2) AND (NOT SW(1)) AND (NOT SW(0))));

end top;