
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
	 
	 NEWLINE   : in std_logic;
	 
	 ENABLE    : in std_logic;
	 INPUT     : in linereg_t;
	 
	 PIXEL_OUT : out color_t
  );
end entity vector_controller;

architecture imp of vector_controller is --USER-- change entity name

type per_controller_stdlogic_t is array (0 to LINE_COMP_UNITS-1) of std_logic;
type per_controller_vgapos_t is array (0 to LINE_COMP_UNITS-1) of vgapos_t;
type per_controller_color_t is array (0 to LINE_COMP_UNITS-1) of color_t;
type per_controller_linereg_t is array (0 to LINE_COMP_UNITS-1) of linereg_t;

type per_bram_bramiface_in_t is array (0 to (LINE_COMP_UNITS*2)-1) of bramiface_in_t;
type per_bram_bramiface_out_t is array (0 to (LINE_COMP_UNITS*2)-1) of bramiface_out_t;

signal line_outputs : per_controller_linereg_t;

signal line_linecolors : per_controller_color_t;
signal line_lineouts : per_controller_stdlogic_t;
signal line_linexs : per_controller_vgapos_t;

signal bram_ins : per_bram_bramiface_in_t;
signal bram_outs : per_bram_bramiface_out_t;

signal bram_pixel_outs_reg : per_controller_color_t;
signal bram_pixel_outs_next : per_controller_color_t;

------------------------------------------------------------------------------
begin
------------------------------------------------------------------------------

line_controller0 : entity work.line_controller
	port map
	(
		CLK => CLK,
		RST => RST,
		
		ENABLE => ENABLE,
		
		INPUT => INPUT,
		OUTPUT => line_outputs(0),
		
		LINE_COLOR => line_linecolors(0),
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
		
		ENABLE => ENABLE,
		
		INPUT => line_outputs(I - 1),
		OUTPUT => line_outputs(I),
		
		LINE_COLOR => line_linecolors(I),
		LINE_OUT => line_lineouts(I),
		LINE_X => line_linexs(I)
	);
end generate GEN_LINE_CONTROLLERS;

GEN_PIXELROW_BRAM:
for I in 0 to LINE_COMP_UNITS-1 generate
	bramX : entity work.bram
	port map
	(
		CLK => CLK,
		RST => RST,

		PORTA_IN => bram_ins(I*2),
		PORTB_IN => bram_ins(I*2+1),
		PORTA_OUT => bram_outs(I*2),
		PORTB_OUT => bram_outs(I*2+1)
	);

	pixelrow_bramX : entity work.pixelrow_bram
	port map
	(
		CLK => CLK,
		RST => RST,
		
		NEWLINE => NEWLINE,
		
		PIXEL_OUT => bram_pixel_outs_next(I),
		
		WR_X => line_linexs(I),
		WR_EN => line_lineouts(I),
		WR_PIXEL => line_linecolors(I),
		
		BRAM_EVEN_IN => bram_outs(I),
		BRAM_ODD_IN => bram_outs(I+LINE_COMP_UNITS),
		BRAM_EVEN_OUT => bram_ins(I),
		BRAM_ODD_OUT => bram_ins(I+LINE_COMP_UNITS)
	);
end generate GEN_PIXELROW_BRAM;

process(CLK, RST)
begin
	if rising_edge(CLK) then
		if RST = '0' then
			bram_pixel_outs_reg <= (others => (others => '0'));
		else
			bram_pixel_outs_reg <= bram_pixel_outs_next;
		end if;
	end if;
end process;

process(bram_pixel_outs_reg)
variable tmp_pixel_out : color_t;
begin
	tmp_pixel_out := (others => '0');
	
	for I in 0 to LINE_COMP_UNITS-1 loop
		tmp_pixel_out := bram_pixel_outs_reg(I) or tmp_pixel_out;
	end loop;
	
	PIXEL_OUT <= tmp_pixel_out;
end process;

end architecture imp;
