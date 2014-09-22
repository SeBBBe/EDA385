----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library axi_lite_slave_v1_00_a; --USER-- library names

package types is
	constant DISPLAY_WIDTH : integer := 1280; --16; --
	constant LINE_REG_UNITS : integer := 64; --2; --
	constant LINE_COMP_UNITS : integer := 8; --1; --
	constant LINES_PER_COMP_UNIT : integer := LINE_REG_UNITS / LINE_COMP_UNITS;
	constant VGAPOS_WIDTH : integer := 12;
	subtype vgapos_t is signed(VGAPOS_WIDTH-1 downto 0);
	type linereg_t is
		record
			enable : std_logic;
			x0 : vgapos_t;
			y0 : vgapos_t;
			x1 : vgapos_t;
			y1 : vgapos_t;
			sx : std_logic;
			err : vgapos_t;
			negdx : vgapos_t;
			dy : vgapos_t;
		end record;
	constant EMPTY_LINE_REG : linereg_t := ('0', (others => '0'), (others => '0'), (others => '0'), (others => '0'), '0', (others => '0'), (others => '0'), (others => '0'));
end package;
