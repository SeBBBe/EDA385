
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.std_logic_unsigned.all;

library axi_lite_slave_v1_00_a; --USER-- library name
use axi_lite_slave_v1_00_a.all; --USER-- use statement

entity vector_controller is
	generic (
		VGA_POS_WIDTH        : integer := 16
    );
  port
  (
    CLK       : in std_logic; -- clock
    RST	      : in std_logic; -- reset, active low
    HSYNC     : in std_logic;
	VSYNC     : in std_logic;
	X         : in std_logic_vector(VGA_POS_WIDTH-1 downto 0);
	Y         : in std_logic_vector(VGA_POS_WIDTH-1 downto 0);
	OUTPUT    : out std_logic
  );
end entity vector_controller;

architecture imp of vector_controller is --USER-- change entity name

------------------------------------------------------------------------------
begin
------------------------------------------------------------------------------

OUTPUT <= '1' when (HSYNC = '0' and VSYNC = '0' and X = Y) else '0';

end architecture imp;
