library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity accel_driver is
	port (
		rst			:		in std_logic;
		clk			:		in std_logic;
		int1			:		in std_logic;
		rxDataReady	:		in	std_logic;
		go				:		out std_logic;
		pol			:		out std_logic;
		pha			:		out std_logic;
		bytes 		:		out std_logic_vector (3 downto 0);
		txData 		:		out std_logic_vector (7 downto 0);
		rxData		: 		in std_logic_vector ( 7 downto 0);
		accel_data	:		out std_logic_vector (47 downto 0);
		stateID 		:      out std_logic_vector (2 downto 0);
		intBypass   : in std_logic
	);
end accel_driver;

architecture fsm_1p of accel_driver is
	signal m				:  std_logic;
	constant max	: natural := 50000000 /  500000 ;
	signal count			:		integer range 0 to max;
	signal countSignal		: std_logic;
	type STATE_TYPE is (S_START, S_IDLE, S_CONFIG, S_WRITE, S_READ, S_READ_WAIT, S_CALIBRATE, S_OUTPUT); 
	signal STATE, NEXT_STATE			:		STATE_TYPE;
	signal accel_data_buff : std_logic_vector( 47 downto 0);
	signal byteCount	: integer range -1 to 16 := 0;
	constant byteCountRead : integer := 7;
	signal mode			: std_logic;
	signal reg	: integer range 0 to 8;
	signal regTest : integer range 0 to 16;
	signal regAddr		: std_logic_vector (5 downto 0);
	signal regData		: std_logic_vector (7 downto 0);
	signal rxDataReadyLast : std_logic := '0';
	constant sampleBits : natural := 4;
	constant samples  : natural := 2 ** sampleBits;
	signal sample_count : integer range 0 to samples + 1;
	signal calibrate : std_logic;
	type calibration_array is array (2 downto 0) of std_logic_vector (15 downto 0); 
	signal calibData : calibration_array;

	begin
	process(clk, rst)
	begin
		if(rst = '1') then
			state <= S_START;
			accel_data <= (others => '0');
			accel_data_buff <= (others => '0');
			regData <= "00000000";
			regAddr <= "000000";
			bytes <= "0000";
			txData <= "00000000";
			mode <= '0';
			count <= 0;
			go <= '0';
			reg <= 0;
			regTest <= 0;
			byteCount <= 0;
			stateID <= "000";
			calibrate <= '0';
			calibData(0) <= (others => '0');
			calibData(1) <= (others => '0');
			calibData(2) <= (others => '0');
			sample_count <= 0;
		elsif(clk'event and clk = '1') then
			case state is
				when S_START =>
					byteCount <= 0;
					mode <= '0';
					reg <= 0;
					rxDataReadyLast <= '0';
					state <= S_IDLE;
					accel_data <= (others => '0');
					go <= '0';
					stateID <= "001";
				when S_IDLE =>
					stateID <= "010";
					if(count = max - 1) then							
						if(mode = '0') then
							state <= S_CONFIG;		
							count <= 0; 
						else
							state <= S_READ_WAIT;	
							count <= 0;
						end if;	
					else 
						count <= count + 1;
					end if;
				when S_READ_WAIT =>
					stateID <= "111";
					if (calibrate = '1') then state <= S_CALIBRATE;
					elsif(int1 = '1' or intBypass = '1') then state <= S_READ;
					end if;
				when S_CALIBRATE => 
					case reg is								
						when 0 =>							
							if(calibData(0)(15) = '0') then  
								calibData(0) <= std_logic_vector(signed(not calibData(0)) + 1);	
							else
								calibData(0) <= std_logic_vector(not(signed(calibData(0)) - 1)); 
							end if;							
							if(calibData(1)(15) = '0') then 
								calibData(1) <= std_logic_vector(signed(not calibData(1)) + 1);	
							else
								calibData(1) <= std_logic_vector(not(signed(calibData(1)) - 1)); 
							end if;							
							calibData(2) <=std_logic_vector(shift_right(signed(calibData(2)) - 256, 2));	
							reg <= reg + 1;						
						when 1 =>																											
							if(calibData(2)(15) = '0') then 													
								calibData(2) <= std_logic_vector(signed(not calibData(2)) + 1);	
							else
								calibData(2) <= std_logic_vector(not(signed(calibData(2)) - 1));  
							end if;							
							regAddr <= "011110";																	
							regData <= calibData(0)(7 downto 0);															
							reg <= reg + 1;	
							state  <= S_WRITE;
						when 2 =>
							regAddr <= "011111";																	
							regData <= calibData(1)(7 downto 0);
							reg <= reg + 1;
							state  <= S_WRITE;
						when 3 =>
							regAddr <= "100000";																	
							regData <= calibData(2)(7 downto 0);
							reg <= 0;
							state  <= S_WRITE;
							calibrate <= '0';																		
						when others => null;					
					end case;
							
				when S_CONFIG =>
						stateID <= "011";
					case reg is
						when 0 =>
							regAddr <= "110001"; 
							regData <= "00001000";   
							reg <= reg + 1;
							state <= S_WRITE;
						when 1 => 
							regAddr <= "101100";  
							regData <= "00000100";
							reg <= reg + 1;
							state <= S_WRITE;
						when 2 =>
							regAddr <= "011110";					
							regData <= "00000000";				
							reg <= reg + 1;
							state  <= S_WRITE;
							
						when 3 =>
							regAddr <= "011111";					
							regData <= "00000000";				
							reg <= reg + 1;
							state  <= S_WRITE;
						
						when 4 =>
							regAddr <= "100000";				
							regData <= "00000000";				
							reg <= reg + 1;
							state  <= S_WRITE;
						
						when 5 => 
							regAddr <= "101101";	  
							regData <= "00001000";
							reg <= reg + 1;
							state <= S_WRITE;
		
						when 6 => 
							regAddr <= "101110";	 
							regData <= "10000000";
							reg <= 0;
							state <= S_WRITE;
							mode <= '1';			
						when others => null;
					end case;
				
				when S_WRITE =>
					stateID <= "100";
					bytes <= "0010";
					rxDataReadyLast <= rxDataReady;
					if(byteCount = 0) then
						txData <= "00" & regAddr;
						go <= '1';
						byteCount <= 1;
					elsif((rxDataReadyLast = '0' and rxDataReady = '1') and byteCount = 1) then  
						byteCount <= 2;
						go <= '0';
						txData <= regData;
					elsif((rxDataReadyLast = '0' and rxDataReady = '1') and byteCount = 2) then  
						byteCount <= 3;
							
						
					elsif((rxDataReadyLast = '1' and rxDataReady = '0') and byteCount = 3) then  
						state <= S_IDLE;
						byteCount <= 0;
					end if;
				when S_READ =>
					stateID <= "101";
					mode <= '1';
					bytes <= std_logic_vector(to_unsigned(byteCountRead, bytes'length));
					rxDataReadyLast <= rxDataReady;
					if(byteCount = 0) then														
						txData <= "11110010";
						go <= '1';
						byteCount <= 1;
					elsif(byteCount = 1) then													
						txData <= "00000000";							
						go <= '0';
						if((rxDataReadyLast = '1' and rxDataReady = '0')) then		
							byteCount <= 2;
						end if;
						
					else																				
						txData <= "00000000";
						go <= '0';
						
						if((rxDataReadyLast = '1' and rxDataReady = '0') and byteCount <= byteCountRead) then
							if(byteCount = byteCountRead) then
								byteCount <= 0;
								state <= S_OUTPUT;
							else
								byteCount <= byteCount + 1;
								accel_data_buff(((byteCount-1) * 8)  - 1 downto (byteCount-2) * 8) <=  rxData;
							end if;


						end if;
						
						
					end if;
				when S_OUTPUT =>
					stateID <= "110";
					
					if(sample_count <= samples) then				
						if(sample_count = samples) then			
							calibrate <= '1';							
							calibData(0) <= std_logic_vector(shift_right(signed(calibData(0)), 2 + sampleBits)); 
							calibData(1) <= std_logic_vector(shift_right(signed(calibData(1)), 2 + sampleBits));
							calibData(2) <= std_logic_vector(shift_right(signed(calibData(2)), sampleBits)); 
						else 											
							calibData(0) <= std_logic_vector(signed(calibData(0)) + signed(accel_data_buff(15 downto   0))); 
							calibData(1) <= std_logic_vector(signed(calibData(1)) + signed(accel_data_buff(31 downto  16))); 
							calibData(2) <= std_logic_vector(signed(calibData(2)) + signed(accel_data_buff(47 downto  32))); 							
						end if;
						sample_count <= sample_count + 1;	
					accel_data <= accel_data_buff;
					else
						accel_data <= accel_data_buff;			
					end if;
						state <= S_IDLE;							
					
				when others => 
					stateID <= "111";
						NULL;	
			end case;
			pol <= '1';
			pha <= '1';
		
		end if;
		
	end process;
		m <= mode;
end fsm_1p;

architecture fsm_2p of accel_driver is
	constant max	: natural := 50000000 / 5000000 ;
	signal count			:		integer range 0 to max;
	signal countSignal		: std_logic;
	type STATE_TYPE is (S_START, S_IDLE, S_CONFIG, S_WRITE, S_READ, S_OUTPUT);
	signal STATE, NEXT_STATE			:		STATE_TYPE;
	signal accel_data_buff : std_logic_vector( 47 downto 0);
	signal byteCount	: integer range -1 to 16;
	constant byteCountRead : integer := 7;
	signal mode			: std_logic;
	signal reg	: integer range 0 to 3;
	signal regAddr		: std_logic_vector (5 downto 0);
	signal regData		: std_logic_vector (3 downto 0);
	signal rxDataReadyLast : std_logic := '0';
begin

	process(clk, rst)
	begin
		if(rst = '1') then
			state <= S_START;
			count <= 0;			
		elsif(clk'event and clk = '1') then		
			if(state = S_IDLE) then
				if(count = max - 1) then
				count <= 0;
				state <= next_state;		
				else 
				count <= count + 1;
				state <= S_IDLE;
				end if;			
			else		
			state <= next_state;
			end if;				
		end if;		
	end process;

	process(state, rxDataReady)
	begin
			next_state <= state;
			go <= '0';
			reg <= 0;
			accel_data <= (others => '0');
			regData <= "0000";
			regAddr <= "000000";
			bytes <= "0000";
			txData <= "00000000";
			mode <= '0';
		case state is
		
			when S_START =>
				byteCount <= 0;
				mode <= '0';
				reg <= 0;
				rxDataReadyLast <= '0';
				next_state <= S_IDLE;
				accel_data <= (others => '0');
				
			when S_IDLE =>
				mode <= mode;
				reg <= reg;
				if(mode = '0') then next_state <= S_CONFIG;
				else next_state <= S_READ;
				end if;	
							
			when S_CONFIG =>
				case reg is
					when 0 =>
						regAddr <= "110001";
						regData <= "1000";
						reg <= reg + 1;
						next_state <= S_WRITE;
					when 1 => 
						regAddr <= "101100";
						regData <= "0100";
						reg <= reg + 1;
						next_state <= S_WRITE;
					when 2 => 
						regAddr <= "101101";
						regData <= "1000";
						reg <= 0;
						next_state <= S_WRITE;
						mode <= '1';

					when others => null;
				end case;
			
			when S_WRITE =>
				bytes <= "0010";
				rxDataReadyLast <= rxDataReady;
				regAddr <= regAddr;
				regData <= regData;
				reg <= reg;
				mode <= mode;
				if(byteCount = 0) then
					txData <= "00" & regAddr;
					go <= '1';
					byteCount <= 1;
				elsif((rxDataReadyLast = '0' and rxDataReady = '1') and byteCount = 1) then  
					byteCount <= 2;
					go <= '0';
					txData <= "0000" & regData;
				elsif((rxDataReadyLast = '0' and rxDataReady = '1') and byteCount = 2) then  
					byteCount <= 3;				
				elsif((rxDataReadyLast = '1' and rxDataReady = '0') and byteCount = 3) then  
					next_state <= S_IDLE;
					byteCount <= 0;
				end if;
			when S_READ =>
				mode <= '1';
				bytes <= std_logic_vector(to_unsigned(byteCountRead, bytes'length));
				rxDataReadyLast <= rxDataReady;
				if(byteCount = 0) then
					txData <= "11110010";
					go <= '1';
					byteCount <= 1;
				else
					txData <= "00000000";
					go <= '0';
					if((rxDataReadyLast = '1' and rxDataReady = '0') and byteCount <= byteCountRead) then
						if(byteCount = byteCountRead) then
							byteCount <= 0;
							next_state <= S_OUTPUT;
						else
							byteCount <= byteCount + 1;
							accel_data_buff((byteCount * 8)  - 1 downto (byteCount-1) * 8) <= rxData;
						end if;
					end if;					
				end if;
			when S_OUTPUT =>
				mode <= '1';
				accel_data <= accel_data_buff;
				next_state <= S_IDLE;
			when others => 
				NULL;		
		end case;
		pol <= '1';
		pha <= '1';		
	end process;
end fsm_2p;