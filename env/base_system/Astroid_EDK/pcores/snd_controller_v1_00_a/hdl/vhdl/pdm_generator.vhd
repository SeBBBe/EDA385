----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:28:40 10/10/2014 
-- Design Name: 
-- Module Name:    pdm_generator - Behavioral 
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

entity pdm_generator is
	port (
		CLK     : in std_logic;
		RST     : in std_logic;
		PCM     : in pcm_t;
		TRIGGER : in std_logic;
		DONE    : out std_logic;
		OUTPUT  : out std_logic
	);
end pdm_generator;

architecture Behavioral of pdm_generator is

signal pw : pcm_t;

signal divider_d : pcm_t;
signal divider_clr : std_logic;
signal divider_ready : std_logic;

signal count_reg : pcm_t;
signal count_next : pcm_t;

begin

	divider1: entity work.divider
		port map(
			CLK => CLK,
			RST => RST,
			
			N => PCM,
			D => divider_d,
			CLR => divider_clr,
			
			Q => pw,
			READY => divider_ready
		);

divider_d <= PWM_FACTOR;

process(CLK, RST)
begin
	if rising_edge(CLK) then
		if RST = '0' then
			count_reg <= (others => '0');
		else
			count_reg <= count_next;
		end if;
	end if;
end process;

-- this is PWM, not PDM, so sue me
process(TRIGGER, PCM, count_reg)
begin
	count_next <= count_reg;
	DONE <= '0';
	divider_clr <= '0';
	OUTPUT <= '0';
	
	if count_reg = PDM_CYCLES then
		DONE <= '1';
	else
		if count_reg < pw then
			OUTPUT <= '1';
		end if;
		
		count_next <= count_reg + 1;
	end if;
	
	if TRIGGER = '1' then
		count_next <= (others => '0');
		divider_clr <= '1';
	end if;
end process;

end Behavioral;
