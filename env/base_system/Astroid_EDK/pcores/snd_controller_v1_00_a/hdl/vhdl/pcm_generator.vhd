----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:11:06 10/10/2014 
-- Design Name: 
-- Module Name:    pcm_generator - Behavioral 
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

entity pcm_generator is
	port (
		CLK : in std_logic;
		RST : in std_logic;
		
		INPUT : in command_t;
		TRIGGER : in std_logic;
		
		DONE : out std_logic;
		OUTPUT : out std_logic
	);
end pcm_generator;

architecture Behavioral of pcm_generator is

signal pcm_reg : pcm_t;
signal pcm_next : pcm_t;

signal period_reg : pcm_t;
signal period_next : pcm_t;

signal count_reg : pcm_t;
signal count_next : pcm_t;

signal command_reg : command_t;
signal command_next : command_t;

signal done_reg : std_logic;
signal done_next : std_logic;

signal pdm_trigger : std_logic;
signal pdm_done : std_logic;

signal divider_n : pcm_t;
signal divider_clr : std_logic;

signal divider_ready : std_logic;

signal saw_constant : pcm_t;

begin

	pdm1: entity work.pdm_generator
		port map(
			CLK => CLK,
			RST => RST,
			
			PCM => pcm_reg,
			TRIGGER => pdm_trigger,
			DONE => pdm_done,
			
			OUTPUT => OUTPUT
		);
	
	divider1: entity work.divider
		port map(
			CLK => CLK,
			RST => RST,
			
			N => divider_n,
			D => command_reg.period,
			CLR => divider_clr,
			
			Q => saw_constant,
			READY => divider_ready
		);

divider_n <= PCM_MAX;

DONE <= done_reg;

process(CLK, RST)
begin
	if rising_edge(CLK) then
		if RST = '0' then
			pcm_reg <= (others => '0');
			period_reg <= (others => '0');
			count_reg <= (others => '0');
			command_reg <= EMPTY_COMMAND;
			done_reg <= '1';
		else
			pcm_reg <= pcm_next;
			period_reg <= period_next;
			count_reg <= count_next;
			command_reg <= command_next;
			done_reg <= done_next;
		end if;
	end if;
end process;

process(INPUT, TRIGGER, pdm_done, count_reg, period_reg, command_reg, pcm_reg, done_reg, saw_constant)
begin
	count_next <= count_reg;
	period_next <= period_reg;
	command_next <= command_reg;
	pcm_next <= pcm_reg;
	pdm_trigger <= '0';
	done_next <= done_reg;
	divider_clr <= '0';
	
	if pdm_done = '1' then
		period_next <= period_reg + 1;
		count_next <= count_reg + 1;
		
		case command_reg.waveform is
			-- square wave, MIN half period then MAX
			when SQR_WAVE =>
				if period_reg < command_reg.period / 2 then
					pcm_next <= PCM_MIN;
				else
					pcm_next <= PCM_MAX;
				end if;
			
			-- sawtooth wave, increase up to MAX over period
			when SAW_WAVE =>
				pcm_next <= pcm_reg + saw_constant;
			
			-- triange wave, increase up to MAX over half period then decrease to MIN
			when TRI_WAVE =>
				if period_reg < command_reg.period / 2 then
					if pcm_reg + (saw_constant sll 1) > pcm_reg then -- overflow guard
						pcm_next <= pcm_reg + (saw_constant sll 1);
					end if;
				else
					if pcm_reg - (saw_constant sll 1) < pcm_reg then -- underflow guard
						pcm_next <= pcm_reg - (saw_constant sll 1);
					end if;
				end if;
			
			-- noise, random numbers seeded from period
			when NSE_WAVE =>
				pcm_next <= pcm_reg xor (pcm_reg rol 4) + command_reg.period;
			
			when others =>
				pcm_next <= PCM_MIN;
		end case;
		
		pdm_trigger <= '1';
		
		if period_reg = command_reg.period then
			period_next <= (others => '0');
		end if;
		
		if count_reg = command_reg.duration then
			count_next <= (others => '0');
			pcm_next <= (others => '0');
			done_next <= '1';
			command_next <= EMPTY_COMMAND;
			pdm_trigger <= '0';
		end if;
	end if;

	if TRIGGER = '1' then
		count_next <= (others => '0');
		period_next <= (others => '0');
		command_next <= INPUT;
		pcm_next <= (others => '0');
		pdm_trigger <= '1';
		done_next <= '0';
		divider_clr <= '1';
	end if;
end process;

end Behavioral;
