--Module de Calcul de position joueur en fonction de l'inclinaison de la carte
library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.numeric_std.ALL; 

use work.PrjPack.all;

entity CalcPosJoueur is port(
		-- inputs
		signal st_in_clk 			: in std_logic;
		signal st_in_enB 			: in std_logic;
		signal st_in_rstB 		: in std_logic;
		signal st_in_syncImage 	: in std_logic;
		signal stv4_in_dataX 	: in std_logic_vector(3 downto 0);
		signal stv4_in_sensX 	: in std_logic_vector(3 downto 0);
		signal stv4_in_dataY 	: in std_logic_vector(3 downto 0);
		signal stv4_in_sensY 	: in std_logic_vector(3 downto 0);
		-- outputs
		signal int_out_XJoueur 	: out integer;
		signal int_out_YJoueur 	: out integer
		);
end CalcPosJoueur;

architecture arch_CalcPosJoueur of CalcPosJoueur is
signal cptPrescaler 	: integer range 0 to PRESCALER_VITESSE_JOUEUR := 0;
signal int_cptX 		: integer range -16 to MAXX := MAXX/2;
signal int_cptY 		: integer range -16 to MAXY := MAXY/2;
signal int_valDataX 	: integer range 0 to 16;
signal int_valDataY 	: integer range 0 to 16;

begin
	process(st_in_clk, st_in_syncImage)	-- Losqu'il y a un changement d'image (supprimé de la liste de sens : st_in_syncImage)
	begin
		if(st_in_clk'event and (st_in_clk = '1') and (st_in_syncImage = '0')) then
			if(st_in_rstB <= '0') then
				cptPrescaler <= 0;
				int_cptX <= MAXX/2;
				int_cptY <= MAXY/2;
				
			else
				-- incrément du compteur de prescaler pour déterminer au bout de combien d'images on actualise la position du carré
				cptPrescaler <= cptPrescaler+1;
				
				if((cptPrescaler >= PRESCALER_VITESSE_JOUEUR) and (st_in_enB = '0')) then -- losque le prescaler a overflow (détermine vitesse de déplacement du carré)
					cptPrescaler <= 0;
					
					if(stv4_in_sensX > "0000") then -- sens inverse X 
						int_cptX <= int_cptX+(15-int_valDataX);
					else -- sens X
						int_cptX <= int_cptX-int_valDataX;
					end if;
					
					if(stv4_in_sensY < "1111") then -- sens inverse Y 
						int_cptY <= int_cptY+int_valDataY;
					else -- sens Y
						int_cptY <= int_cptY-(15-int_valDataY);
					end if;
					
					-- atteinte butée max/min X
					if(int_cptX > MAXX) then
						int_cptX <= 0;
					end if;
					if(int_cptX < 0) then
						int_cptX <= MAXX;
					end if;
					
					-- atteinte butée max/min Y
					if(int_cptY > MAXY) then
						int_cptY <= 0;
						end if;
					if(int_cptY < 0) then
						int_cptY <= MAXY;
					end if;
					
				end if;
			end if;
			
		end if;
	end process;
	
	-- assignation des compteurs aux sorties
	int_out_XJoueur <= int_cptX;
	int_out_YJoueur <= int_cptY;
	
	-- conversion des vecteurs en entiers
	int_valDataX <= to_integer(unsigned(stv4_in_dataX));
	int_valDataY <= to_integer(unsigned(stv4_in_dataY));
		
end arch_CalcPosJoueur;