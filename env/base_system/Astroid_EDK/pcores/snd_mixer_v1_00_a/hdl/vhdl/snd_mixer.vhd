-----------------------------------------------------------------------------
--
-- AXI Lite Slave
--
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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
	 
	 INPUT1	   : in pcm_t;
	 INPUT2	   : in pcm_t;
	
	-- AMP interface
    JA	   : out std_logic_vector(7 downto 0)
    );

end snd_mixer;

architecture implementation of snd_mixer is

signal mem_output : mixcfg_t;
signal mem_trigger : std_logic;

signal ja_reg, ja_next : std_logic_vector(7 downto 0);

signal pcm_reg, pcm_next : pcm_t;

signal pdm_out : std_logic;

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

pdm1 : entity work.pdm_generator
	port map
	(
		CLK => ACLK,
		RST => ARESETN,
		
		PCM => pcm_reg,
		OUTPUT => pdm_out
	);

JA <= ja_reg;

ja_next <= (others => pdm_out);

process(ACLK, ARESETN)
begin
	if rising_edge(ACLK) then
		if ARESETN = '0' then
			ja_reg <= (others => '0');
			pcm_reg <= (others => '0');
		else
			ja_reg <= ja_next;
			pcm_reg <= pcm_next;
		end if;
	end if;
end process;

process(INPUT1, INPUT2, mem_output)
begin
	pcm_next <= (INPUT1 srl to_integer(mem_output.vol1)) + (INPUT2 srl to_integer(mem_output.vol2));
end process;

end implementation;
