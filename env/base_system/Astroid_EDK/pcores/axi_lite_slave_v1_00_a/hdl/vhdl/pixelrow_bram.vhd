----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:07:29 09/24/2014 
-- Design Name: 
-- Module Name:    pixelrow_bram - Behavioral 
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

use work.types.all;

entity pixelrow_bram is
	port
  (
    CLK           : in std_logic; -- clock
    RST	         : in std_logic; -- reset, active low
	 
	 NEWLINE       : in std_logic;
	 
	 PIXEL_OUT     : out color_t;
	 
	 WR_X          : in vgapos_t;
	 WR_EN         : in std_logic;
	 WR_PIXEL      : in color_t;
	 
	 BRAM_EVEN_IN  : in bramiface_out_t;
	 BRAM_ODD_IN   : in bramiface_out_t;
	 BRAM_EVEN_OUT : out bramiface_in_t;
	 BRAM_ODD_OUT  : out bramiface_in_t
  );
end pixelrow_bram;

architecture Behavioral of pixelrow_bram is

signal curr_bram_reg : integer range 0 to 1;
signal curr_bram_next : integer range 0 to 1;

signal xplusone : vgapos_t;

begin
	
vga_counter1 : entity work.vga_counter
	port map (
		CLK => CLK,
		RST => RST,
		
		XPLUSONE => xplusone
	);

process(CLK, RST)
begin
	if RST = '0' then
		curr_bram_reg <= 0;
	elsif rising_edge(CLK) then
		curr_bram_reg <= curr_bram_next;
	end if;
end process;

process(NEWLINE, xplusone, WR_X, WR_EN, WR_PIXEL, curr_bram_reg, BRAM_EVEN_IN, BRAM_ODD_IN)
begin
	curr_bram_next <= curr_bram_reg;
	
	if curr_bram_reg = 0 then
		BRAM_EVEN_OUT.addr <= WR_X;
		BRAM_EVEN_OUT.we <= WR_EN;
		BRAM_EVEN_OUT.wdata <= WR_PIXEL;
		
		PIXEL_OUT <= BRAM_ODD_IN.rdata;
		BRAM_ODD_OUT.addr <= xplusone;
		BRAM_ODD_OUT.we <= '1';
		BRAM_ODD_OUT.wdata <= (others => '0');
	else
		BRAM_ODD_OUT.addr <= WR_X;
		BRAM_ODD_OUT.we <= WR_EN;
		BRAM_ODD_OUT.wdata <= WR_PIXEL;
		
		PIXEL_OUT <= BRAM_EVEN_IN.rdata;
		BRAM_EVEN_OUT.addr <= xplusone;
		BRAM_EVEN_OUT.we <= '1';
		BRAM_EVEN_OUT.wdata <= (others => '0');
	end if;
	
	if NEWLINE = '1' then
		if curr_bram_reg = 1 then
			curr_bram_next <= 0;
		else
			curr_bram_next <= 1;
		end if;
	end if;
end process;

end Behavioral;
