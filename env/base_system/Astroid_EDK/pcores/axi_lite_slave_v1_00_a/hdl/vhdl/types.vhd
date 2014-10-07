----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library axi_lite_slave_v1_00_a; --USER-- library names

package types is
	constant LINE_REG_UNITS : integer := 192; --2; --
	constant LINE_COMP_UNITS : integer := 6; --2; --
	constant LINES_PER_COMP_UNIT : integer := LINE_REG_UNITS / LINE_COMP_UNITS;
	constant VGAPOS_WIDTH : integer := 13;
	subtype vgapos_t is signed(VGAPOS_WIDTH-1 downto 0);
	subtype color_t is unsigned(7 downto 0);
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
			color : color_t;
		end record;
	type bramiface_in_t is
		record
			addr : vgapos_t;
			wdata : color_t;
			we : std_logic;
		end record;
	type bramiface_out_t is
		record
			rdata : color_t;
		end record;
	constant EMPTY_LINE_REG : linereg_t := ('0', (others => '0'), (others => '0'), (others => '0'), (others => '0'), '0', (others => '0'), (others => '0'), (others => '0'), (others => '0'));
	
	-- SIM
	-- Horizontal timing constants
	--constant H_FRONTPORCH:   integer := 0;
	--constant H_SYNC:         integer := 1;
	--constant H_BACKPORCH:    integer := 0;
	--constant H_PIXEL:        integer := 16;
	--constant H_PERIOD:       integer := 17;
	-- Vertical timing constants
	--constant V_FRONTPORCH:   integer := 0;
	--constant V_SYNC:         integer := 2;
	--constant V_BACKPORCH:    integer := 0;
	--constant V_PIXEL:        integer := 16;
	--constant V_PERIOD:       integer := 18;
	
	-- 1280x960
	-- Horizontal timing constants
	constant H_FRONTPORCH:   integer := 80;
	constant H_SYNC:         integer := 136;
	constant H_BACKPORCH:    integer := 216;
	constant H_PIXEL:        integer := 1280;
	constant H_PERIOD:       integer := 1712;
	-- Vertical timing constants
	constant V_FRONTPORCH:   integer := 1;
	constant V_SYNC:         integer := 3;
	constant V_BACKPORCH:    integer := 30;
	constant V_PIXEL:        integer := 960;
	constant V_PERIOD:       integer := 994;
	
	-- 1920x1080
	-- Horizontal timing constants
	--constant H_FRONTPORCH:   integer := 32;
	--constant H_SYNC:         integer := 696;
	--constant H_BACKPORCH:    integer := 32;
	--constant H_PIXEL:        integer := 1920;
	--constant H_PERIOD:       integer := 2680;
	-- Vertical timing constants
	--constant V_FRONTPORCH:   integer := 22;
	--constant V_SYNC:         integer := 11;
	--constant V_BACKPORCH:    integer := 22;
	--constant V_PIXEL:        integer := 1080;
	--constant V_PERIOD:       integer := 1135;
	
	-- Horizontal timing positions
	constant H_FRONTPORCH_START:   integer := 0;                                   --   0
	constant H_SYNC_START:         integer := H_FRONTPORCH_START + H_FRONTPORCH;   --  80
	constant H_BACKPORCH_START:    integer := H_SYNC_START + H_SYNC;               -- 
	constant H_PIXEL_START:        integer := H_BACKPORCH_START + H_BACKPORCH;     -- 
	constant H_PIXEL_END:          integer := H_PIXEL_START + H_PIXEL;             -- 
	-- Vertical timing positions
	constant V_FRONTPORCH_START:   integer := 0;                                     --   0
	constant V_SYNC_START:         integer := V_FRONTPORCH_START + V_FRONTPORCH;     --   1
	constant V_BACKPORCH_START:    integer := V_SYNC_START + V_SYNC;                 -- 
	constant V_PIXEL_START:        integer := V_BACKPORCH_START + V_BACKPORCH;       -- 
	constant V_PIXEL_END:          integer := V_PIXEL_START + V_PIXEL;               -- 
end package;
