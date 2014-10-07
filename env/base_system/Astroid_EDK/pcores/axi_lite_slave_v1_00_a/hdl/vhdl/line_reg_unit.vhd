
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_misc.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.types.all;

entity line_reg_unit is
  port
  (
	 CLK             : in std_logic;
	 
	 ENABLE          : in std_logic;
	 
    INPUT           : in linereg_t;
	 OUTPUT          : out linereg_t
  );
end line_reg_unit;

architecture Behavioral of line_reg_unit is

type linemem_t is array (0 to LINES_PER_COMP_UNIT-1) of linereg_t;

signal line_reg : linemem_t;

begin

OUTPUT <= line_reg(LINES_PER_COMP_UNIT-1);

process(CLK)
begin
	if rising_edge(CLK) then
		if ENABLE = '1' then
			for I in 0 to LINES_PER_COMP_UNIT-2 loop
				line_reg(I+1) <= line_reg(I);
			end loop;
			
			line_reg(0) <= INPUT;
		end if;
	end if;
end process;

end Behavioral;
