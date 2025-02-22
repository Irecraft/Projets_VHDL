library IEEE;
use IEEE.std_logic_1164.all;

-- Définition projet
Package drapeauPack is
	-- Constantes
	constant XA : integer := 160-1;
	constant XAB : integer := 270-1;
	constant XABC : integer := 1270-1;
	constant XABCD : integer := 1320-1;
	
	constant YA : integer := 4-1;
	constant YAB : integer := 27-1;
	constant YABC : integer := 627-1;
	constant YABCD : integer := 628-1;
	
	constant MAXX : integer := 1000-1;
	constant MAXY : integer := 600-1;
	
	constant X_MILIEU : integer := XAB+(XABC-XAB)/2;
	constant Y_MILIEU : integer := YAB+(YABC-YAB)/2;
	
	constant VAL_COTE_CARRE : integer := 244;

	-- Composants utilisés (et non instanciés pour l'instant)
	component CompteurX port(
		-- inputs
		signal st_in_clk : in std_logic;
		-- outputs
		signal st_out_posXpixel : out integer;
		signal st_out_syncLigne : out std_logic;
		signal st_out_finLigne : out std_logic);
	end component;
	
	component CompteurY port(
		-- inputs
		signal st_in_clk : in std_logic;
		signal st_in_en : in std_logic;
		-- outputs
		signal st_out_posYpixel : out integer;
		signal st_out_syncTrame : out std_logic;
		signal st_out_AnimImageSync : out std_logic);
	end component;
	
	component CalcPosCarre port(
		-- inputs
		signal st_in_clk : in std_logic;
		signal st_in_syncImage : in std_logic;
		-- outputs
		signal int_out_XCarre : out integer;
		signal int_out_YCarre : out integer);
	end component;
	
	component GeneRGB port(
		-- inputs
		signal st_in_posXpixel : in integer;
		signal st_in_posYpixel : in integer;
		signal st_in_posXCarre : in integer;
		signal st_in_posYCarre : in integer;
		-- outputs
		signal st_out_RComponent : out std_logic;
		signal st_out_GComponent : out std_logic;
		signal st_out_BComponent : out std_logic); 
	end component;
	
end drapeauPack;