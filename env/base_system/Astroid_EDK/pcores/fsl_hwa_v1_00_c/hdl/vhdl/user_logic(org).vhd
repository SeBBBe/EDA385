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
    Rst      : in std_logic; -- reset, active high
    -- read signals
    Exists   : in std_logic; -- active if data is available
    Rd_ack   : out std_logic; -- read ack from the core
    D_in     : in std_logic_vector(0 to 31); -- data to the core
    -- write signals
    Full     : in std_logic; -- active if fifo is full
    Wr_en    : out std_logic; -- read ack from the core
    D_out    : out std_logic_vector(0 to 31) -- data to the core
  );
end entity user_logic;

architecture IMP of user_logic is
  signal data : std_logic_vector(0 to 31);
begin
  -- replace this dummy hardware with your own GCD
  D_out <= data;
  process (clk, Rst)
  begin  -- process
    if Rst = '1' then
      data <= (others => '0');
      Rd_ack <= '0';
      Wr_en <= '0';
    elsif clk'event and clk = '1' then
      if Exists = '1' then
        Rd_ack <= '1';
      else
        Rd_ack <= '0';
      end if;
      if Full = '0' then
        data <= data + 1;
        Wr_en <= '1';
      else
        Wr_en <= '0';
      end if;
    end if;
  end process;
end architecture IMP;
