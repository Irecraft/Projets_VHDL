library IEEE;
use IEEE.std_logic_1164.all;

use work.Counter_ClockPack.all;

entity Counter_ClockCounter is port(
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

end Counter_ClockCounter;

architecture arch_CounterCounter of Counter_ClockCounter is
signal int_cpt : integer range 0 to 999999 := 0;

begin
	process(st_in_clk)
	begin
		if(st_in_clk'event and (st_in_clk = '1')) then
			
			-- incrémentation compteur
			int_cpt <= int_cpt + 1;
			
			if(int_cpt >= 999999) then
				int_cpt <= 0;
			end if;
		
		end if;
	
	end process;
	
	-- parse de chaque chiffre indépendament
	
	intDigit0 <= int_cpt mod 10;
	intDigit1 <= (int_cpt/10) mod 10;
	intDigit2 <= (int_cpt/100) mod 10;
	intDigit3 <= (int_cpt/1000) mod 10;
	intDigit4 <= (int_cpt/10000) mod 10;
	intDigit5 <= (int_cpt/100000) mod 10;
	
end arch_CounterCounter;