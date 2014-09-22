
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
	 RST             : in std_logic;
	 
	 ENABLE          : in std_logic;
	 
    INPUT           : in linereg_t;
	 OUTPUT          : out linereg_t
  );
end line_reg_unit;

architecture Behavioral of line_reg_unit is

type linemem_t is array (0 to LINES_PER_COMP_UNIT-1) of linereg_t;
type per_line_vgapos_t is array (0 to LINES_PER_COMP_UNIT-1) of vgapos_t;

signal line_reg : linemem_t;
signal line_next : linemem_t;

begin

OUTPUT <= line_reg(LINES_PER_COMP_UNIT-1);

process(CLK, RST)
begin
	if (RST = '0') then
		line_reg <= (others => EMPTY_LINE_REG);
	elsif rising_edge(CLK) then
		line_reg <= line_next;
	end if;
end process;

process(ENABLE, INPUT, line_reg)
begin
	line_next <= line_reg;
	
	if ENABLE = '1' then
		line_next(0) <= INPUT;
		for I in 1 to LINES_PER_COMP_UNIT-1 loop
			line_next(I) <= line_reg(I-1);
		end loop;
	end if;
end process;

end Behavioral;
