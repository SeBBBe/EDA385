----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:00:17 09/24/2014 
-- Design Name: 
-- Module Name:    bram - Behavioral 
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

Library UNISIM;
use UNISIM.vcomponents.all;

Library UNIMACRO;
use UNIMACRO.vcomponents.all;

use work.types.all;

entity bram is
	port
  (
    CLK       : in std_logic; -- clock
    RST	     : in std_logic; -- reset, active low
	 
	 PORTA_IN  : in bramiface_in_t;
	 PORTB_IN  : in bramiface_in_t;
	 PORTA_OUT : out bramiface_out_t;
	 PORTB_OUT : out bramiface_out_t
  );
end bram;

architecture Behavioral of bram is

signal bram_doa   : std_logic_vector(7 downto 0);
signal bram_dob   : std_logic_vector(7 downto 0);
signal bram_addra : std_logic_vector(11-1 downto 0);
signal bram_addrb : std_logic_vector(11-1 downto 0);
signal bram_dia   : std_logic_vector(7 downto 0);
signal bram_dib   : std_logic_vector(7 downto 0);
signal bram_wea   : std_logic_vector(0 downto 0);
signal bram_web   : std_logic_vector(0 downto 0);
signal bram_en    : std_logic;
signal bram_regce : std_logic;
signal bram_rst   : std_logic;

begin

   BRAM_TDP_MACRO_inst : BRAM_TDP_MACRO
   generic map (
      BRAM_SIZE => "18Kb", -- Target BRAM, "9Kb" or "18Kb" 
      DEVICE => "SPARTAN6", -- Target Device: "VIRTEX5", "VIRTEX6", "SPARTAN6" 
      DOA_REG => 0, -- Optional port A output register (0 or 1)
      DOB_REG => 0, -- Optional port B output register (0 or 1)
      INIT_A => X"000000000", -- Initial values on A output port
      INIT_B => X"000000000", -- Initial values on B output port
      INIT_FILE => "NONE",
      READ_WIDTH_A => 8,   -- Valid values are 1-36 
      READ_WIDTH_B => 8,   -- Valid values are 1-36
      SIM_COLLISION_CHECK => "NONE", -- Collision check enable "ALL", "WARNING_ONLY", 
                                    -- "GENERATE_X_ONLY" or "NONE" 
      SRVAL_A => X"000000000",   -- Set/Reset value for A port output
      SRVAL_B => X"000000000",   -- Set/Reset value for B port output
      WRITE_MODE_A => "READ_FIRST", -- "WRITE_FIRST", "READ_FIRST" or "NO_CHANGE" 
      WRITE_MODE_B => "READ_FIRST", -- "WRITE_FIRST", "READ_FIRST" or "NO_CHANGE" 
      WRITE_WIDTH_A => 8, -- Valid values are 1-36
      WRITE_WIDTH_B => 8  -- Valid values are 1-36
		)
    port map (
      DOA => bram_doa,      -- Output port-A data
      DOB => bram_dob,      -- Output port-B data
      ADDRA => bram_addra,  -- Input port-A address
      ADDRB => bram_addrb,  -- Input port-B address
      CLKA => CLK,          -- Input port-A clock
      CLKB => CLK,          -- Input port-B clock
      DIA => bram_dia,      -- Input port-A data
      DIB => bram_dib,      -- Input port-B data
      ENA => bram_en,       -- Input port-A enable
      ENB => bram_en,       -- Input port-B enable
      REGCEA => bram_regce, -- Input port-A output register enable
      REGCEB => bram_regce, -- Input port-B output register enable
      RSTA => bram_rst,     -- Input port-A reset
      RSTB => bram_rst,     -- Input port-B reset
      WEA => bram_wea,      -- Input port-A write enable
      WEB => bram_web       -- Input port-B write enable
   );
	
bram_regce <= '0';
bram_en <= '1';
bram_rst <= not RST;

PORTA_OUT.rdata <= unsigned(bram_doa);
PORTB_OUT.rdata <= unsigned(bram_dob);
bram_addra <= std_logic_vector(PORTA_IN.addr(11-1 downto 0));
bram_addrb <= std_logic_vector(PORTB_IN.addr(11-1 downto 0));
bram_dia <= std_logic_vector(PORTA_IN.wdata);
bram_dib <= std_logic_vector(PORTB_IN.wdata);

-- mask offscreen drawing
bram_wea(0) <= PORTA_IN.we when PORTA_IN.addr(12 downto 11) = "00" else '0';
bram_web(0) <= PORTB_IN.we when PORTB_IN.addr(12 downto 11) = "00" else '0';

end Behavioral;
