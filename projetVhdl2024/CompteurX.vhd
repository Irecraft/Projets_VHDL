library IEEE;
use IEEE.std_logic_1164.all;

use work.PrjPack.all;

entity CompteurX is port(
		-- inputs
		signal st_in_clk : in std_logic;
		-- outputs
		signal st_out_posXpixel : out integer;
		signal st_out_syncLigne : out std_logic;
		signal st_out_finLigne : out std_logic);
end CompteurX;
	
architecture arch_CompteurX of CompteurX is
signal int_cptX : integer range 0 to XABCD;

begin
	process(st_in_clk)
	begin
		if(st_in_clk'event and (st_in_clk = '1')) then
		
			-- Compteur X
			int_cptX <= int_cptX + 1;
			
			if(int_cptX > XABCD) then
				int_cptX <= 0;
			end if;
		
		end if;
	
	end process;
	
	-- Assigne le signal de retenue pour le compteur Y
	st_out_finLigne <= '1' when(int_cptX = XABCD)
		else '0';
		
	-- Assigne le signal de synchro ligne vers l'écran
	st_out_syncLigne <= '0' when(int_cptX <= XA)
		else '1';
		
	-- Assigne la position de pos pixel en X
	st_out_posXpixel <= int_cptX;
	
end arch_CompteurX;
