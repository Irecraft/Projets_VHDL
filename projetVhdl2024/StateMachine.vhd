--	Module de gestion du graphe d'état
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.PrjPack.all;

entity StateMachine is port(
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
end StateMachine;

architecture arch_StateMachine of StateMachine is
	type TState is ( READY, GAME, SCORE, CHANGE_AIM, GAME_END );
	signal state : TState;
	signal intScoreCounter : integer := 0;
	
begin

	process(st_in_clk)
	begin
		if(st_in_clk'event and st_in_clk='1') then
		
			-- Machine d'état : Conditions de passage dans les différents états
		
			if(st_in_ResetB = '0') then
				intScoreCounter <= 0;
				state <= READY;
			else
				case state is
				
					when READY => 
						if(st_in_StartB = '0') then
							state <= CHANGE_AIM;
						end if;
						
					when GAME =>
						if(st_in_timeOut = '1') then
							state <= GAME_END;
						elsif (st_in_CollisionDetect = '1') then
							state <= SCORE;
						end if;
						
					when SCORE =>
						intScoreCounter <= intScoreCounter+1;
						state <= CHANGE_AIM;
						
					when CHANGE_AIM =>
						if(st_in_CollisionDetect = '0') then
							state <= GAME;
						end if;
						
					when GAME_END =>
						-- rien, attente du reset principal
			
				end case;
				
			end if;
		
		end if;
	end process;
	
	-- Conditions pour la gestion de l'activation des différents modules du projet
	
	st_out_PosJoueurEnB 	<= '0' when((state = GAME		) or (state = SCORE		) or (state = CHANGE_AIM))
		else '1';
	
	st_out_PosJoueurRstB <= '0' when((state = READY		) or (state = GAME_END	))
		else '1';
	
	st_out_PosCibleEnB 	<= '0' when(state = CHANGE_AIM)
		else '1';
	
	st_out_PosCibleRstB 	<= '0' when((state = READY		) or (state = GAME_END	))
		else '1';
	
	st_out_TimerEnB 		<= '0' when((state = GAME		) or (state = SCORE		) or (state = CHANGE_AIM))
		else '1';
	
	st_out_TimerRstB 		<= '0' when(state = READY		)
		else '1';
	
	-- Affectation du score obtenu
	stv4_out_ScoreUnites <=  std_logic_vector	(to_unsigned(intScoreCounter mod 10,4));
	stv4_out_ScoreDizaines <= std_logic_vector(to_unsigned((intScoreCounter/10) mod 10,4));

end arch_StateMachine;