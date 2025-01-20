library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity accelSensor is
	port(
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
end accelSensor;

architecture STR of accelSensor is
	signal go : std_logic;
	signal pol : std_logic;
	signal pha : std_logic;
	signal bytes : std_logic_vector (3 downto 0);
	signal rxData : std_logic_vector (7 downto 0);
	signal rxDataReady	: std_logic := '0';
	signal txData 		:		 std_logic_vector (7 downto 0);
	signal accel_data	:		 std_logic_vector (47 downto 0);
	signal sclk_out : std_logic;
	signal sclk_buffer	:	std_logic;
	signal mosi_buffer	:	std_logic;
	signal cs_buffer	:	std_logic;
	signal int1_buffer : std_logic;
	signal stateID : std_logic_vector(2 downto 0);
	
begin
	stv4_out_dataX <= accel_data(7 downto 4);
	stv4_out_sensX <= accel_data(11 downto 8);
	stv4_out_dataY <= accel_data(23 downto 20);
	stv4_out_sensY <= accel_data(27 downto 24);
	------------------------------------
	--SPI MASTER
	------------------------------------
	U_SPI_MASTER	:	entity work.spi_master(FSM_1P)
		port map(
		clk	=> st_in_clk50MHz,
		rst	=> '0',
      mosi	=> mosi_buffer,
		miso 	=> st_in_miso,
		sclk_out => sclk_out,
		cs_out	=> cs_buffer,
		int1 	=> '0',
		int2 	=> '0',
		go		=> go,
		pol	=> pol,
		pha   => pha,
		bytes => bytes,
		rxData	=> rxData,
		txData	=> txData,
		rxDataReady	=> rxDataReady
	);

	st_out_mosi 			<= mosi_buffer;
	st_out_cs 				<= cs_buffer;
	st_out_sclk 			<= sclk_buffer;
	
	
	U_ACCEL_DRIVER : entity work.accel_driver(FSM_1P)
		port map(
			rst			=> '0',
			clk			=> st_in_clk50MHz,
			int1			=> int1_buffer,
			rxDataReady	=> rxDataReady,
			go				=> go,
			pol			=> pol,
			pha			=> pha,
			bytes 		=> bytes,
			txData 		=> txData,
			rxData		=> rxData,
			accel_data	=> accel_data,
			stateID 		=> stateID,
			intBypass 	=> st_in_intBypass
		);
	
	------------------------------------
	--      MSB       LSB
	--	XL =  7 downto  0
	--	XH = 15 downto  8
	--	YL = 23 downto 16
	--	YH = 31 downto 24
	--	ZL = 39 downto 32
	--	ZH = 47 downto 40
--	------------------------------------
	
	process(st_in_clk50MHz)
	begin

		if(st_in_clk50MHz'event and st_in_clk50MHz = '1') then
			sclk_buffer <= sclk_out;
			int1_buffer <= st_in_int1;
		end if;
	end process;

end STR;









