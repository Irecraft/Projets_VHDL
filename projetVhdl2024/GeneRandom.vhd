library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.numeric_std.ALL; 
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use work.PrjPack.all;

entity GeneRandom is port(
	-- Inputs
	signal  st_in_clk : in std_logic;
	
	-- Outputs
	signal int_out_randX : out integer range 0 to MAXX;
	signal int_out_randY : out integer range 0 to MAXY
);
end GeneRandom;

architecture arch_GeneRandom of GeneRandom is
signal stv26_compteur : std_logic_vector(25 downto 0);	-- Suffisamment pour contenir de nombreuses valeurs
begin
	process(st_in_clk)
	begin
		if(st_in_clk'event and (st_in_clk = '1')) then
			stv26_compteur <= stv26_compteur + 1;
		end if;
	end process;
	
	
	
end arch_GeneRandom;