-- Décompteur de temps de jeu
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


use work.PrjPack.all;

entity GameTimer is port(
		-- inputs
		signal st_in_clk50M 	: in std_logic;
		signal st_in_enB 		: in std_logic;
		signal st_in_rstB 	: in std_logic;
		-- outputs
		signal st_out_TimeOut 			: out std_logic;
		signal stv4_out_TimerDizaines : out std_logic_vector(3 downto 0);
		signal stv4_out_TimerUnites 	: out std_logic_vector(3 downto 0)
		);
end GameTimer;

architecture arch_GameTimer of GameTimer is

signal int_cpt50M 	: integer range 0 to MAX_CPT50M;
signal int_cptTimer 	: integer range 0 to 59 := 59;

begin
	process(st_in_clk50M, st_in_rstB)
	begin
		if(st_in_clk50M'event and (st_in_clk50M = '1')) then
			if(st_in_rstB = '0') then
				int_cpt50M <= 0;
				int_cptTimer <= 59;
			else
				
				-- Compteur valide si enable
				if(st_in_enB = '0') then
					int_cpt50M <= int_cpt50M + 1;
				end if;
				
				-- lorsqu'une seconde s'est écoulée
				if(int_cpt50M >= MAX_CPT50M) then
					int_cpt50M <= 0;
					
					-- décrémentation cptTimer
					if((int_cptTimer > 0) and (st_in_enB = '0')) then
						int_cptTimer <= int_cptTimer - 1;
					end if;
				end if;
			end if;
		end if;
			
	
	end process;
	
	st_out_TimeOut <= '1' when (int_cptTimer = 0) else '0';
	
	-- parse de chaque chiffre indépendament
	stv4_out_TimerUnites 	<=  std_logic_vector	(to_unsigned(int_cptTimer mod 10,4));
	stv4_out_TimerDizaines 	<= std_logic_vector	(to_unsigned((int_cptTimer/10) mod 10,4));
	
end arch_GameTimer;