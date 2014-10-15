----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library snd_controller; --USER-- library names

package types is
	constant FREQUENCY : integer := 100000000;--
	constant SAMPLE_RATE : integer := 24415;
	constant PDM_CYCLES : integer := 4096;
	
	subtype pcm_t is unsigned(12-1 downto 0);
	subtype time_t is unsigned(15-1 downto 0);
	subtype waveform_t is std_logic_vector(1 downto 0);
	
	constant PCM_MAX : pcm_t := (others => '1');
	constant PCM_MIN : pcm_t := (others => '0');
	
	constant SQR_WAVE : waveform_t := "00";
	constant SAW_WAVE : waveform_t := "01";
	constant TRI_WAVE : waveform_t := "10";
	constant NSE_WAVE : waveform_t := "11";
	
	type command_t is
		record
			period : time_t;
			duration : time_t;
			waveform : waveform_t;
		end record;
	
	constant EMPTY_COMMAND : command_t := ((others => '0'), (others => '0'), (others => '0'));
end package;
