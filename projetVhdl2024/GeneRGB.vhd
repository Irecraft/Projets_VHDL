library IEEE;
use IEEE.std_logic_1164.all;

use work.PrjPack.all;

entity GeneRGB is port(
	-- input
	signal st_in_posXpixel : in integer;
	signal st_in_posYpixel : in integer;
	signal st_in_posXCarre : in integer;
	signal st_in_posYCarre : in integer;
	
	-- outputs
	signal st_out_RComponent : out std_logic;
	signal st_out_GComponent : out std_logic;
	signal st_out_BComponent : out std_logic); 
end GeneRGB;

architecture arch_GeneRGB of GeneRGB is
signal validR : STD_LOGIC;
signal validG : STD_LOGIC;
signal validB : STD_LOGIC;
signal validPix : STD_LOGIC;

--Définition des variables internes

begin

	validPix <= '1' when ((st_in_posYpixel > YAB) and (st_in_posYpixel <= YABC)) else '0';
	
	-- carré vert
	
	validR <= '1' when (false) else '0';
	validG <= '1' when ((st_in_posXpixel >= (XAB+st_in_posXCarre)-(VAL_COTE_CARRE/2)) and (st_in_posXpixel < (XAB+st_in_posXCarre)+(VAL_COTE_CARRE/2)) and (st_in_posYpixel >= (YAB+st_in_posYCarre)-(VAL_COTE_CARRE/2)) and (st_in_posYpixel < (YAB+st_in_posYCarre)+(VAL_COTE_CARRE/2)) and (validPix = '1')) else '0';
	validB <= '1' when (false) else '0';

	st_out_RComponent <= validR;
	st_out_GComponent <= validG;
	st_out_BComponent <= validB;
	
end arch_GeneRGB;