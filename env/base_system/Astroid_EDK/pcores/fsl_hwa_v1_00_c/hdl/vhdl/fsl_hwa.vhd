-------------------------------------------------------------------------------
-- Filename:        fsl_hwa.vhd
-- Version:         v1.00c
-- Description:     Fast Simplex Link core
--
-------------------------------------------------------------------------------
-- Structure: 
--              fsl_hwa.vhd
--                  -- user_logic.vhd
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;

--  Add user library if this source file uses
--  entities from the user library
library fsl_hwa_v1_00_c; --USER-- library name
use fsl_hwa_v1_00_c.all; --USER-- use statement

-------------------------------------------------------------------------------
-- Entity Section
-------------------------------------------------------------------------------

entity fsl_hwa is 
  generic (
	C_FSL_DWIDTH	: integer := 32; -- fsl data size
	C_EXT_RESET_HIGH  : integer := 1 -- external reset is active high
  ); 
  port
  (
    --Required FSL ports, do not add to or delete
    FSL_Clk	     : in std_logic; -- fsl clock
    FSL_Rst	     : in std_logic; -- reset signal for the core

    -- the slave part of the FSL interface
    FSL_S_Clk    : out std_logic; -- slave clock, the same as FSL_Clk
    FSL_S_Read   : out std_logic; -- read ack from the core
    FSL_S_Data   : in std_logic_vector(0 to C_FSL_DWIDTH-1); -- data to the core
    FSL_S_Control: in std_logic; -- active if control info is passed over
    FSL_S_Exists : in std_logic; -- active if data is available

    -- the master part of the FSL interface
    FSL_M_Clk    : out std_logic; -- slave clock, the same as FSL_Clk
    FSL_M_Write  : out std_logic; -- read ack from the core
    FSL_M_Data   : out std_logic_vector(0 to C_FSL_DWIDTH-1); -- data to the core
    FSL_M_Control: out std_logic; -- active if control info is passed over
    FSL_M_Full   : in std_logic -- active if fifo is full
  );

      --fan-out attributes for XST
 attribute MAX_FANOUT                  : string;
 attribute MAX_FANOUT   of FSL_Clk     : signal is "10000";
 attribute MAX_FANOUT   of FSL_Rst     : signal is "10000";
 attribute MAX_FANOUT   of FSL_S_Clk     : signal is "10000";
 attribute MAX_FANOUT   of FSL_M_Clk     : signal is "10000";

end entity fsl_hwa; --USER-- change entity name

-------------------------------------------------------------------------------
-- Architecture Section
-------------------------------------------------------------------------------

architecture imp of fsl_hwa is --USER-- change entity name

signal FSL_Rst_i: std_logic;

component user_logic is
  port
  (
     Clk      : in std_logic; -- clock
    Rst	      : in std_logic; -- reset, active high
    -- read signals
    Exists   : in std_logic; -- active if data is available
    Rd_ack   : out std_logic; -- read ack from the core
    D_in     : in std_logic_vector(0 to 31); -- data to the core
    -- write signals
    Full     : in std_logic; -- active if fifo is full
    Wr_en    : out std_logic; -- read ack from the core
    D_out    : out std_logic_vector(0 to 31) -- data to the core
   );
end component user_logic;

------------------------------------------------------------------------------
begin
------------------------------------------------------------------------------

my_gcd : user_logic
  port map
  (
    Clk => FSL_Clk,
    Rst => FSL_Rst_i,
    Exists => FSL_S_Exists,
    Rd_ack => FSL_S_Read,
    D_in => FSL_S_Data,
    Full => FSL_M_Full,
    Wr_en => FSL_M_Write,
    D_out => FSL_M_Data
 );
  
FSL_S_Clk   <= FSL_Clk; 
FSL_M_Clk   <= FSL_Clk;
FSL_M_Control <= '0';

-- reset signal, active high
FSL_Rst_i <= FSL_Rst when C_EXT_RESET_HIGH = 1 else not FSL_Rst;

end architecture imp;

