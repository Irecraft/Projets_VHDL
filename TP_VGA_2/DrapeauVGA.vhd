library IEEE;
use IEEE.std_logic_1164.all;

use work.drapeauPack.all;

entity DrapeauVGA is port(
	-- inputs
	signal st_in_clk50MHz : in STD_LOGIC;
	signal stv4_out_R : out STD_LOGIC_VECTOR(3 downto 0);
	signal stv4_out_G : out STD_LOGIC_VECTOR(3 downto 0);
	signal stv4_out_B : out STD_LOGIC_VECTOR(3 downto 0);
	
	-- outputs
	signal st_out_synchroLigne : out STD_LOGIC;
	signal st_out_synchroTrame : out STD_LOGIC);

end DrapeauVGA;

architecture arch_DrapeauVGA of DrapeauVGA is
signal st_posXpixel : integer;
signal st_posYpixel : integer;
signal st_retenue : STD_LOGIC;
signal st_R : STD_LOGIC;
signal st_G : STD_LOGIC;
signal st_B : STD_LOGIC;

begin
	CptX : CompteurX
		port map(
			st_in_clk => st_in_clk50MHz,
			st_out_finLigne => st_retenue,
			st_out_syncLigne => st_out_synchroLigne,
			st_out_posXpixel => st_posXpixel
		);
		
	CptY : CompteurY
		port map(
			st_in_clk => st_in_clk50MHz,
			st_in_en => st_retenue,
			st_out_syncTrame => st_out_synchroTrame,
			st_out_posYpixel => st_posYpixel
		);
	
	GenerateurRGB : GeneRGB
		port map(
			st_in_posXpixel => st_posXpixel,
			st_in_posYpixel => st_posYpixel,
			st_out_RComponent => st_R,
			st_out_GComponent => st_G,
			st_out_BComponent => st_B
		);
		
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

end arch_DrapeauVGA;