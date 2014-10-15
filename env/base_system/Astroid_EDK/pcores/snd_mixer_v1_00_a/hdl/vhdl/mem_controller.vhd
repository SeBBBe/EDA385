library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

library snd_mixer_v1_00_a; --USER-- library name
use snd_mixer_v1_00_a.all; --USER-- use statement

use work.types.all;

entity mem_controller is
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
	 
	 OUTPUT : out mixcfg_t;
	 TRIGGER : out std_logic
	 );
end mem_controller;

architecture Behavioral of mem_controller is

signal output_reg : mixcfg_t;
signal output_next : mixcfg_t;

signal write_reg : std_logic;
signal write_next : std_logic;

signal rvalid_reg : std_logic;
signal rvalid_next : std_logic;

signal trigger_reg : std_logic;
signal trigger_next : std_logic;

begin

S_AXI_ARREADY <= '1';
S_AXI_RVALID <= rvalid_reg;
S_AXI_RDATA <= (others => '0');
S_AXI_RRESP <= (others => '0');

S_AXI_AWREADY <= '1';
S_AXI_WREADY <= '1' when write_reg = '0' else '0';

S_AXI_BVALID <= write_reg;
S_AXI_BRESP <= (others => '0');

TRIGGER <= trigger_reg;
OUTPUT <= output_reg;

process(ACLK, ARESETN)
begin
	if (ARESETN = '0') then
		output_reg <= DEFAULT_MIXCFG;
		write_reg <= '0';
		rvalid_reg <= '0';
		trigger_reg <= '0';
	elsif rising_edge(ACLK) then
		output_reg <= output_next;
		write_reg <= write_next;
		rvalid_reg <= rvalid_next;
		trigger_reg <= trigger_next;
	end if;
end process;

process(S_AXI_BREADY, S_AXI_WDATA, S_AXI_WVALID, S_AXI_ARVALID, S_AXI_RREADY, write_reg, output_reg, rvalid_reg)
begin
	write_next <= write_reg;
	output_next <= output_reg;
	rvalid_next <= rvalid_reg;
	
	trigger_next <= '0';
	
	if S_AXI_ARVALID = '1' and rvalid_reg = '0' then
		rvalid_next <= '1';
	end if;
	
	if S_AXI_RREADY = '1' and rvalid_reg = '1' then
		rvalid_next <= '0';
	end if;

	if S_AXI_WVALID = '1' and write_reg = '0' then
		write_next <= '1';
		
		output_next.vol1 <= unsigned(S_AXI_WDATA(16-1 downto 0));
		output_next.vol2 <= unsigned(S_AXI_WDATA(32-1 downto 16));
		
		trigger_next <= '1';
	end if;
	
	if S_AXI_BREADY = '1' and write_reg = '1' then
		write_next <= '0';
	end if;
end process;

end Behavioral;
