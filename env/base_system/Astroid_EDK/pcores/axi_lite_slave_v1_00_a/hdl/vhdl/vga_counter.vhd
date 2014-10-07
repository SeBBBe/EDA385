
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library axi_lite_slave_v1_00_a; --USER-- library name
use axi_lite_slave_v1_00_a.all; --USER-- use statement

use work.types.all;

entity vga_counter is
  port
  (
    CLK       : in std_logic; -- clock
    RST	     : in std_logic; -- reset, active low
	 XPLUSONE  : out vgapos_t;
	 YPLUSONE  : out vgapos_t;
	 VSYNC     : out std_logic
  );
end entity vga_counter;

architecture imp of vga_counter is --USER-- change entity name

signal xplusone_reg : vgapos_t;
signal xplusone_next : vgapos_t;
signal yplusone_reg : vgapos_t;
signal yplusone_next : vgapos_t;
signal vsync_reg : std_logic;
signal vsync_next : std_logic;

------------------------------------------------------------------------------
begin
------------------------------------------------------------------------------

XPLUSONE <= xplusone_reg;
YPLUSONE <= yplusone_reg;

VSYNC <= vsync_reg;

process(CLK, RST)
begin
	if (RST = '0') then
		xplusone_reg <= to_signed(-H_PIXEL_START + 1, VGAPOS_WIDTH);
		yplusone_reg <= to_signed(-V_PIXEL_START + 1, VGAPOS_WIDTH);
		vsync_reg <= '1';
	elsif rising_edge(CLK) then
		xplusone_reg <= xplusone_next;
		yplusone_reg <= yplusone_next;
		vsync_reg <= vsync_next;
	end if;
end process;

process(xplusone_reg, yplusone_reg, vsync_reg)
begin
	xplusone_next <= xplusone_reg;
	yplusone_next <= yplusone_reg;
	vsync_next <= vsync_reg;
	
	if (xplusone_reg = H_PIXEL_END - H_PIXEL_START) then
		xplusone_next <= to_signed(-H_PIXEL_START + 1, VGAPOS_WIDTH);
		
		if (yplusone_reg = V_PIXEL_END - V_PIXEL_START) then
			yplusone_next <= to_signed(-V_PIXEL_START + 1, VGAPOS_WIDTH);
			vsync_next <= '1';
		else
			if yplusone_reg = -1 then
				vsync_next <= '0';
			end if; 
			
			yplusone_next <= yplusone_reg + 1;
		end if;
	else
		xplusone_next <= xplusone_reg + 1;
	end if;
end process;

end architecture imp;
