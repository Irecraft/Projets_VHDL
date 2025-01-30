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
	st_out_hasCollided <= '1' when ((int_in_XPosJoueur <= int_in_XPosCible+COLLISION_RADIUS) and (int_in_XPosJoueur >= int_in_XPosCible-COLLISION_RADIUS) and (int_in_YPosJoueur <= int_in_YPosCible+COLLISION_RADIUS) and (int_in_YPosJoueur >= int_in_YPosCible-COLLISION_RADIUS)) else '0';

end arch_CollisionDetector;
