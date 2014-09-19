
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.std_logic_unsigned.all;

library axi_lite_slave_v1_00_a; --USER-- library name
use axi_lite_slave_v1_00_a.all; --USER-- use statement

use work.types.all;

entity vector_controller is
  port
  (
    CLK       : in std_logic; -- clock
    RST	     : in std_logic; -- reset, active low
    HSYNC     : in std_logic;
	 VSYNC     : in std_logic;
	 X         : in vgapos_t;
	 Y         : in vgapos_t;
	 VECMEM    : in vecmem_t;
	 OUTPUT    : out std_logic
  );
end entity vector_controller;

architecture imp of vector_controller is --USER-- change entity name

component line_controller is
  port
  (
    CLK       : in std_logic; -- clock
    RST	     : in std_logic; -- reset, active low
	 X         : in vgapos_t;
	 Y         : in vgapos_t;
	 X0        : in vgapos_t;
	 X1        : in vgapos_t;
	 Y0        : in vgapos_t;
	 Y1        : in vgapos_t;
	 PROGRAM   : in std_logic;
	 ENABLE    : out std_logic;
	 OUTPUT    : out std_logic
  );
end component line_controller;

signal vsync_reg : std_logic;
signal vsync_next : std_logic;

signal program_master : std_logic;

type output_array_t is array (0 to LINES-1) of std_logic;

signal outputs : output_array_t;

------------------------------------------------------------------------------
begin
------------------------------------------------------------------------------

process(CLK, RST)
begin
	if (RST = '0') then
		vsync_reg <= '0';
	elsif rising_edge(CLK) then
		vsync_reg <= vsync_next;
	end if;
end process;

process(VSYNC, vsync_reg)
begin
	program_master <= '0';
	vsync_next <= VSYNC;
	
	if VSYNC = '0' and (not (vsync_reg = VSYNC)) then
		program_master <= '1';
	end if;
end process;

GEN_LINE:
for I in 0 to LINES-1 generate
	lineX : line_controller
	port map
	(
		CLK => CLK,
		RST => RST,
		X => X,
		Y => Y,
		X0 => VECMEM(I * 4),
		Y0 => VECMEM(I * 4 + 1),
		X1 => VECMEM(I * 4 + 2),
		Y1 => VECMEM(I * 4 + 3),
		PROGRAM => program_master,
		OUTPUT => outputs(I)
	);
end generate GEN_LINE;

process(outputs)
variable final_output : std_logic := '0';
begin
	for I in 0 to LINES-1 loop
		final_output := outputs(I) or final_output;
	end loop;
	
	OUTPUT <= final_output;
end process;

end architecture imp;
