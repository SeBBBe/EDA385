
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library snd_controller_v1_00_a; --USER-- library name
use snd_controller_v1_00_a.all; --USER-- use statement

use work.types.all;

entity command_stack is
	port( 
		CLK : in std_logic;
		RST : in std_logic;
		RD : in std_logic;
		WR : in std_logic;
		OUTPUT : out command_t;
		INPUT : in command_t;
		EMPTY : out std_logic;
		FULL : out std_logic
	);
end command_stack;

architecture Behavioral of command_stack is

type memory_type is array (0 to 15) of command_t;
signal memory : memory_type;   --memory for queue.
signal readptr, writeptr : std_logic_vector(3 downto 0);  --read and write pointers.

begin

OUTPUT <= memory(conv_integer(readptr));

process(CLK, RST)
variable rdptr : std_logic_vector(3 downto 0);
variable wrptr : std_logic_vector(3 downto 0);
begin
	if rising_edge(CLK) then
		if RST = '0' then
			readptr <= "0000";
			writeptr <= "0000";
			memory <= (others => EMPTY_COMMAND);
		else
			rdptr := readptr;
			wrptr := writeptr;
			
			if(RD = '1') then
				rdptr := rdptr + '1';
			end if;
			
			if(WR = '1') then
				memory(conv_integer(writeptr)) <= INPUT;
				wrptr := wrptr + '1';
			end if;
			
			if(wrptr = rdptr - 1) then
				FULL <= '1';
			else
				FULL <= '0';
			end if;
			
			if(wrptr = rdptr) then
				EMPTY <= '1';
			else
				EMPTY <= '0';
			end if;
			
			readptr <= rdptr;
			writeptr <= wrptr;
		end if;
	end if;
end process;

end Behavioral;
