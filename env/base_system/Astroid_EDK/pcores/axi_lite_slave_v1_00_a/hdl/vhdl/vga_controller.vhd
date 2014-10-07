
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library axi_lite_slave_v1_00_a; --USER-- library name
use axi_lite_slave_v1_00_a.all; --USER-- use statement

use work.types.all;

entity vga_controller is
  port
  (
    CLK       : in std_logic; -- clock
    RST	      : in std_logic; -- reset, active low
    HSYNC     : out std_logic;
	 VSYNC     : out std_logic;
	 NEWLINE   : out std_logic;
	 VGA_HSYNC : out std_logic;
	 VGA_VSYNC : out std_logic
  );
end entity vga_controller;

architecture imp of vga_controller is --USER-- change entity name

signal x_reg : vgapos_t;
signal x_next : vgapos_t;
signal y_reg : vgapos_t;
signal y_next : vgapos_t;

------------------------------------------------------------------------------
begin
------------------------------------------------------------------------------

process(CLK, RST)
begin
	if (RST = '0') then
		x_reg <= (others => '0');
		y_reg <= (others => '0');
	elsif rising_edge(CLK) then
		x_reg <= x_next;
		y_reg <= y_next;
	end if;
end process;

process(x_reg, y_reg)
begin
	x_next <= x_reg;
	y_next <= y_reg;
	NEWLINE <= '0';
	
	if (x_reg = H_PIXEL_END - 1) then
		x_next <= (others => '0');
		
		if (y_reg = V_PIXEL_END - 1) then
			y_next <= (others => '0');
		else
			y_next <= y_reg + 1;
			NEWLINE <= '1';
		end if;
	else
		x_next <= x_reg + 1;
	end if;
end process;

VGA_HSYNC <= '0' when (x_reg >= H_SYNC_START and x_reg < H_BACKPORCH_START) else '1';
VGA_VSYNC <= '0' when (y_reg >= V_SYNC_START and y_reg < V_BACKPORCH_START) else '1';

HSYNC <= '0' when (x_reg >= H_PIXEL_START and x_reg < H_PIXEL_END) else '1';
-- line controllers need to start one line before pixel output starts
VSYNC <= '0' when (y_reg >= V_PIXEL_START-1 and y_reg < V_PIXEL_END) else '1';

end architecture imp;
