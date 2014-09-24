
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

signal bram_pixel_outs : per_controller_stdlogic_t;

signal xplusone : vgapos_t;
signal yplusone : vgapos_t;
signal yminusone : vgapos_t;

------------------------------------------------------------------------------
begin
------------------------------------------------------------------------------

xplusone <= X + 1;
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

GEN_PIXELROW_BRAM:
for I in 0 to LINE_COMP_UNITS-1 generate
	pixelrow_bramX : entity work.pixelrow_bram
	port map
	(
		CLK => CLK,
		RST => RST,
		
		NEWLINE => NEWLINE,
		
		XPLUSONE => xplusone,
		PIXEL_OUT => bram_pixel_outs(I),
		
		WR_X => line_linexs(I),
		WR_PIXEL => line_lineouts(I)
	);
end generate GEN_PIXELROW_BRAM;

process(bram_pixel_outs)
begin
	PIXEL_OUT <= '0';
	
	for I in 0 to LINE_COMP_UNITS-1 loop
		if bram_pixel_outs(I) = '1' then
			PIXEL_OUT <= '1';
		end if;
	end loop;
end process;

end architecture imp;
