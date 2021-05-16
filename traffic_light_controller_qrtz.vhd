library ieee ;
use ieee . std_logic_1164 .all;

ENTITY traffic_light_controller_qrtz IS
PORT ( CLOCK_50 : IN STD_LOGIC ;
KEY: in std_logic_vector(3 downto 0);  -- pushbuttons
HEX0, HEX2, HEX3 : out std_logic_vector(6 downto 0));
END traffic_light_controller_qrtz ;


ARCHITECTURE top OF traffic_light_controller_qrtz IS

component counter8bit is
port ( clk , rst, enable, load: in std_logic ;
ldVal: in std_logic_vector (7 downto 0);
q: out std_logic_vector (7 downto 0) );
end component ;

component counter_50000000 is
	port(clk, rst, enable : in std_logic;
	countout : out std_logic_vector(25 downto 0));
end component;


component Seven_Segment is
	port (SW: in std_logic_vector(3 downto 0);
	HEX_out: out std_logic_vector(6 downto 0));
end component;

signal clr_cnt8, car_waiting, clr_cnt10 , ld_cnt, ld_cnt10 : std_logic;
signal start_timer : std_logic;
signal cnt26, en_cnt10 : std_logic:= '0';
signal q_cnt26 : std_logic_vector(25 downto 0);
signal ldVal,ldVal10 : std_logic_vector (7 downto 0) := "00001001";
signal q_out, q_sec10 : std_logic_vector (7 downto 0);
signal state_hex,hexDisp2,hexDisp3 : std_logic_vector (3 downto 0);
signal nsleft, nsgreen , nsyellow , nsred , ewleft , ewgreen , ewyellow , ewred : STD_LOGIC;
-- Declare a state type

type state_type is ( NS_LEFT, NS_GREEN , NS_YELLOW , EW_LEFT,  EW_GREEN , EW_YELLOW , EW_GREEN_EXT );
-- Declare current and next state variables .
-- Init to NS_GREEN since we don 't have a reset state .
signal current_state , next_state : state_type := NS_LEFT ;

BEGIN
-- Datapath components we incorporated into controller
t0: counter_50000000 port map (CLOCK_50, cnt26, start_timer , q_cnt26);
t1: counter8bit port map (CLOCK_50, clr_cnt8, cnt26 ,ld_cnt, ldVal, q_out );
t2: counter8bit port map (CLOCK_50, clr_cnt10, cnt26, ld_cnt10 ,ldVal10, q_sec10 );

car_waiting <= not (KEY(0));
disp0 : Seven_Segment port map (state_hex,HEX0);
disp2 : Seven_Segment port map (hexDisp2,HEX2);
disp3 : Seven_Segment port map (hexDisp3,HEX3);

clr_cnt10 <= '0';
with q_cnt26 select 
	cnt26 <= '1' when "00000000000000000000000000",
--	cnt26 <= '1' when "10111110101111000010000000",
		'0' when others;
		
process (CLOCK_50)
begin
if (CLOCK_50 ' event and CLOCK_50 = '1') then
	current_state <= next_state ;
end if;
end process ;

process(q_out)
begin
if (q_out < "00001010") then
	hexDisp3 <= "0000";
	hexDisp2 <= q_out(3 downto 0);
else
	hexDisp3 <= "0001";
	hexDisp2 <= q_sec10(3 downto 0);
end if;
end process;

process ( current_state , q_out, car_waiting )
begin

start_timer <= '0';
clr_cnt8 <= '0';
nsleft <= '0';
nsgreen <= '0';
nsyellow <= '0';
nsred <= '0';
ewleft <= '0';
ewgreen <= '0';
ewyellow <= '0';
ewred <= '0';
state_hex <= "0000";
case current_state is

when NS_LEFT =>
nsleft <= '1';
ewred <= '1';
nsleft <= '1';
start_timer <= '1';
state_hex <= "0001";
if ( q_out = "00000000" ) then
	next_state <= NS_GREEN;
	ldVal <= "00010011";
	ld_cnt <= '1';
	ldVal10 <= "00001001";
	ld_cnt10 <= '1';
else
	next_state <= NS_LEFT;
	ld_cnt <= '0';
	ld_cnt10 <= '0';
end if;

when NS_GREEN =>
nsgreen <= '1';
ewred <= '1';
start_timer <= '1';
state_hex <= "0010";
ld_cnt10 <= '0';
if ( q_out = "00000000") then
	next_state <= NS_YELLOW ;
	ldVal <= "00000110";
	ld_cnt <= '1';
else
	next_state <= NS_GREEN ;
	ld_cnt <= '0';
end if;

when NS_YELLOW =>
nsyellow <= '1';
ewred <= '1';
start_timer <= '1';
state_hex <= "0011";
ld_cnt10 <= '0';
if ( q_out = "00000000") then
	next_state <= EW_LEFT ;
	ldVal <= "00001001";
	ld_cnt <= '1';
else
	next_state <= NS_YELLOW ;
	ld_cnt <= '0';
end if;

when EW_LEFT =>
nsred <= '1';
ewleft <= '1';
start_timer <= '1';
state_hex <= "0100";
if( q_out = "00000000" ) then
	next_state <= EW_GREEN;
	ldVal <= "00010011";
	ld_cnt <= '1';
	ldVal10 <= "00001001";
	ld_cnt10 <= '1';
else
	next_state <= EW_LEFT;
	ld_cnt <= '0';
	ld_cnt10 <= '0';
end if;

when EW_GREEN =>
nsred <= '1';
ewgreen <= '1';
start_timer <= '1';
state_hex <= "0101";
if ( q_out = "00000000" ) then 
	if ( car_waiting = '1') then
		next_state <= EW_YELLOW ;
		ldVal <= "00000110";
		ld_cnt <= '1';
		ld_cnt10 <= '0';
	else
		next_state <= EW_GREEN_EXT ;
		ldVal <= "00001110";
		ld_cnt <= '1';
		ldVal10 <= "00000100";
		ld_cnt10 <= '1';
	end if;
else
	next_state <= EW_GREEN ;
	ld_cnt <= '0';
	ld_cnt10 <= '0';
end if;

when EW_GREEN_EXT =>
nsred <= '1';
ewgreen <= '1';
start_timer <= '1';
state_hex <= "0110";
ld_cnt10 <= '0';
if ( q_out = "00000000") or ( car_waiting = '1') then
	next_state <= EW_YELLOW ;
	ldVal <= "00000110";
	ld_cnt <= '1';
else
	next_state <= EW_GREEN_EXT ;
	ld_cnt <= '0';
end if;

when EW_YELLOW =>
nsred <= '1';
ewyellow <= '1';
start_timer <= '1';
state_hex <= "0111";
ld_cnt10 <= '0';
if ( q_out = "00000000") then
	next_state <= NS_LEFT;
	ldVal <= "00001001";
	ld_cnt <= '1';
else
	next_state <= EW_YELLOW ;
	ld_cnt <= '0';
end if;

end case ;
end process ;
END top ;