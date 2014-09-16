
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library axi_lite_slave_v1_00_a; --USER-- library name
use axi_lite_slave_v1_00_a.all; --USER-- use statement

entity vga_controller is
	generic (
		VGA_POS_WIDTH        : integer := 16
	);
  port
  (
    CLK       : in std_logic; -- clock
    RST	      : in std_logic; -- reset, active low
    HSYNC     : out std_logic;
	VSYNC     : out std_logic;
	X         : out std_logic_vector(VGA_POS_WIDTH-1 downto 0);
	Y         : out std_logic_vector(VGA_POS_WIDTH-1 downto 0);
	VGA_HSYNC : out std_logic;
	VGA_VSYNC : out std_logic
  );
end entity vga_controller;

architecture imp of vga_controller is --USER-- change entity name

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

signal x_reg : std_logic_vector(VGA_POS_WIDTH-1 downto 0);
signal y_reg : std_logic_vector(VGA_POS_WIDTH-1 downto 0);

------------------------------------------------------------------------------
begin
------------------------------------------------------------------------------

X <= x_reg;
Y <= y_reg;

process(CLK, RST)
begin
	if (RST = '0') then
		x_reg <= (others => '0');
		y_reg <= (others => '0');
	elsif rising_edge(CLK) then
	
		if (x_reg = H_PIXEL_END) then
			x_reg <= (others => '0');
			
			if (y_reg = V_PIXEL_END) then
				y_reg <= (others => '0');
			else
				y_reg <= y_reg + 1;
			end if;
		else
			x_reg <= x_reg + 1;
		end if;
		
	end if;
end process;

VGA_HSYNC <= '0' when (x_reg >= H_SYNC_START and x_reg < H_BACKPORCH_START) else '1';
VGA_VSYNC <= '0' when (y_reg >= V_SYNC_START and y_reg < V_BACKPORCH_START) else '1';

HSYNC <= '0' when (x_reg >= H_PIXEL_START and x_reg < H_PIXEL_END) else '1';
VSYNC <= '0' when (y_reg >= V_PIXEL_START and y_reg < V_PIXEL_END) else '1';

end architecture imp;