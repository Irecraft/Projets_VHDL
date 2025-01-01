library IEEE;
use IEEE.std_logic_1164.all;

use work.drapeauPack.all;

entity CalcPosCarre is port(
		-- inputs
		signal st_in_clk : in std_logic;
		signal st_in_syncImage : in std_logic;
		-- outputs
		signal int_out_XCarre : out integer;
		signal int_out_YCarre : out integer;
end CompteurX;

architecture arch_CalcPosCarre of CalcPosCarre is
signal int_cptX : integer range 0 to XABCD;

begin
	process(st_in_clk)
	begin
		if(st_in_clk'event and (st_in_clk = '1')) then
		
		--continuer