
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

library axi_lite_slave_v1_00_a; --USER-- library name
use axi_lite_slave_v1_00_a.all; --USER-- use statement

use work.types.all;

entity vector_controller is
  port
  (
    CLK       : in std_logic; -- clock
    RST	     : in std_logic; -- reset, active low
	 
    HSYNC     : in std_logic;
	 VSYNC     : in std_logic;
	 X         : in vgapos_t;
	 Y         : in vgapos_t;
	 NEWLINE   : in std_logic;
	 
	 PROGRAM   : in std_logic;
	 ENABLE    : in std_logic;
	 INPUT     : in linereg_t;
	 
	 PIXEL_OUT : out std_logic
  );
end entity vector_controller;

architecture imp of vector_controller is --USER-- change entity name

type per_controller_stdlogic_t is array (0 to LINE_COMP_UNITS-1) of std_logic;
type per_controller_vgapos_t is array (0 to LINE_COMP_UNITS-1) of vgapos_t;
type per_controller_linereg_t is array (0 to LINE_COMP_UNITS-1) of linereg_t;

signal line_outputs : per_controller_linereg_t;

signal line_lineouts : per_controller_stdlogic_t;
signal line_linexs : per_controller_vgapos_t;

signal yplusone : vgapos_t;
signal yminusone : vgapos_t;

type pixelrow_t is array (0 to DISPLAY_WIDTH-1) of std_logic;

signal prev_pixels_reg : pixelrow_t;
signal prev_pixels_next : pixelrow_t;

signal pixels_reg : pixelrow_t;
signal pixels_next : pixelrow_t;

------------------------------------------------------------------------------
begin
------------------------------------------------------------------------------

yplusone <= Y + 1;
yminusone <= Y - 1;

line_controller0 : entity work.line_controller
	port map
	(
		CLK => CLK,
		RST => RST,
		
		YPLUSONE => yplusone,
	   YMINUSONE => yminusone,
		
		ENABLE => ENABLE,
		PROGRAM => PROGRAM,
		
		INPUT => INPUT,
		OUTPUT => line_outputs(0),
		
		LINE_OUT => line_lineouts(0),
		LINE_X => line_linexs(0)
	);

GEN_LINE_CONTROLLERS:
for I in 1 to LINE_COMP_UNITS-1 generate
	line_controllerX : entity work.line_controller
	port map
	(
		CLK => CLK,
		RST => RST,
		
		YPLUSONE => yplusone,
	   YMINUSONE => yminusone,
		
		ENABLE => ENABLE,
		PROGRAM => PROGRAM,
		
		INPUT => line_outputs(I - 1),
		OUTPUT => line_outputs(I),
		
		LINE_OUT => line_lineouts(I),
		LINE_X => line_linexs(I)
	);
end generate GEN_LINE_CONTROLLERS;

process(CLK, RST)
begin
	if (RST = '0') then
		prev_pixels_reg <= (others => '0');
		pixels_reg <= (others => '0');
	elsif rising_edge(CLK) then
		prev_pixels_reg <= prev_pixels_next;
		pixels_reg <= pixels_next;
	end if;
end process;

process(X, NEWLINE, prev_pixels_reg, pixels_reg, line_lineouts, line_linexs)
variable pixel_index : integer range 0 to DISPLAY_WIDTH-1;
begin
	pixels_next <= pixels_reg;
	prev_pixels_next <= prev_pixels_reg;
	
	PIXEL_OUT <= '0';
	
	if X >= 0 and X < DISPLAY_WIDTH then
		PIXEL_OUT <= prev_pixels_reg(0);
		
		for I in 0 to DISPLAY_WIDTH-2 loop
			prev_pixels_next(I) <= prev_pixels_reg(I + 1);
		end loop;
	end if;
	
	if NEWLINE = '1' then
		prev_pixels_next <= pixels_reg;
		pixels_next <= (others => '0');
	else
		for I in 0 to LINE_COMP_UNITS-1 loop
			if line_lineouts(I) = '1' then
				pixel_index := to_integer(line_linexs(I));
				pixels_next(pixel_index) <= '1';
			end if;
		end loop;
	end if;
end process;

end architecture imp;
