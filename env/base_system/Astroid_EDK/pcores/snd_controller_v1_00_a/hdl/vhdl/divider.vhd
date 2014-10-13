----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:41:49 10/13/2014 
-- Design Name: 
-- Module Name:    divider - Behavioral 
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
use ieee.numeric_std.all;

library snd_controller_v1_00_a; --USER-- library name
use snd_controller_v1_00_a.all; --USER-- use statement

use work.types.all;

entity divider is
	port( 
		CLK   : in std_logic; 
		RST   : in std_logic; 
		
		N     : in pcm_t; 
		D     : in pcm_t; 
		CLR   : in std_logic;
		
		Q     : out pcm_t; 
		READY : out std_logic
	); 
end divider;

architecture Behavioral of divider is

signal r_reg, r_next : pcm_t;
signal q_reg, q_next : pcm_t;
signal i_reg, i_next : integer range 0 to 15;
signal ready_reg, ready_next : std_logic;

begin

Q <= q_reg;
READY <= ready_reg;

process(CLK, RST)
begin
	if rising_edge(CLK) then
		if RST = '0' then
			r_reg <= (others => '0');
			q_reg <= (others => '0');
			i_reg <= 0;
			ready_reg <= '0';
		else
			r_reg <= r_next;
			q_reg <= q_next;
			i_reg <= i_next;
			ready_reg <= ready_next;
		end if;
	end if;
end process;

process(N, D, CLR, r_reg, q_reg, i_reg, ready_reg)
variable r_tmp : pcm_t;
begin
	q_next <= q_reg;
	r_next <= r_reg;
	i_next <= i_reg;
	ready_next <= ready_reg;

	if ready_reg = '0' then
		r_tmp := r_reg sll 1;
		r_tmp(0) := N(i_reg);
		
		if r_tmp >= D then
			r_tmp := r_tmp - D;
			q_next(i_reg) <= '1';
		end if;
		
		r_next <= r_tmp;
		
		i_next <= i_reg - 1;
		
		if i_reg = 0 then
			ready_next <= '1';
		end if;
	end if;

	if CLR = '1' then
		r_next <= (others => '0');
		q_next <= (others => '0');
		i_next <= 14;
		ready_next <= '0';
	end if;
end process;

end Behavioral;

