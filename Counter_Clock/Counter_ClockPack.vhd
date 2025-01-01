library IEEE;
use IEEE.std_logic_1164.all;

-- Définition projet
Package Counter_ClockPack is
	-- constantes
	constant MAX_CPT50M : integer := (50000/2)-1;
	constant HALF_CPT50M : integer := MAX_CPT50M/2;

	-- Composants utilisés (et non instanciés pour l'instant)
	component Counter_Clock50Mto1k port(
		-- inputs
		signal st_in_clk : in std_logic;
		-- outputs
		signal st_out_clk : out std_logic);
	end component;
	
	component Counter_ClockCounter port(
		-- inputs
		signal st_in_clk : in std_logic;
		-- outputs
		signal intDigit5 : out integer;
		signal intDigit4 : out integer;
		signal intDigit3 : out integer;
		signal intDigit2 : out integer;
		signal intDigit1 : out integer;
		signal intDigit0 : out integer
		);

	end component;
	
	component Counter_Clock7segConverter port(
		-- inputs
		signal int_digit : in integer;
		-- outputs
		signal stv8_segment : out std_logic_vector(7 downto 0)
		);

	end component;

	
end Counter_ClockPack;