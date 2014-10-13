----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library snd_controller; --USER-- library names

package types is
	constant FREQUENCY : integer := 100000000;
	constant SAMPLE_RATE : integer := 44100;
	constant PDM_CYCLES : integer := FREQUENCY / SAMPLE_RATE;
	
	subtype pcm_t is unsigned(15-1 downto 0);
	subtype waveform_t is std_logic_vector(1 downto 0);
	
	constant PCM_MAX : pcm_t := "111111111111111";
	constant PCM_MIN : pcm_t := "000000000000000";
	
	constant PWM_FACTOR : pcm_t := PCM_MAX / PDM_CYCLES;
	
	constant SQR_WAVE : waveform_t := "00";
	constant SAW_WAVE : waveform_t := "01";
	constant TRI_WAVE : waveform_t := "10";
	constant NSE_WAVE : waveform_t := "11";
	
	type command_t is
		record
			period : pcm_t;
			duration : pcm_t;
			waveform : waveform_t;
		end record;
	
	constant EMPTY_COMMAND : command_t := ((others => '0'), (others => '0'), (others => '0'));
end package;
