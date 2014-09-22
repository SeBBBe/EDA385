
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

use work.types.all;

entity line_controller is
	port
	(
		CLK        : in std_logic;
		RST        : in std_logic;
		
		YPLUSONE   : in vgapos_t;
	   YMINUSONE  : in vgapos_t;
		
		ENABLE     : in std_logic;
		
		PROGRAM    : in std_logic;
		
		INPUT      : in linereg_t;
		OUTPUT     : out linereg_t;
		
		LINE_OUT   : out std_logic;
		LINE_X     : out vgapos_t
	);
end line_controller;

architecture Behavioral of line_controller is

signal linereg_input : linereg_t;
signal linereg_output : linereg_t;

signal comp_input : linereg_t;
signal comp_output : linereg_t;

begin

	line_comp1 : entity work.line_comp_unit
	port map
	(
		YPLUSONE => YPLUSONE,
		YMINUSONE => YMINUSONE,
		INPUT => comp_input,
		OUTPUT => comp_output,
		LINE_OUT => LINE_OUT,
		LINE_X => LINE_X
	);
	
	line_reg1 : entity work.line_reg_unit
	port map
	(
		CLK => CLK,
	   RST => RST,
		
		ENABLE => ENABLE,
		
		INPUT => linereg_input,
		OUTPUT => linereg_output
	);
	
OUTPUT <= linereg_output;

process(PROGRAM, INPUT, comp_output, linereg_output)
begin
	linereg_input <= comp_output;
	comp_input <= linereg_output;
	
	if PROGRAM = '1' then
		linereg_input <= INPUT;
	end if;
end process;

end Behavioral;

