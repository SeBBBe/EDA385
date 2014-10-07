
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.types.all;

entity line_controller is
	port
	(
		CLK        : in std_logic;
		RST        : in std_logic;
		
		ENABLE     : in std_logic;
		
		INPUT      : in linereg_t;
		OUTPUT     : out linereg_t;
		
		LINE_COLOR : out color_t;
		LINE_OUT   : out std_logic;
		LINE_X     : out vgapos_t
	);
end line_controller;

architecture Behavioral of line_controller is

signal linereg_input : linereg_t;
signal linereg_output : linereg_t;

signal comp_input : linereg_t;
signal comp_output : linereg_t;

signal yplusone : vgapos_t;
signal vsync : std_logic;
signal reg_enable : std_logic;

begin

vga_counter1 : entity work.vga_counter
	port map (
		CLK => CLK,
		RST => RST,
		
		YPLUSONE => yplusone,
		VSYNC => vsync
	);

	line_comp1 : entity work.line_comp_unit
	port map
	(
	   YPLUSONE => yplusone,
		
		INPUT => comp_input,
		OUTPUT => comp_output,
		
		LINE_COLOR => LINE_COLOR,
		LINE_OUT => LINE_OUT,
		LINE_X => LINE_X
	);
	
	line_reg1 : entity work.line_reg_unit
	port map
	(
		CLK => CLK,
		
		ENABLE => reg_enable,
		
		INPUT => linereg_input,
		OUTPUT => linereg_output
	);
	
OUTPUT <= linereg_output;

process(INPUT, vsync, comp_output, linereg_output)
begin
	linereg_input <= comp_output;
	comp_input <= linereg_output;
	
	if vsync = '1' then
		linereg_input <= INPUT;
	end if;
end process;

process(ENABLE, vsync)
begin
	if vsync = '1' then
		reg_enable <= ENABLE;
	else
		reg_enable <= '1';
	end if;
end process;

end Behavioral;

