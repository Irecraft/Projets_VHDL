--Instanciation projet global : 
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

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
		--stv7_out_7seg2 : out std_logic_vector(6 downto 0);
		--stv7_out_7seg3 : out std_logic_vector(6 downto 0);
		stv7_out_7seg4 : out std_logic_vector(6 downto 0);
		stv7_out_7seg5 : out std_logic_vector(6 downto 0);
		--st_out_segDp0 : out std_logic;
		--st_out_segDp1 : out std_logic;
		--st_out_segDp2 : out std_logic;
		--st_out_segDp3 : out std_logic;
		--st_out_segDp4 : out std_logic;
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
		st_in_pB0 		: 	in std_logic;
		st_in_pB1 		: 	in std_logic;

--Signaux pour switches (p26 doc DE10-Lite_User_Manual.pdf) : 
		st_in_sw0 		: 	in std_logic;
		st_in_sw1 		: 	in std_logic;
		st_in_sw2 		: 	in std_logic;
		st_in_sw3 		: 	in std_logic;
		st_in_sw4 		: 	in std_logic;
		st_in_sw5 		: 	in std_logic;
		st_in_sw6 		: 	in std_logic;
		st_in_sw7 		: 	in std_logic;
		st_in_sw8 		: 	in std_logic;
		st_in_sw9 		: 	in std_logic;		

--Signaux pour Arduino Expansion (p32 doc DE10-Lite_User_Manual.pdf) : 
		st_out_arduinoIO7 : out std_logic;
		st_out_arduinoIO6 : out std_logic
		);
end Projet2024;

use work.PrjPack.all;

architecture arch_Projet2024 of Projet2024 is 
	signal stv4_dataX : std_logic_vector(3 downto 0);
	signal stv4_sensX : std_logic_vector(3 downto 0);
	signal stv4_dataY : std_logic_vector(3 downto 0);
	signal stv4_sensY : std_logic_vector(3 downto 0);
	
begin 
		Aff0 : decoder7seg 
		port map(
			stv4_int_data => stv4_dataX,
			st_int_en => '0',
			stv7_out_seg => stv7_out_7seg0
		);
	
		Aff1 : decoder7seg 
		port map(
			stv4_int_data => stv4_sensX,
			st_int_en => '0',
			stv7_out_seg => stv7_out_7seg1
		);
		
		Aff4 : decoder7seg 
		port map(
			stv4_int_data => stv4_dataY,
			st_int_en => '0',
			stv7_out_seg => stv7_out_7seg4
		);
		
		Aff5 : decoder7seg 
		port map(
			stv4_int_data => stv4_sensY,
			st_int_en => '0',
			stv7_out_seg => stv7_out_7seg5
		);
		
	accelSensor0 : accelSensor 
		port map(
			st_in_clk50MHz => st_in_clk50MHz,
			st_out_mosi => st_out_mosi,
			st_in_miso => st_in_miso,
			st_out_sclk => st_out_sclk, 
			st_out_cs  => st_out_cs,
			st_in_int1  => st_in_int1,
			st_in_intBypass  => st_in_intBypass,
			stv4_out_dataX  => stv4_dataX,
			stv4_out_sensX  => stv4_sensX,
			stv4_out_dataY  => stv4_dataY,
			stv4_out_sensY  => stv4_sensY
		);
		
end arch_Projet2024;
