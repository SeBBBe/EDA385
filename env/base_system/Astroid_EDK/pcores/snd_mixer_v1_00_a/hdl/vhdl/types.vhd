----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library snd_mixer_v1_00_a; --USER-- library names

package types is
	subtype volume_t is unsigned(16-1 downto 0);
	
	subtype pcm_t is unsigned(12-1 downto 0);
	
	type mixcfg_t is
		record
			vol1 : volume_t;
			vol2 : volume_t;
		end record;
	
	constant DEFAULT_MIXCFG : mixcfg_t := ((others => '0'), (others => '0'));
end package;
