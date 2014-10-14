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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

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

signal pw_reg : pcm_t;
signal pw_next : pcm_t;

signal count_reg : pcm_t;
signal count_next : pcm_t;

begin

process(CLK, RST)
begin
	if rising_edge(CLK) then
		if RST = '0' then
			pw_reg <= (others => '0');
			count_reg <= (others => '0');
		else
			pw_reg <= pw_next;
			count_reg <= count_next;
		end if;
	end if;
end process;

process(TRIGGER, PCM, count_reg, pw_reg)
begin
	count_next <= count_reg + 1;
	pw_next <= pw_reg;
	DONE <= '0';
	
	if count_reg < pw_reg then
		OUTPUT <= '1';
	else
		OUTPUT <= '0';
	end if;
	
	if count_reg = PDM_CYCLES then
		DONE <= '1';
		pw_next <= (others => '0');
	end if;
	
	if TRIGGER = '1' then
		count_next <= (others => '0');
		pw_next <= PCM / PWM_FACTOR;
	end if;
end process;

end Behavioral;