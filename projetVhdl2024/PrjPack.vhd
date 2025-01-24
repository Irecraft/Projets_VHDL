--package du projet : 
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Package PrjPack is

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
	
	constant VAL_COTE_CARRE : integer := 50;
	constant PRESCALER_VITESSE_CARRE : integer := 1700;
	-- Fin constantes
	
	-- composant gestion accéléromètre
	component accelSensor port( 
		st_in_clk50MHz : 	in std_logic;
		st_out_mosi		: 	out std_logic;
		st_in_miso 		: 	in std_logic;
		st_out_sclk 	: 	out std_logic;
		st_out_cs 		: 	out std_logic;
		st_in_int1 		: 	in std_logic;
		st_in_intBypass: 	in std_logic;
		stv4_out_dataX : out std_logic_vector(3 downto 0);
		stv4_out_sensX : out std_logic_vector(3 downto 0);
		stv4_out_dataY : out std_logic_vector(3 downto 0);
		stv4_out_sensY : out std_logic_vector(3 downto 0)
		);
	end component;
	
	-- convertisseur entier - segements afficheur
	component decoder7seg port( 
		  stv4_int_data  : in  std_logic_vector(3 downto 0);
		  st_int_en : in std_logic;
        stv7_out_seg : out std_logic_vector(6 downto 0)
		  );
	end component;
	
	-- compteur pixels horizontaux
	component CompteurX port(
		-- inputs
		signal st_in_clk : in std_logic;
		-- outputs
		signal st_out_posXpixel : out integer;
		signal st_out_syncLigne : out std_logic;
		signal st_out_finLigne : out std_logic
		);
	end component;
	
	-- compteur lignes de pixels
	component CompteurY port(
		-- inputs
		signal st_in_clk : in std_logic;
		signal st_in_en : in std_logic;
		-- outputs
		signal st_out_posYpixel : out integer;
		signal st_out_syncTrame : out std_logic;
		signal st_out_AnimImageSync : out std_logic
		);
	end component;
	
	-- Calculateur de la position carré en fonction accel
	component CalcPosCarre port(
		-- inputs
		signal st_in_clk : in std_logic;
		signal st_in_syncImage : in std_logic;
		signal stv4_in_dataX : in std_logic_vector(3 downto 0);
		signal stv4_in_sensX : in std_logic_vector(3 downto 0);
		signal stv4_in_dataY : in std_logic_vector(3 downto 0);
		signal stv4_in_sensY : in std_logic_vector(3 downto 0);
		-- outputs
		signal int_out_XCarre : out integer;
		signal int_out_YCarre : out integer
		);
	end component;
	
	-- Générateur de l'image
	component GeneRGB port(
		-- input
		signal st_in_posXpixel : in integer;
		signal st_in_posYpixel : in integer;
		signal st_in_posXCarre : in integer;
		signal st_in_posYCarre : in integer;
		
		-- outputs
		signal st_out_RComponent : out std_logic;
		signal st_out_GComponent : out std_logic;
		signal st_out_BComponent : out std_logic
		); 
	end component;
	
end PrjPack;
