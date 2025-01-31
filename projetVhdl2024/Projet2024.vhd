-- Instanciation projet global :
--
-- Repo Github du projet : https://github.com/Irecraft/Projets_VHDL/tree/main/projetVhdl2024
--	Contient l'ensemble des mises à jour
--

library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.PrjPack.all;

entity Projet2024 is port(
--Signaux pour Accelerometer Sensor (p39 doc DE10-Lite_User_Manual.pdf) :
		st_in_clk50MHz : 	in std_logic;
		st_out_mosi		: 	out std_logic;
		st_in_miso 		: 	in std_logic;
		st_out_sclk 	: 	out std_logic;
		st_out_cs 		: 	out std_logic;
		st_in_int1 		: 	in std_logic;
		st_in_intBypass: 	in std_logic;
		
--Signaux pour 7-segment Displays (p28 doc DE10-Lite_User_Manual.pdf) :
		stv7_out_7seg0 : out std_logic_vector(6 downto 0);
		stv7_out_7seg1 : out std_logic_vector(6 downto 0);
		stv7_out_7seg2 : out std_logic_vector(6 downto 0);
		stv7_out_7seg3 : out std_logic_vector(6 downto 0);
		stv7_out_7seg4 : out std_logic_vector(6 downto 0);
		stv7_out_7seg5 : out std_logic_vector(6 downto 0);
		--st_out_segDp0 : out std_logic;
		--st_out_segDp1 : out std_logic;
		st_out_segDp2 	: out std_logic;
		--st_out_segDp3 : out std_logic;
		st_out_segDp4 	: out std_logic;
		--st_out_segDp5 : out std_logic;

--Signaux pour VGA (p35 doc DE10-Lite_User_Manual.pdf) : 
		stv4_out_R : out std_logic_vector(3 downto 0);
		stv4_out_G : out std_logic_vector(3 downto 0);
		stv4_out_B : out std_logic_vector(3 downto 0);
		st_out_syncroTrame : out std_logic;
		st_out_syncroLigne : out std_logic;

--Signaux pour Leds (p27 doc DE10-Lite_User_Manual.pdf) : 
		st_out_Led0 : out std_logic;
		st_out_Led1 : out std_logic;
		st_out_Led2 : out std_logic;
		st_out_Led3 : out std_logic;
		st_out_Led4 : out std_logic;
		st_out_Led5 : out std_logic;
		st_out_Led6 : out std_logic;
		st_out_Led7 : out std_logic;
		st_out_Led8 : out std_logic;
		st_out_Led9 : out std_logic;

--Signaux pour Push-buttons (p25 doc DE10-Lite_User_Manual.pdf) : 
		st_in_pB0 	: 	in std_logic;
		st_in_pB1 	: 	in std_logic;

--Signaux pour switches (p26 doc DE10-Lite_User_Manual.pdf) : 
		st_in_sw0 	: 	in std_logic;
		st_in_sw1 	: 	in std_logic;
		st_in_sw2 	: 	in std_logic;
		st_in_sw3 	: 	in std_logic;
		st_in_sw4 	: 	in std_logic;
		st_in_sw5 	: 	in std_logic;
		st_in_sw6 	: 	in std_logic;
		st_in_sw7 	: 	in std_logic;
		st_in_sw8 	: 	in std_logic;
		st_in_sw9 	: 	in std_logic;		

--Signaux pour Arduino Expansion (p32 doc DE10-Lite_User_Manual.pdf) : 
		st_out_arduinoIO7 : out std_logic;
		st_out_arduinoIO6 : out std_logic
		);
end Projet2024;

architecture arch_Projet2024 of Projet2024 is 
	signal stv4_dataX : std_logic_vector(3 downto 0);
	signal stv4_sensX : std_logic_vector(3 downto 0);
	signal stv4_dataY : std_logic_vector(3 downto 0);
	signal stv4_sensY : std_logic_vector(3 downto 0);

	signal int_posXpixel 	: integer;
	signal int_posYpixel 	: integer;
	signal int_posXJoueur 	: integer range 0 to MAXX;
	signal int_posYJoueur 	: integer range 0 to MAXY;
	signal int_posXCible 	: integer range 0 to MAXX;
	signal int_posYCible 	: integer range 0 to MAXY;
	signal st_retenue 		: std_logic;
	signal st_R 				: std_logic;
	signal st_G 				: std_logic;
	signal st_B 				: std_logic;
	signal st_vsync 			: std_logic;
	signal st_hasCollided 	: std_logic;
	signal st_TimeOut 		: std_logic;
	signal st_enB_CalcPosJoueur 	: std_logic;
	signal st_rstB_CalcPosJoueur 	: std_logic;
	signal st_enB_CalcPosCible 	: std_logic;
	signal st_rstB_CalcPosCible 	: std_logic;
	signal st_enB_GameTimer 		: std_logic;
	signal st_rstB_GameTimer 		: std_logic;
	signal stv4_TimeLeftDizaines 	: std_logic_vector(3 downto 0);
	signal stv4_TimeLeftUnites 	: std_logic_vector(3 downto 0);
	signal stv4_ScoreDizaines 		: std_logic_vector(3 downto 0);
	signal stv4_ScoreUnites 		: std_logic_vector(3 downto 0);
	
begin 
	GlobalStateMachine : StateMachine
	port map(
		st_in_clk 					=> st_in_clk50MHz,
		st_in_ResetB 				=> st_in_pB0,
		st_in_StartB 				=> st_in_pB1,
		st_in_CollisionDetect 	=> st_hasCollided,
		st_in_timeOut 				=> st_TimeOut,
		st_out_PosJoueurEnB 		=> st_enB_CalcPosJoueur,
		st_out_PosJoueurRstB 	=> st_rstB_CalcPosJoueur,
		st_out_PosCibleEnB 		=> st_enB_CalcPosCible,
		st_out_PosCibleRstB 		=> st_rstB_CalcPosCible,
		st_out_TimerEnB 			=> st_enB_GameTimer,
		st_out_TimerRstB 			=> st_rstB_GameTimer,
		stv4_out_ScoreDizaines 	=> stv4_ScoreDizaines,
		stv4_out_ScoreUnites 	=> stv4_ScoreUnites
	);
	
	Aff0 : decoder7seg 
	port map(
		stv4_int_data 		=> stv4_ScoreUnites,
		st_int_en 			=> '0',
		stv7_out_seg 		=> stv7_out_7seg0
	);

	Aff1 : decoder7seg 
	port map(
		stv4_int_data 		=> stv4_ScoreDizaines,
		st_int_en 			=> '0',
		stv7_out_seg 		=> stv7_out_7seg1
	);
	
	Aff2 : decoder7seg 
	port map(
		stv4_int_data 		=> stv4_TimeLeftUnites,
		st_int_en 			=> '0',
		stv7_out_seg 		=> stv7_out_7seg2
	);

	Aff3 : decoder7seg 
	port map(
		stv4_int_data 		=> stv4_TimeLeftDizaines,
		st_int_en 			=> '0',
		stv7_out_seg 		=> stv7_out_7seg3
	);
	
	Aff4 : decoder7seg 
	port map(
		stv4_int_data 		=> stv4_dataX,
		st_int_en 			=> '0',
		stv7_out_seg 		=> stv7_out_7seg4
	);
	
	Aff5 : decoder7seg 
	port map(
		stv4_int_data 		=> stv4_dataY,
		st_int_en 			=> '0',
		stv7_out_seg 		=> stv7_out_7seg5
	);
		
	accelSensor0 : accelSensor 
		port map(
			st_in_clk50MHz    => st_in_clk50MHz,
			st_out_mosi       => st_out_mosi,
			st_in_miso        => st_in_miso,
			st_out_sclk       => st_out_sclk, 
			st_out_cs         => st_out_cs,
			st_in_int1        => st_in_int1,
			st_in_intBypass   => st_in_intBypass,
			stv4_out_dataX    => stv4_dataX,
			stv4_out_sensX 	=> stv4_sensX,
			stv4_out_dataY    => stv4_dataY,
			stv4_out_sensY 	=> stv4_sensY
		);
		
	CptX : CompteurX
		port map(
			st_in_clk 				=> st_in_clk50MHz,
			st_out_finLigne 		=> st_retenue,
			st_out_syncLigne 		=> st_out_syncroLigne,
			int_out_posXpixel 	=> int_posXpixel
		);
		
	CptY : CompteurY
		port map(
			st_in_clk 				=> st_in_clk50MHz,
			st_in_en 				=> st_retenue,
			st_out_syncTrame 		=> st_out_syncroTrame,
			st_out_AnimImageSync => st_vsync,
			int_out_posYpixel 	=> int_posYpixel
		);
	
	CalculateurPosJoueur : CalcPosJoueur
		port map(
			st_in_clk 			=> st_in_clk50MHz,
			st_in_enB 			=> st_enB_CalcPosJoueur,
			st_in_rstB			=> st_rstB_CalcPosJoueur,
			stv4_in_dataX 		=> stv4_dataX,
			stv4_in_sensX 		=> stv4_sensX,
			stv4_in_dataY 		=> stv4_dataY,
			stv4_in_sensY 		=> stv4_sensY,
			st_in_syncImage 	=> st_vsync,
			int_out_XJoueur 	=> int_posXJoueur,
			int_out_YJoueur 	=> int_posYJoueur
		);
		
	CalculateurPosCible : CalcPosCible
		port map(
			st_in_clk 			=> st_in_clk50MHz,
			st_in_enB 			=> st_enB_CalcPosCible,
			st_in_rstB			=> st_rstB_CalcPosCible,
			st_in_syncImage 	=> st_vsync,
			int_out_XPosCible => int_posXCible,
			int_out_YPosCible => int_posYCible
		);
	
	GenerateurRGB : GeneRGB
		port map(
			int_in_posXpixel 	=> int_posXpixel,
			int_in_posYpixel 	=> int_posYpixel,
			int_in_posXJoueur => int_posXJoueur,
			int_in_posYJoueur => int_posYJoueur,
			int_in_posXCible  => int_posXCible,
			int_in_posYCible  => int_posYCible,
			st_out_RComponent => st_R,
			st_out_GComponent => st_G,
			st_out_BComponent => st_B
		);
		
	GameTimerCpt : GameTimer
		port map(
			st_in_clk50M 				=> st_in_clk50MHz,
			st_in_enB 					=> st_enB_GameTimer,
			st_in_rstB 					=> st_rstB_GameTimer,
			st_out_TimeOut 			=> st_TimeOut,
			stv4_out_TimerDizaines 	=> stv4_TimeLeftDizaines,
			stv4_out_TimerUnites 	=> stv4_TimeLeftUnites
		);
		
	CollisionDetectorModule : CollisionDetector
		port map(
			int_in_XPosCible 		=> int_posXCible,
			int_in_YPosCible 		=> int_posYCible,
			int_in_XPosJoueur 	=> int_posXJoueur,
			int_in_YPosJoueur 	=> int_posYJoueur,
			st_out_hasCollided 	=> st_hasCollided
		);
		
	st_out_segDp2 <= '0';
	st_out_segDp4 <= '0';
	
	st_out_Led8 <= stv4_sensX(0);
	st_out_Led9 <= stv4_sensY(0);
	
	stv4_out_R(0) <= st_R;
	stv4_out_R(1) <= st_R;
	stv4_out_R(2) <= st_R;
	stv4_out_R(3) <= st_R;
	stv4_out_G(0) <= st_G;
	stv4_out_G(1) <= st_G;
	stv4_out_G(2) <= st_G;
	stv4_out_G(3) <= st_G;
	stv4_out_B(0) <= st_B;
	stv4_out_B(1) <= st_B;
	stv4_out_B(2) <= st_B;
	stv4_out_B(3) <= st_B;
		
end arch_Projet2024;

