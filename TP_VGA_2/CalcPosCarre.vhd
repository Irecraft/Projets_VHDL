library IEEE;
use IEEE.std_logic_1164.all;

use work.drapeauPack.all;

entity CalcPosCarre is port(
		-- inputs
		signal st_in_clk : in std_logic;
		signal st_in_syncImage : in std_logic;
		-- outputs
		signal int_out_XCarre : out integer;
		signal int_out_YCarre : out integer);
end CalcPosCarre;

architecture arch_CalcPosCarre of CalcPosCarre is
signal cptPrescaler : integer range 0 to 512 := 0;
signal int_cptX : integer range 0 to MAXX := MAXX/2;
signal int_cptY : integer range 0 to MAXY := MAXY/2;

begin
	process(st_in_clk, st_in_syncImage)	-- Losqu'il y a un changement d'image
	begin
		if(st_in_clk'event and (st_in_clk = '1') and (st_in_syncImage = '0')) then
		-- incrément du compteur de prescaler pour déterminer au bout de combien d'images on actualise la position du carré
			cptPrescaler <= cptPrescaler+1;
			
			if(cptPrescaler >= 512) then -- losque le prescaler a overflow
				cptPrescaler <= 0;
				
				int_cptX <= int_cptX+1;
				int_cptY <= int_cptY+1;
				
				if(int_cptX > MAXX) then
					int_cptX <= 0;
				end if;
				
				if(int_cptY > MAXY) then
					int_cptY <= 0;
				end if;
			end if;
			
		end if;
	end process;
	
	int_out_XCarre <= int_cptX;
	int_out_YCarre <= int_cptY;
		
end arch_CalcPosCarre;