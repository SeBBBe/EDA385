----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library axi_lite_slave_v1_00_a; --USER-- library names

package types is
	constant LINES : integer := 16;
	constant VGAPOS_WIDTH : integer := 11;
	subtype vgapos_t is std_logic_vector(VGAPOS_WIDTH-1 downto 0);
	subtype signed_vgapos_t is signed(VGAPOS_WIDTH-1 downto 0);
	type vecmem_t is array (0 to (LINES * 4)-1) of vgapos_t;
end package;
