library IEEE;
use IEEE.std_logic_1164.all;

use work.Counter_ClockPack.all;

entity Counter_ClockMain is port(
	-- input
	signal st_in_clk50M : in std_logic;
	-- outputs
	signal stv8_out_7seg5 : out std_logic_vector(7 downto 0);
	signal stv8_out_7seg4 : out std_logic_vector(7 downto 0);
	signal stv8_out_7seg3 : out std_logic_vector(7 downto 0);
	signal stv8_out_7seg2 : out std_logic_vector(7 downto 0);
	signal stv8_out_7seg1 : out std_logic_vector(7 downto 0);
	signal stv8_out_7seg0 : out std_logic_vector(7 downto 0)); 
end Counter_ClockMain;

architecture arch_Counter_ClockMain of Counter_ClockMain is
signal clk1k : STD_LOGIC;
signal sigIntDigit5 : integer;
signal sigIntDigit4 : integer;
signal sigIntDigit3 : integer;
signal sigIntDigit2 : integer;
signal sigIntDigit1 : integer;
signal sigIntDigit0 : integer;

begin
	Cpt50Mto1k : Counter_Clock50Mto1k
		port map(
			st_in_clk => st_in_clk50M,
			st_out_clk => clk1k
		);

	Counter : Counter_ClockCounter
		port map(
			st_in_clk => clk1k,
			intDigit5 => sigIntDigit5,
			intDigit4 => sigIntDigit4,
			intDigit3 => sigIntDigit3,
			intDigit2 => sigIntDigit2,
			intDigit1 => sigIntDigit1,
			intDigit0 => sigIntDigit0
		);
		
	Converter5 : Counter_Clock7segConverter
		port map(
			int_digit => sigIntDigit5,
			stv8_segment => stv8_out_7seg5
		);
		
	Converter4 : Counter_Clock7segConverter
		port map(
			int_digit => sigIntDigit4,
			stv8_segment => stv8_out_7seg4
		);
	
	Converter3 : Counter_Clock7segConverter
		port map(
			int_digit => sigIntDigit3,
			stv8_segment => stv8_out_7seg3
		);
	
	Converter2 : Counter_Clock7segConverter
		port map(
			int_digit => sigIntDigit2,
			stv8_segment => stv8_out_7seg2
		);
	
	Converter1 : Counter_Clock7segConverter
		port map(
			int_digit => sigIntDigit1,
			stv8_segment => stv8_out_7seg1
		);
	
	Converter0 : Counter_Clock7segConverter
		port map(
			int_digit => sigIntDigit0,
			stv8_segment => stv8_out_7seg0
		);
	
end arch_Counter_ClockMain;