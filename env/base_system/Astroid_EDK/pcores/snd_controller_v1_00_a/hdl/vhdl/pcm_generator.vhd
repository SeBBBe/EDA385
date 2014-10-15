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
		
		EMPTY : in std_logic;
		RD : out std_logic;
		INPUT : in command_t;
		
		OUTPUT : out std_logic
	);
end pcm_generator;

architecture Behavioral of pcm_generator is

signal pcm_reg : pcm_t;
signal pcm_next : pcm_t;

signal period_reg : time_t;
signal period_next : time_t;

signal cyclecount_reg : pcm_t;
signal cyclecount_next : pcm_t;

signal samplecount_reg : time_t;
signal samplecount_next : time_t;

signal command_reg : command_t;
signal command_next : command_t;

begin

	pdm1: entity work.pdm_generator
		port map(
			CLK => CLK,
			RST => RST,
			
			PCM => pcm_reg,
			
			OUTPUT => OUTPUT
		);

process(CLK, RST)
begin
	if rising_edge(CLK) then
		if RST = '0' then
			pcm_reg <= (others => '0');
			period_reg <= (others => '0');
			cyclecount_reg <= (others => '0');
			samplecount_reg <= (others => '0');
			command_reg <= EMPTY_COMMAND;
		else
			pcm_reg <= pcm_next;
			period_reg <= period_next;
			cyclecount_reg <= cyclecount_next;
			samplecount_reg <= samplecount_next;
			command_reg <= command_next;
		end if;
	end if;
end process;

process(INPUT, EMPTY, cyclecount_reg, samplecount_reg, period_reg, command_reg, pcm_reg)
variable done : boolean;
begin
	cyclecount_next <= cyclecount_reg + 1;
	samplecount_next <= samplecount_reg;
	period_next <= period_reg;
	command_next <= command_reg;
	pcm_next <= pcm_reg;
	RD <= '0';
	
	if cyclecount_reg = PCM_MIN then
		if period_reg = command_reg.period - 1 then
			period_next <= (others => '0');
		else
			period_next <= period_reg + 1;
		end if;
		
		if samplecount_reg < command_reg.duration then
			samplecount_next <= samplecount_reg + 1;
			
			if command_reg.waveform = SQR_WAVE then
				if period_reg < command_reg.period / 2 then
					pcm_next <= PCM_MIN;
				else
					pcm_next <= PCM_MAX;
				end if;
			elsif command_reg.waveform = SAW_WAVE then
				pcm_next <= pcm_reg + command_reg.period(12-1 downto 0);
			elsif command_reg.waveform = TRI_WAVE then
				pcm_next <= pcm_reg + command_reg.period(12-1 downto 0);
			else
				pcm_next <= (pcm_reg rol 4) + command_reg.period(12-1 downto 0);
			end if;
		else
			pcm_next <= PCM_MIN;
		end if;
	end if;

	if samplecount_reg >= command_reg.duration and EMPTY = '0' then
		RD <= '1';
		command_next <= INPUT;
		samplecount_next <= (others => '0');
		period_next <= (others => '0');
	end if;
end process;

end Behavioral;
