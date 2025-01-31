-- Module de détection de collision entre le joueur et la cible (seuil de collision réglable à partir de la variable : COLLISION_RADIUS dans PrjPack)
library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.numeric_std.ALL; 

use work.PrjPack.all;

entity CollisionDetector is port(
	--inputs
	signal int_in_XPosCible 	: in integer range 0 to MAXX := MAXX/2;
	signal int_in_YPosCible 	: in  integer range 0 to MAXY := MAXY/2;
	signal int_in_XPosJoueur 	: in  integer range 0 to MAXX := MAXX/2;
	signal int_in_YPosJoueur 	: in  integer range 0 to MAXY := MAXY/2;
	
	--outputs
	signal st_out_hasCollided 	: out std_logic
);
end CollisionDetector;

architecture arch_CollisionDetector of CollisionDetector is
begin
	-- Condition de collision : lorsque le joueur entre dans une zone carrée de côté 2*COLLISION_RADIUS centrée sur la position de la cible
	st_out_hasCollided <= '1' when ((int_in_XPosJoueur <= int_in_XPosCible+COLLISION_RADIUS) and (int_in_XPosJoueur >= int_in_XPosCible-COLLISION_RADIUS) and (int_in_YPosJoueur <= int_in_YPosCible+COLLISION_RADIUS) and (int_in_YPosJoueur >= int_in_YPosCible-COLLISION_RADIUS)) else '0';

end arch_CollisionDetector;
