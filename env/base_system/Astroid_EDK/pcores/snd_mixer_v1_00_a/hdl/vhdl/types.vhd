----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library snd_mixer_v1_00_a; --USER-- library names

package types is
	subtype volume_t is integer range 0 to 255;
	
	type mixcfg_t is
		record
			vol1 : volume_t;
			vol2 : volume_t;
		end record;
	
	constant EMPTY_MIXCFG : mixcfg_t := (0, 0);
end package;
