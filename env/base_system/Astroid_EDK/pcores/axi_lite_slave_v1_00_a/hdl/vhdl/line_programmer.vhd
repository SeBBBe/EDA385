----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:44:37 09/19/2014 
-- Design Name: 
-- Module Name:    line_programmer - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_misc.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.types.all;

entity line_programmer is
	port
  (
	 CLK       : in std_logic;
	 RST       : in std_logic;
	 
	 ENABLE    : in std_logic;
	 
	 INPUT     : in linereg_t;
	 OUTPUT    : out linereg_t;
	 
	 DONE      : out std_logic
  );
end line_programmer;

architecture Behavioral of line_programmer is

type state_t is (CALC_DX, CALC_DY, CALC_ERR, CALC_ERR2, CALC_DONE);

signal state_reg : state_t;
signal state_next : state_t;

signal target_reg : linereg_t;
signal target_next : linereg_t;

signal done_reg : std_logic;
signal done_next : std_logic;

begin

OUTPUT <= target_reg;
DONE <= done_reg;

process(CLK,RST)
begin
	if RST = '0' then
		state_reg <= CALC_DX;
		target_reg <= EMPTY_LINE_REG;
		done_reg <= '0';
	elsif rising_edge(CLK) then
		state_reg <= state_next;
		target_reg <= target_next;
		done_reg <= done_next;
	end if;
end process;

process(INPUT, ENABLE, state_reg, target_reg)
begin
	target_next <= target_reg;
	state_next <= state_reg;
	done_next <= '0';
	
	if ENABLE = '1' then
		case state_reg is
			when CALC_DX =>
				target_next <= INPUT;
				
				if INPUT.x1 > INPUT.x0 then
					target_next.sx <= '1';
					target_next.negdx <= INPUT.x0 - INPUT.x1;
				else
					target_next.sx <= '0';
					target_next.negdx <= INPUT.x1 - INPUT.x0;
				end if;
				
				state_next <= CALC_DY;
			when CALC_DY =>
				if INPUT.y1 > INPUT.y0 then
					target_next.dy <= target_reg.y1 - target_reg.y0;
				else
					target_next.dy <= target_reg.y0 - target_reg.y1;
				end if;
				state_next <= CALC_ERR;
			when CALC_ERR =>
				if -target_reg.negdx > target_reg.dy then
					-- err = dx / 2 after CALC_ERR2
					target_next.err <= target_reg.negdx / 2;
				else
					-- err = -dy / 2 after CALC_ERR2
					target_next.err <= target_reg.dy / 2;
				end if;
				state_next <= CALC_ERR2;
			when CALC_ERR2 =>
				target_next.err <= -target_reg.err;
				target_next.enable <= '1';
				state_next <= CALC_DONE;
				done_next <= '1';
			when CALC_DONE =>
				state_next <= CALC_DX;
		end case;
	end if;
end process;

end Behavioral;

