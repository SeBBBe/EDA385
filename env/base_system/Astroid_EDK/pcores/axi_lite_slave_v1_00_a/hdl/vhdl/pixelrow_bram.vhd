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
    CLK       : in std_logic; -- clock
    RST	     : in std_logic; -- reset, active low
	 
	 NEWLINE   : in std_logic;
	 
	 XPLUSONE  : in vgapos_t;
	 PIXEL_OUT : out std_logic;
	 
	 WR_X      : in vgapos_t;
	 WR_PIXEL  : in std_logic
  );
end pixelrow_bram;

architecture Behavioral of pixelrow_bram is

type per_bram_vgapos_t is array (0 to 1) of vgapos_t;
type per_bram_std_logic_t is array (0 to 1) of std_logic;

signal bram_addrs : per_bram_vgapos_t;
signal bram_rdatas : per_bram_std_logic_t;
signal bram_wes : per_bram_std_logic_t;
signal bram_wdatas : per_bram_std_logic_t;

signal curr_bram_reg : integer range 0 to 1;
signal curr_bram_next : integer range 0 to 1;

begin
	GEN_BRAM : for I in 0 to 1 generate
		bramX : entity work.bram
		 port map (
			CLK => CLK,
			RST => RST,
			
			ADDR => bram_addrs(I),
			RDATA => bram_rdatas(I),
			
			WDATA => bram_wdatas(I),
			WE => bram_wes(I)
		);
	end generate GEN_BRAM;

process(CLK, RST)
begin
	if RST = '0' then
		curr_bram_reg <= 0;
	elsif rising_edge(CLK) then
		curr_bram_reg <= curr_bram_next;
	end if;
end process;

process(RST, NEWLINE, XPLUSONE, WR_X, WR_PIXEL, curr_bram_reg, bram_rdatas)
begin
	curr_bram_next <= curr_bram_reg;
	
	if curr_bram_reg = 0 then
		bram_addrs(0) <= WR_X;
		bram_wes(0) <= WR_PIXEL;
		bram_wdatas(0) <= WR_PIXEL;
		
		PIXEL_OUT <= bram_rdatas(1);
		bram_addrs(1) <= XPLUSONE;
		bram_wes(1) <= '1';
		bram_wdatas(1) <= '0';
	else
		bram_addrs(1) <= WR_X;
		bram_wes(1) <= WR_PIXEL;
		bram_wdatas(1) <= WR_PIXEL;
		
		PIXEL_OUT <= bram_rdatas(0);
		bram_addrs(0) <= XPLUSONE;
		bram_wes(0) <= '1';
		bram_wdatas(0) <= '0';
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
