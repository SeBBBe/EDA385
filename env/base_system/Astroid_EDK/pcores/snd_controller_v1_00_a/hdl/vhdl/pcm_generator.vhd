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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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

process(INPUT, TRIGGER, pdm_done, count_reg, period_reg, command_reg, pcm_reg, done_reg)
begin
	count_next <= count_reg;
	period_next <= period_reg;
	command_next <= command_reg;
	pcm_next <= pcm_reg;
	pdm_trigger <= '0';
	done_next <= done_reg;
	
	if pdm_done = '1' then
		period_next <= period_reg + 1;
		count_next <= count_reg + 1;
		
		if period_reg < command_reg.period / 2 then
			pcm_next <= PCM_MIN;
		else
			pcm_next <= PCM_MAX;
		end if;
		
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
	end if;
end process;

end Behavioral;