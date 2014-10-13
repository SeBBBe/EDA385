-----------------------------------------------------------------------------
--
-- AXI Lite Slave
--
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.std_logic_unsigned.all;

library snd_mixer_v1_00_a; --USER-- library name
use snd_mixer_v1_00_a.all; --USER-- use statement

use work.types.all;

entity snd_mixer is
  generic (
    C_S_AXI_ADDR_WIDTH   : integer := 32;
    C_S_AXI_DATA_WIDTH   : integer := 32
    );
  port(
    -- System Signals
    ACLK    : in std_logic;
    ARESETN : in std_logic;

    -- Slave Interface Write Address Ports
    S_AXI_AWADDR   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_AWPROT   : in  std_logic_vector(3-1 downto 0);
    S_AXI_AWVALID  : in  std_logic;
    S_AXI_AWREADY  : out std_logic;

    -- Slave Interface Write Data Ports
    S_AXI_WDATA  : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_WSTRB  : in  std_logic_vector(C_S_AXI_DATA_WIDTH/8-1 downto 0);
    S_AXI_WVALID : in  std_logic;
    S_AXI_WREADY : out std_logic;

    -- Slave Interface Write Response Ports
    S_AXI_BRESP  : out std_logic_vector(2-1 downto 0);
    S_AXI_BVALID : out std_logic;
    S_AXI_BREADY : in  std_logic;

    -- Slave Interface Read Address Ports
    S_AXI_ARADDR   : in  std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    S_AXI_ARPROT   : in  std_logic_vector(3-1 downto 0);
    S_AXI_ARVALID  : in  std_logic;
    S_AXI_ARREADY  : out std_logic;

    -- Slave Interface Read Data Ports
    S_AXI_RDATA  : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
    S_AXI_RRESP  : out std_logic_vector(2-1 downto 0);
    S_AXI_RVALID : out std_logic;
    S_AXI_RREADY : in  std_logic;
	 
	 INPUT1	   : in std_logic_vector(7 downto 0);
	 INPUT2	   : in std_logic_vector(7 downto 0);
	
	-- AMP interface
    JA	   : out std_logic_vector(7 downto 0)
    );

end snd_mixer;

architecture implementation of snd_mixer is

signal mem_output : mixcfg_t;
signal mem_trigger : std_logic;

signal count_reg, count_next : volume_t;

begin

mem1 : entity work.mem_controller
	port map
	(
		ACLK => ACLK,
		ARESETN => ARESETN,
		
		S_AXI_AWADDR => S_AXI_AWADDR,
		S_AXI_AWPROT => S_AXI_AWPROT,
		S_AXI_AWVALID => S_AXI_AWVALID,
		S_AXI_AWREADY => S_AXI_AWREADY,
		
		S_AXI_WDATA => S_AXI_WDATA,
		S_AXI_WSTRB => S_AXI_WSTRB,
		S_AXI_WVALID => S_AXI_WVALID,
		S_AXI_WREADY => S_AXI_WREADY,
		
		S_AXI_BRESP => S_AXI_BRESP,
		S_AXI_BVALID => S_AXI_BVALID,
		S_AXI_BREADY => S_AXI_BREADY,
		
		S_AXI_ARADDR => S_AXI_ARADDR,
		S_AXI_ARPROT => S_AXI_ARPROT,
		S_AXI_ARVALID => S_AXI_ARVALID,
		S_AXI_ARREADY => S_AXI_ARREADY,
		
		S_AXI_RDATA => S_AXI_RDATA,
		S_AXI_RRESP => S_AXI_RRESP,
		S_AXI_RVALID => S_AXI_RVALID,
		S_AXI_RREADY => S_AXI_RREADY,
		
		OUTPUT => mem_output,
		TRIGGER => mem_trigger
	);

process(ACLK, ARESETN)
begin
	if rising_edge(ACLK) then
		if ARESETN = '0' then
			count_reg <= 0;
		else
			count_reg <= count_next;
		end if;
	end if;
end process;

process(INPUT1, INPUT2, count_reg, mem_trigger, mem_output)
begin
	count_next <= count_reg + 1;
	JA <= INPUT2;

	if count_reg < mem_output.vol1 then
		JA <= INPUT1;
	elsif count_reg = mem_output.vol1 + mem_output.vol2 - 1 then
		count_next <= 0;
	end if;
	
	if mem_trigger = '1' then
		count_next <= 0;
	end if;
end process;

end implementation;
