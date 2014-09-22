
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_misc.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.types.all;

entity line_comp_unit is
  port
  (
	 YPLUSONE        : in vgapos_t;
	 YMINUSONE       : in vgapos_t;
	 INPUT           : in linereg_t;
	 OUTPUT          : out linereg_t;
	 LINE_OUT   	  : out std_logic;
	 LINE_X     	  : out vgapos_t
  );
end line_comp_unit;

architecture Behavioral of line_comp_unit is

begin

process(YPLUSONE, YMINUSONE, INPUT)
	variable err_tmp : vgapos_t;
	variable x0_tmp : vgapos_t;
begin
	OUTPUT <= INPUT;
	LINE_OUT <= '0';
	LINE_X <= (others => '0');
	
	if INPUT.enable = '1' then
		if INPUT.y0 = YPLUSONE then
			x0_tmp := INPUT.x0;
			err_tmp := INPUT.err;
			
			LINE_OUT <= '1';
			LINE_X <= INPUT.x0;
			
			if INPUT.err > INPUT.negdx then
				if INPUT.sx = '1' then
					x0_tmp := INPUT.x0 + 1;
				else
					x0_tmp := INPUT.x0 - 1;
				end if;
				err_tmp := err_tmp - INPUT.dy;
			end if;
			if INPUT.err < INPUT.dy then
				OUTPUT.y0 <= INPUT.y0 + 1;
				err_tmp := err_tmp - INPUT.negdx;
			end if;
			
			OUTPUT.x0 <= x0_tmp;
			OUTPUT.err <= err_tmp;
		end if;
		
		if INPUT.x0 = INPUT.x1 and INPUT.y0 = INPUT.y1 then
			OUTPUT.enable <= '0';
		end if;
		
		-- TODO: X end condition
	end if;
end process;

end Behavioral;
