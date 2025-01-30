library IEEE;
use IEEE.std_logic_1164.all;

use work.PrjPack.all;

entity GeneRGB is port(
	-- input
	signal int_in_posXpixel 	: in integer;
	signal int_in_posYpixel 	: in integer;
	signal int_in_posXCible 	: in integer;
	signal int_in_posYCible 	: in integer;
	signal int_in_posXJoueur 	: in integer;
	signal int_in_posYJoueur 	: in integer;
	
	-- outputs
	signal st_out_RComponent : out std_logic;
	signal st_out_GComponent : out std_logic;
	signal st_out_BComponent : out std_logic); 
end GeneRGB;

architecture arch_GeneRGB of GeneRGB is
signal validR 		: STD_LOGIC;
signal validG 		: STD_LOGIC;
signal validB 		: STD_LOGIC;
signal validPix 	: STD_LOGIC;

--Définition des variables internes

begin

	validPix <= '1' when ((int_in_posYpixel > YAB) and (int_in_posYpixel <= YABC)) else '0';
	
	validR <= '1' when ((int_in_posXpixel >= (XAB+int_in_posXCible)-(VAL_COTE_CARRE_CIBLE/2)) and (int_in_posXpixel < (XAB+int_in_posXCible)+(VAL_COTE_CARRE_CIBLE/2)) and (int_in_posYpixel >= (YAB+int_in_posYCible)-(VAL_COTE_CARRE_CIBLE/2)) and (int_in_posYpixel < (YAB+int_in_posYCible)+(VAL_COTE_CARRE_CIBLE/2)) and (validPix = '1')) else '0';
	-- carré vert Joueur
	validG <= '1' when ((int_in_posXpixel >= (XAB+int_in_posXJoueur)-(VAL_COTE_CARRE_JOUEUR/2)) and (int_in_posXpixel < (XAB+int_in_posXJoueur)+(VAL_COTE_CARRE_JOUEUR/2)) and (int_in_posYpixel >= (YAB+int_in_posYJoueur)-(VAL_COTE_CARRE_JOUEUR/2)) and (int_in_posYpixel < (YAB+int_in_posYJoueur)+(VAL_COTE_CARRE_JOUEUR/2)) and (validPix = '1')) else '0';
	validB <= '1' when (false) else '0';

	st_out_RComponent <= validR;
	st_out_GComponent <= validG;
	st_out_BComponent <= validB;
	
end arch_GeneRGB;