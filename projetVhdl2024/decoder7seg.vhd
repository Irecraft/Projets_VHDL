--decoder7seg
library ieee;
use ieee.std_logic_1164.all;

entity decoder7seg is
    port (
        stv4_int_data  : in  std_logic_vector(3 downto 0);
		  st_int_en : in std_logic;
        stv7_out_seg : out std_logic_vector(6 downto 0));
end decoder7seg;

architecture decoder7seg_arch of decoder7seg is
		signal stv7_out_buf : std_logic_vector(6 downto 0);
begin  
	process(stv4_int_data)
		begin
			case stv4_int_data is
				when "0000" =>  stv7_out_buf <= "1000000";
				when "0001" =>  stv7_out_buf <= "1111001";
				when "0010" =>  stv7_out_buf <= "0100100";
				when "0011" =>  stv7_out_buf <= "0110000";
				when "0100" =>  stv7_out_buf <= "0011001";
				when "0101" =>  stv7_out_buf <= "0010010";
				when "0110" =>  stv7_out_buf <= "0000010";
				when "0111" =>  stv7_out_buf <= "1111000";
				when "1000" =>  stv7_out_buf <= "0000000";
				when "1001" =>  stv7_out_buf <= "0011000";
				when "1010" =>  stv7_out_buf <= "0001000";
				when "1011" =>  stv7_out_buf <= "0000011";
				when "1100" =>  stv7_out_buf <= "1000110";
				when "1101" =>  stv7_out_buf <= "0100001";
				when "1110" =>  stv7_out_buf <= "0000110";
				when "1111" =>  stv7_out_buf <= "0001110";
				when others =>  stv7_out_buf <= "XXXXXXX";
			end case;
		end process;	
		stv7_out_seg <= stv7_out_buf when(st_int_en = '0') else "1111111";
end decoder7seg_arch;
