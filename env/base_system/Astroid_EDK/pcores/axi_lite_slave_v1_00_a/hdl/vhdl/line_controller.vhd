
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_misc.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

use work.types.all;

entity line_controller is
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
end line_controller;

architecture Behavioral of line_controller is

signal dx_reg : signed_vgapos_t;
signal dx_next : signed_vgapos_t;
signal dy_reg : signed_vgapos_t;
signal dy_next : signed_vgapos_t;
signal sx_reg : std_logic;
signal sx_next : std_logic;
signal err_reg : signed_vgapos_t;
signal err_next : signed_vgapos_t;
signal x_reg : vgapos_t;
signal y_reg : vgapos_t;
signal x_next : vgapos_t;
signal y_next : vgapos_t;
signal en_reg : std_logic;
signal en_next : std_logic;
signal start_reg : vgapos_t;
signal start_next : vgapos_t;
signal end_reg : vgapos_t;
signal end_next : vgapos_t;
signal line_reg : vgapos_t;
signal line_next : vgapos_t;
signal prev_start_reg : vgapos_t;
signal prev_start_next : vgapos_t;
signal prev_end_reg : vgapos_t;
signal prev_end_next : vgapos_t;

begin

ENABLE <= en_reg;
OUTPUT <= '1' when en_reg = '1' and (X >= prev_start_reg) and (X < prev_end_reg) else '0';

process(CLK, RST)
begin
	if (RST = '0') then
		dx_reg <= (others => '0');
		dy_reg <= (others => '0');
		sx_reg <= '0';
		err_reg <= (others => '0');
		x_reg <= (others => '0');
		y_reg <= (others => '0');
		en_reg <= '0';
		start_reg <= (others => '0');
		end_reg <= (others => '0');
		line_reg <= (others => '0');
		prev_start_reg <= (others => '0');
		prev_end_reg <= (others => '0');
	elsif rising_edge(CLK) then
		dx_reg <= dx_next;
		dy_reg <= dy_next;
		sx_reg <= sx_next;
		err_reg <= err_next;
		x_reg <= x_next;
		y_reg <= y_next;
		en_reg <= en_next;
		start_reg <= start_next;
		end_reg <= end_next;
		line_reg <= line_next;
		prev_start_reg <= prev_start_next;
		prev_end_reg <= prev_end_next;
	end if;
end process;

process(X, Y, X0, Y0, X1, Y1, PROGRAM, dx_reg, dy_reg, sx_reg, err_reg, x_reg, y_reg, en_reg, start_reg, end_reg, line_reg, prev_start_reg, prev_end_reg)
	variable err : signed_vgapos_t := (others => '0');
	variable dx : signed_vgapos_t := (others => '0');
	variable dy : signed_vgapos_t := (others => '0');
	variable x : vgapos_t := (others => '0');
begin
	dx_next <= dx_reg;
	dy_next <= dy_reg;
	sx_next <= sx_reg;
	err_next <= err_reg;
	x_next <= x_reg;
	y_next <= y_reg;
	en_next <= en_reg;
	start_next <= start_reg;
	end_next <= end_reg;
	line_next <= line_reg;
	prev_start_next <= prev_start_reg;
	prev_end_next <= prev_end_reg;
	
	if PROGRAM = '1' then
		if X1 > X0 then
			sx_next <= '1';
			dx := signed(X1 - X0);
		else
			sx_next <= '0';
			dx := signed(X0 - X1);
		end if;
		if Y1 > Y0 then
			dy := signed(Y1 - Y0);
		else
			dy := signed(Y0 - Y1);
		end if;
		if dx > dy then
			err_next <= dx / 2;
		else
			err_next <= -dy / 2;
		end if;
		
		dx_next <= dx;
		dy_next <= dy;
		x_next <= X0;
		y_next <= Y0;
		en_next <= '1';
		start_next <= X0;
		end_next <= (others => '0');
		line_next <= (others => '0');
		prev_start_next <= (others => '0');
		prev_end_next <= (others => '0');
	else
		if en_reg = '1' then
			if y_reg = Y + 1 then
				end_next <= x_reg;
				
				if not (line_reg = Y) then
					if start_reg < x_reg then
						prev_start_next <= start_reg;
						prev_end_next <= x_reg;
					else
						prev_start_next <= x_reg;
						prev_end_next <= start_reg;
					end if;
				end if;
				
				x := x_reg;
				err := err_reg;
				
				if err_reg > -dx_reg then
					if sx_reg = '1' then
						x := x_reg + 1;
					else
						x := x_reg - 1;
					end if;
					err := err - dy_reg;
				end if;
				if err_reg < dy_reg then
					start_next <= x;
					y_next <= y_reg + 1;
					err := err + dx_reg;
				end if;
				
				x_next <= x;
				err_next <= err_reg + err;
			end if;
			
			if Y = Y1 + 1 then
				en_next <= '0';
			end if;
			
			line_next <= Y;
		end if;
	end if;
end process;

end Behavioral;

