--package du projet : 
library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

Package PrjPack is
	
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

	
	component decoder7seg port( 
		  stv4_int_data  : in  std_logic_vector(3 downto 0);
		  st_int_en : in std_logic;
        stv7_out_seg : out std_logic_vector(6 downto 0)
		  );
	end component;
	
end PrjPack;
