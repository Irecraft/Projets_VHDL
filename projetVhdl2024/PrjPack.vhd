--package du projet : 
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Package PrjPack is

	-- Constantes
	constant XA : integer 	:= 160-1;
	constant XAB : integer 	:= 270-1;
	constant XABC : integer := 1270-1;
	constant XABCD : integer:= 1320-1;
	
	constant YA : integer 	:= 4-1;
	constant YAB : integer 	:= 27-1;
	constant YABC : integer := 627-1;
	constant YABCD : integer:= 628-1;
	
	-- Changer la résolution implique de changer également la taille du buffer du compteur random
	constant MAXX : integer := 1000-1;
	constant MAXX_BIT_SIZE 	: integer := 10-1;
	constant MAXY : integer := 600-1;
	constant MAXY_BIT_SIZE 	: integer := 10-1;
	
	constant COLLISION_RADIUS : integer := 30; -- carré de détection de collision joueur x pixels autour de la position cible
	
	constant X_MILIEU : integer := XAB+(XABC-XAB)/2;
	constant Y_MILIEU : integer := YAB+(YABC-YAB)/2;
	
	constant VAL_COTE_CARRE_JOUEUR 		: integer := 50;
	constant VAL_COTE_CARRE_CIBLE 		: integer := 70;
	constant PRESCALER_VITESSE_JOUEUR 	: integer := 1700;
	
	constant MAX_CPT50M : integer := 50000000;
	

	-- Fin constantes
	
	
	-- Composant machine d'état
	component StateMachine port(
		-- Inputs
		signal st_in_clk 					: in std_logic;
		signal st_in_ResetB 				: in std_logic;
		signal st_in_StartB 				: in std_logic;
		signal st_in_CollisionDetect 	: in std_logic;
		signal st_in_timeOut 			: in std_logic;
		-- Outputs
		signal st_out_PosJoueurEnB 	: out std_logic;
		signal st_out_PosJoueurRstB 	: out std_logic;
		signal st_out_PosCibleEnB 		: out std_logic;
		signal st_out_PosCibleRstB 	: out std_logic;
		signal st_out_TimerEnB 			: out std_logic;
		signal st_out_TimerRstB 		: out std_logic;
		signal stv4_out_ScoreDizaines : out std_logic_vector(3 downto 0);
		signal stv4_out_ScoreUnites 	: out std_logic_vector(3 downto 0)
		);
	end component;
	
	-- composant gestion accéléromètre
	component accelSensor port( 
		st_in_clk50MHz : in std_logic;
		st_out_mosi		: out std_logic;
		st_in_miso 		: in std_logic;
		st_out_sclk 	: out std_logic;
		st_out_cs 		: out std_logic;
		st_in_int1 		: in std_logic;
		st_in_intBypass: in std_logic;
		stv4_out_dataX : out std_logic_vector(3 downto 0);
		stv4_out_sensX : out std_logic_vector(3 downto 0);
		stv4_out_dataY : out std_logic_vector(3 downto 0);
		stv4_out_sensY : out std_logic_vector(3 downto 0)
		);
	end component;
	
	-- convertisseur entier - segements afficheur
	component decoder7seg port( 
		  stv4_int_data  	: in  std_logic_vector(3 downto 0);
		  st_int_en 		: in std_logic;
        stv7_out_seg 	: out std_logic_vector(6 downto 0)
		  );
	end component;
	
	-- compteur pixels horizontaux
	component CompteurX port(
		-- inputs
		signal st_in_clk 				: in std_logic;
		-- outputs
		signal int_out_posXpixel 	: out integer;
		signal st_out_syncLigne 	: out std_logic;
		signal st_out_finLigne 		: out std_logic
		);
	end component;
	
	-- compteur lignes de pixels
	component CompteurY port(
		-- inputs
		signal st_in_clk		 			: in std_logic;
		signal st_in_en 					: in std_logic;
		-- outputs
		signal int_out_posYpixel 		: out integer;
		signal st_out_syncTrame 		: out std_logic;
		signal st_out_AnimImageSync 	: out std_logic
		);
	end component;
	
	-- Calculateur de la position du joueur en fonction accel
	component CalcPosJoueur port(
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
	end component;
	
	-- Calculateur de la position de la cible aléatoirement déclenché par st_in_enB (actif bas)
	component CalcPosCible port(
		-- inputs
		signal st_in_clk 				: in std_logic;
		signal st_in_enB 				: in std_logic;
		signal st_in_rstB 			: in std_logic;
		signal st_in_syncImage 		: in std_logic;
		-- outputs
		signal int_out_XPosCible 	: out integer range 0 to MAXX;
		signal int_out_YPosCible 	: out integer range 0 to MAXY
		);
	end component;
	
	-- Générateur de l'image
	component GeneRGB port(
		-- input
		signal int_in_posXpixel 	: in integer;
		signal int_in_posYpixel 	: in integer;
		signal int_in_posXJoueur 	: in integer;
		signal int_in_posYJoueur 	: in integer;
		signal int_in_posXCible 	: in integer;
		signal int_in_posYCible 	: in integer;
		
		-- outputs
		signal st_out_RComponent : out std_logic;
		signal st_out_GComponent : out std_logic;
		signal st_out_BComponent : out std_logic
		); 
	end component;
	
	-- (Dé)compteur de temps de jeu
	component GameTimer is port(
		-- inputs
		signal st_in_clk50M 	: in std_logic;
		signal st_in_enB 		: in std_logic;
		signal st_in_rstB 	: in std_logic;
		-- outputs
		signal st_out_TimeOut 			: out std_logic;
		signal stv4_out_TimerDizaines : out std_logic_vector(3 downto 0);
		signal stv4_out_TimerUnites 	: out std_logic_vector(3 downto 0)
		);
	end component;
	
	-- Détecteur de collisions
	component CollisionDetector is port(
		--inputs
		int_in_XPosCible 	: in  integer range 0 to MAXX := MAXX/2;
		int_in_YPosCible 	: in  integer range 0 to MAXY := MAXY/2;
		int_in_XPosJoueur : in  integer range 0 to MAXX := MAXX/2;
		int_in_YPosJoueur : in  integer range 0 to MAXY := MAXY/2;
		
		--outputs
		st_out_hasCollided : out std_logic
		);
	end component;
	
	
	
end PrjPack;
