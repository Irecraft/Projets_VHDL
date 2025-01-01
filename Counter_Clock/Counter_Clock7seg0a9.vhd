library IEEE;
use IEEE.std_logic_1164.all;

use work.Counter_ClockPack.all;

entity Counter_Clock7seg0a9 is port(
		-- inputs
		signal st_in_clk : in std_logic;
		signal st_in_retenue : in std_logic;
		-- outputs
		signal st_out_retenue : out std_logic := '1';
		signal stv7_out_7seg : out std_logic_vector(6 downto 0)
		);

end Counter_Clock7seg0a9;

architecture arch_Counter_Clock7seg0a9 of Counter_Clock7seg0a9 is
signal int_cpt : integer range 0 to 9 := 0;

begin
	process(st_in_clk, st_in_retenue)
	begin
		if(st_in_clk'event and (st_in_clk = '1') and (st_in_retenue='1')) then
			
			-- incrémentation compteur
			int_cpt <= int_cpt + 1;
			
			if(int_cpt >= 9) then
				int_cpt <= 0;
			end if;
			
		
		end if;
	
	end process;
	
	st_out_retenue <= '1' when (int_cpt=9) else '0';
	
	-- Assigne le signal de retenue pour le compteur Y
		
	stv7_out_7seg <= 	"1000000" when(int_cpt=0) else
							"1111001" when(int_cpt=1) else
							"0100100" when(int_cpt=2) else
							"0110000" when(int_cpt=3) else
							"0011001" when(int_cpt=4) else
							"0010010" when(int_cpt=5) else
							"0000010" when(int_cpt=6) else
							"1111000" when(int_cpt=7) else
							"0000000" when(int_cpt=8) else
							"0010000" when(int_cpt=9);
	
end arch_Counter_Clock7seg0a9;