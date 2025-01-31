-- Compteur de position des lignes de pixels en Y pour génération du signal VGA
library IEEE;
use IEEE.std_logic_1164.all;

use work.PrjPack.all;

entity CompteurY is port(
		-- inputs
		signal st_in_clk 	: in std_logic;
		signal st_in_en 	: in std_logic;
		-- outputs
		signal int_out_posYpixel 		: out integer;
		signal st_out_syncTrame 		: out std_logic;
		signal st_out_AnimImageSync 	: out std_logic);
end CompteurY;

architecture arch_CompteurY of CompteurY is
signal int_cptY : integer range 0 to YABCD;

begin
	process(st_in_en, st_in_clk)
	begin
		if(st_in_clk'event and (st_in_clk = '1') and (st_in_en = '1')) then
			
			st_out_syncTrame <= '1';
			st_out_AnimImageSync <= '1';
			
			-- Compteur Y
			int_cptY <= int_cptY + 1;
			
			if(int_cptY <= YA) then
				-- Assigne le signal de synchro trame vers l'écran
				st_out_syncTrame <= '0';
				st_out_AnimImageSync <= '0';
			end if;
			
			if(int_cptY > YABCD) then
				int_cptY <= 0;
			end if;
		
		end if;
	
	end process;

	
	-- Assigne la position de pos pixel en Y
	int_out_posYpixel <= int_cptY;
	
	
end arch_CompteurY;