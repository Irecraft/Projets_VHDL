library IEEE;
use IEEE.std_logic_1164.all;

use work.Counter_ClockPack.all;

entity Counter_Clock7segConverter is port(
		-- inputs
		signal int_digit : in integer;
		-- outputs
		signal stv8_segment : out std_logic_vector(7 downto 0)
		);

end Counter_Clock7segConverter;

architecture arch_Counter_Clock7segConverter of Counter_Clock7segConverter is

begin

-- Convertit l'entier en vecteur contenant la valeur 
		
	stv8_segment <= 	"11000000" when(int_digit=0) else
							"11111001" when(int_digit=1) else
							"10100100" when(int_digit=2) else
							"10110000" when(int_digit=3) else
							"10011001" when(int_digit=4) else
							"10010010" when(int_digit=5) else
							"10000010" when(int_digit=6) else
							"11111000" when(int_digit=7) else
							"10000000" when(int_digit=8) else
							"10010000" when(int_digit=9);
							
end arch_Counter_Clock7segConverter;