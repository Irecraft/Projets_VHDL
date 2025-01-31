-- Module de calcul de la position de la cible avec générateur aléatoire.
library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.numeric_std.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.PrjPack.all;

entity CalcPosCible is port(
		-- inputs
		signal st_in_clk 			: in std_logic;
		signal st_in_enB 			: in std_logic;
		signal st_in_rstB 		: in std_logic;
		signal st_in_syncImage 	: in std_logic;
		-- outputs
		signal int_out_XPosCible : out integer range 0 to MAXX;
		signal int_out_YPosCible : out integer range 0 to MAXY
		);
end CalcPosCible;

architecture arch_CalcPosCible of CalcPosCible is
signal stv20_compteur 	: std_logic_vector(19 downto 0);
signal int_XPosCible 	: integer range 0 to MAXX := MAXX/2;
signal int_YPosCible 	: integer range 0 to MAXY := MAXY/2;

begin

	process(st_in_clk,st_in_syncImage) --
	begin
		if(st_in_clk'event and (st_in_clk = '1')) then
		
			stv20_compteur <= stv20_compteur +1;	-- La génération aléatoire se fait à partir d'un compteur assigné à l'horloge de 50MHz, sauvegardé dans son état et réparti dans deux variables de position lorsque le signal st_in_enB est à l'état bas
			
			if(st_in_rstB = '0') then
				int_XPosCible <= MAXX/2;
				int_YPosCible <= MAXY/2;
			elsif(st_in_enB = '0') then
				
				if(st_in_syncImage = '0') then
					int_XPosCible <= (to_integer(unsigned(stv20_compteur(MAXX_BIT_SIZE downto 0))) mod (MAXX+1-VAL_COTE_CARRE_CIBLE))+VAL_COTE_CARRE_CIBLE/2;
					int_YPosCible <= (to_integer(unsigned(stv20_compteur(MAXY_BIT_SIZE+MAXX_BIT_SIZE downto (MAXX_BIT_SIZE+1)))) mod (MAXY+1-VAL_COTE_CARRE_CIBLE))+VAL_COTE_CARRE_CIBLE/2;
				end if;
			end if;
			
		end if;
	
	end process;
	
	int_out_XPosCible <= int_XPosCible;
	int_out_YPosCible <= int_YPosCible;
	
end arch_CalcPosCible;