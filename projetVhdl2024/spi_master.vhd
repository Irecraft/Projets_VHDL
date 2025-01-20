library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity spi_master is
    port (
		clk	: in std_logic;
		rst	: in std_logic;
      mosi	: out std_logic;
		miso 	: in std_logic;
		sclk_out : out std_logic; 
		cs_out	: out std_logic;
		int1 	: in std_logic;
		int2 	: in std_logic;
		go		: in std_logic;
		pol	: in std_logic;
		pha   : in std_logic;
		bytes : in std_logic_vector (3 downto 0);
		rxData: out std_logic_vector(7 downto 0);
		txData: in  std_logic_vector(7 downto 0);
		rxDataReady: out std_logic
		);
end spi_master;

architecture FSM_1P of spi_master is

------------------------------------
-- State signals
------------------------------------
type STATE_TYPE is (S_IDLE, S_TXRX);
signal state, next_state : STATE_TYPE;

------------------------------------
-- Clock Div (spi clock) Signals
------------------------------------
signal sclk : std_logic;
signal enable : std_logic := '0';

signal polarity : std_logic;
signal last_clk_active : std_logic;
signal clk_active : std_logic;
signal byte_flag : std_logic;

------------------------------------
-- SPI Data Signals
------------------------------------
signal rx_buffer	: std_logic_vector (7 downto 0) := (others => '1');
signal tx_buffer	: std_logic_vector (7 downto 0);
signal cs : std_logic := '1';
constant byte_w : natural := 8;
signal bit : integer range -1 to 8 := 7; 
signal w_r : std_logic := '0';
signal phase_Delay : std_logic := '0';
signal last_cs : std_logic := '1';
signal last_sclk : std_logic := '0';

begin
	U_CLOCK_DIV : entity work.clock_div
		generic map(
			clk_in_freq => 50000000,
			clk_out_freq => 5000000)
		port map(
			clk_in => clk,
			clk_out => sclk,
			rst	=> rst,
			enable => enable,
			bytes	=> bytes,
			polarity => polarity,
			clk_active => clk_active,
			byte_flag => byte_flag);
	
	process (clk, rst)
	begin
		if(rst = '1') then
			state <= S_IDLE;
			last_clk_active <= '0';
			enable <= '0';
			cs <= '1';
		elsif (clk'event and clk = '1') then
			rxDataReady <= '0'; 
			polarity <= pol;		
			enable <= '0';			
			last_clk_active <= clk_active;		
			case state is
				when S_IDLE =>			
					cs <= '1';
					if((int1 = '1' or int2 = '1' or go = '1') and rst = '0') then
						state <= S_TXRX;
						enable <= '1';
						cs <= '0';
						tx_buffer <= txData; 					
					end if;				
				when S_TXRX =>				
					enable <= '1';				
					if(last_clk_active = '1' and clk_active = '0') then  
						enable <= '0';
						cs <= '1';
						rxDataReady <= '1';
						state <= S_IDLE;					
					else 
						enable <= '1';
						cs <= '0';
						if(byte_flag = '1') then
							rxDataReady <= '1';
							tx_buffer <= txData;
						end if;				
					end if;						
				when others => null;				
			end case;			
		end if;	
	end process;
	cs_out <= cs;
	sclk_out <= sclk;
		
	process (clk, sclk, cs, rst)--, state)
	begin	
		if( rst = '1') then
			bit <= 7;
			mosi <= '1';	
		elsif(clk'event and clk = '1') then
		last_cs <= cs;
		last_sclk <= sclk;  
			if(cs = '0' and last_cs = '1' ) then			
				w_r <= not pha;								
				if(pha = '0') then
					mosi <= tx_buffer(bit); 
				end if;				
			elsif(cs = '0' and (last_sclk /= sclk)) then													
				if(w_r = '0') 	then				
					mosi <= tx_buffer(bit);					
				elsif (w_r = '1') then		
					rx_buffer <= rx_buffer(6 downto 0) & miso;
					bit <= bit - 1;			
					if(bit = 0) then			
						bit <= 7;
					end if;
				else 
					null;							
				end if;				
				w_r <= not w_r;								
			else 
				null;
			end if;			
			if(bit = 7) then
				rxData <= rx_buffer;
			end if;			
		end if;	
	end process;
end FSM_1P;


architecture FSM_2P of spi_master is
------------------------------------
-- State signals
------------------------------------
type STATE_TYPE is (S_IDLE, S_TXRX);
signal state, next_state : STATE_TYPE;
------------------------------------
-- Clock Div (spi clock) Signals
------------------------------------
signal sclk : std_logic;
signal enable : std_logic := '0';
signal polarity : std_logic;
signal clk_active : std_logic;
signal byte_flag : std_logic;

------------------------------------
-- SPI Data Signals
------------------------------------
signal rx_buffer	: std_logic_vector (7 downto 0) := (others => '1');
signal tx_buffer	: std_logic_vector (7 downto 0);
signal cs : std_logic := '1';
constant byte_w : natural := 8;
signal bit : integer range -1 to 8 := 7; 
signal w_r : std_logic := '0'; 
signal phase_Delay : std_logic := '0';
signal last_cs : std_logic := '1';
signal last_sclk : std_logic := '0';

begin
	U_CLOCK_DIV : entity work.clock_div
		generic map(
			clk_in_freq => 50000000,
			clk_out_freq => 5)
		port map(
			clk_in => clk,
			clk_out => sclk,
			rst	=> rst,
			enable => enable,
			bytes	=> bytes,
			polarity => polarity,
			clk_active => clk_active,
			byte_flag => byte_flag);

	process (clk, rst)
	begin	
		if(rst = '1') then
			state <= S_IDLE;
		elsif (clk'event and clk = '1') then
			state <= next_state;
		end if;
	end process;
		
	process(state, int1, int2, go, clk_active, byte_flag)
	begin
		rxDataReady <= '0'; 
		polarity <= pol;
		next_state <= state;
		enable <= '0';		
		case state is
			when S_IDLE =>				
				cs <= '1';
				if((int1 = '1' or int2 = '1' or go = '1') and rst = '0') then
					next_state <= S_TXRX;
					enable <= '1';
					cs <= '0';
					tx_buffer <= txData; 				
				end if;		
			when S_TXRX =>				
				enable <= '1';			
				if(clk_active = '0') then
					enable <= '0';
					cs <= '1';
					rxDataReady <= '1';
					next_state <= S_IDLE;				
				else 
					enable <= '1';
					cs <= '0';
					if(byte_flag = '1') then
						rxDataReady <= '1';
						tx_buffer <= txData;
					end if;				
				end if;					
			when others => null;			
		end case;	
	end process;
	
	cs_out <= cs;
	sclk_out <= sclk;
	
	process (clk, sclk, cs, rst)	
	begin	
		if( rst = '1') then
			bit <= 7;
			mosi <= '1';
		elsif(clk'event and clk = '1') then
		last_cs <= cs;
		last_sclk <= sclk; 
			if(cs = '0' and last_cs = '1' ) then			
				w_r <= not pha;								
				if(pha = '0') then
					mosi <= tx_buffer(bit); 
				end if;				
			elsif(cs = '0' and (last_sclk /= sclk)) then			
				if(w_r = '0') 	then				
					mosi <= tx_buffer(bit);					
				elsif (w_r = '1') then		
					rx_buffer <= rx_buffer(6 downto 0) & miso;
					bit <= bit - 1;			
					if(bit = 0) then			
						bit <= 7;
					end if;
				else 
					null;							
				end if;				
				w_r <= not w_r;								
			else 
				null;
			end if;
		end if;	
	end process;
	rxData <= rx_buffer;
end FSM_2P;