-------------------------------------------------------------------------------
-- Filename:        user_logic.vhd
-- Version:         v1.00c
-- Description:     The GCD functionallity of your choice
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
library Unisim;
use Unisim.all;

-----------------------------------------------------------------------------
-- Entity section
-----------------------------------------------------------------------------

entity user_logic is
  port (
    Clk      : in std_logic; -- clock
    Rst		 : in std_logic; -- reset, active high
    -- read signals
    Exists   : in std_logic; -- active if data is available
    Rd_ack   : out std_logic; -- read ack from this core
    D_in     : in std_logic_vector(0 to 31); -- data to this core
    -- write signals
    Full     : in std_logic; -- active if fifo is full
    Wr_en    : out std_logic; -- read ack from this core
    D_out    : out std_logic_vector(0 to 31) -- data from this core
  );
end entity user_logic;

architecture IMP of user_logic is
type STATE_TYPE is (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10);
signal CS, NS: STATE_TYPE;
signal u, v, nu, nv: std_logic_vector(0 to 31);
signal shift, cshift, nshift, ncshift: NATURAL;
begin

SYNC_PROC: process(Clk, Rst)
begin
	if (Rst = '1') then
		CS <= S0;
	-- other state variables reset
	elsif rising_edge(Clk) then
		CS <= NS;
		u <= nu;
		v <= nv;
		shift <= nshift;
		cshift <= ncshift;
	-- other state variable assignment
	end if;
end process;

COMB_PROC: process(CS, Exists, D_in, u, v, shift, cshift)
	variable t: std_logic_vector(0 to 31);
	--variable u, v, t: std_logic_vector(0 to 31);
	--variable shift, cshift: NATURAL;
begin
 nu <= u;
 nv <= v;
 NS <= CS;
 nshift <= shift;
 ncshift <= cshift;
 
-- assign default signals here to avoid latches
	case CS is
		-- read
		when S0 =>
			ncshift <= 0;
			nshift <= 0;
			if (Exists = '1') then
				nu <= D_in;
				Rd_ack <= '1';
				Wr_en <= '0';
				NS <= S1;
			else
				NS <= S0;
			end if;
		
		when S1 =>
			Rd_ack <= '0';
			NS <= S2;
		
		when S2 =>
			if (Exists = '1') then
				nv <= D_in;
				Rd_ack <= '1';
				NS <= S3;
			else
				NS <= S2;
			end if;
		
		when S3 =>
			Rd_ack <= '0';
			-- convert the std_logic_vector to Integer or some shit.
			if  (u = std_logic_vector(to_unsigned(0, u'length)) or v = std_logic_vector(to_unsigned(0, v'length))) then
			--if (to_integer(unsigned(u)) = 0 or to_integer(unsigned(v)) = 0) then
				--D_out <= std_logic_vector(to_unsigned(0, D_out'length));
				nshift <= 0;
				NS <= S0;
			end if;
			NS <= S4;
			
		when S4 =>
			if (u(31) = '0' and v(31) = '0') then
				nu <= '0' & u(0 to 30);
				nv <= '0' & v(0 to 30);
				nshift <= shift + 1;
				NS <= S4;
			else
				NS <= S5;
			end if;
			
		when S5 =>
			if (u(31) = '0') then
				nu <= '0' & u(0 to 30);
				NS <= S5;
			else
				NS <= S6;
			end if;

		when S6 =>
			if (v(31) = '0') then
				nv <= '0' & v(0 to 30);
				NS <= S6;
			else
				NS <= S7;
			end if;
			
		when S7 =>
			if (u > v) then
			-- SWAP U AND V
				t := v;
				nv <= u;
				nu <= t;
			end if;
			NS <= S8;
			
		when S8 =>
			nv <= v - u;
			NS <= S9;
			
		when S9 =>
			if (v = std_logic_vector(to_unsigned(0, v'length))) then
				NS <= S10;
			else
				NS <= S6;
			end if;
		
		--/* restore common factors of 2 */		
		when S10 =>
		
			if (cshift = shift) then
				D_out <= u(0 to 31);
				Wr_en <= '1';
															
				NS <= S0;
			else			
				nu <= u(1 to 31) & '0';
				ncshift <= cshift + 1;
				NS <= S10;
			end if;
		
		end case;
end process;

  --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  --  Observe!!! only use the type std_logic_vector(0 to 31) for integers.
  --  The bit ordered of the vector must be 0 to 31, 31 downto 0 will not work!
  --!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

end   architecture IMP;