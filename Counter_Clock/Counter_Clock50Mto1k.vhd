library IEEE;
use IEEE.std_logic_1164.all;

use work.Counter_ClockPack.all;

entity Counter_Clock50Mto1k is port(
		-- inputs
		signal st_in_clk : in std_logic;
		-- outputs
		signal st_out_clk : out std_logic
		);

end Counter_Clock50Mto1k;

architecture arch_Counter_Clock50Mto1k of Counter_Clock50Mto1k is
signal int_cpt : integer range 0 to MAX_CPT50M;
signal clk_tick : std_logic := '0';

begin
	process(st_in_clk)
	begin
		if(st_in_clk'event and (st_in_clk = '1')) then
		
			-- Compteur
			int_cpt <= int_cpt + 1;
			
			--st_out_clk <= '0';
			
			-- Reset a la valeur max
			if(int_cpt >= MAX_CPT50M) then
				int_cpt <= 0;
				clk_tick <= not clk_tick;
				
			end if;
			
		end if;
	
	end process;
	
	-- Assigne la clock de sortie
	st_out_clk <= clk_tick;
	
end arch_Counter_Clock50Mto1k;