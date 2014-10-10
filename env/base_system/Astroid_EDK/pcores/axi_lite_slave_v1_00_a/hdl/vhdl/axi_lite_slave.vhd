-----------------------------------------------------------------------------
--
-- AXI Lite Slave
--
-----------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use ieee.std_logic_unsigned.all;

library axi_lite_slave_v1_00_a; --USER-- library name
use axi_lite_slave_v1_00_a.all; --USER-- use statement

use work.types.all;

entity axi_lite_slave is
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
	
	-- VGA interface
	 VGA_HSYNC	: out std_logic;
    VGA_VSYNC	: out std_logic;
    VGA_RED	   : out std_logic_vector(2 downto 0);
    VGA_GREEN	: out std_logic_vector(2 downto 0);
    VGA_BLUE	: out std_logic_vector(1 downto 0)
    );

end axi_lite_slave;

architecture implementation of axi_lite_slave is

signal hsync, vsync : std_logic;
signal overscan, vga_enable : std_logic;
signal output : color_t;

signal mem_output : linereg_t;
signal mem_trigger : std_logic;

signal vector_enable : std_logic;

signal newline : std_logic;

signal vga_sync_reg : vgaiface_t;
signal vga_sync_delay : vgaiface_t;
signal vga_sync_next : vgaiface_t;

signal vga_color_reg : vgaiface_t;
signal vga_color_next : vgaiface_t;

signal overscan_reg : std_logic;
signal overscan_next : std_logic;

begin

vga1 : entity work.vga_controller
	port map
	(
		CLK => ACLK,
		RST => ARESETN,
		OVERSCAN => overscan_next,
		ENABLE => vga_enable,
		NEWLINE => newline,
		HSYNC => hsync,
		VSYNC => vsync
	);
	
vector1 : entity work.vector_controller
	port map
	(
		CLK => ACLK,
		RST => ARESETN,
		NEWLINE => newline,
		ENABLE => mem_trigger,
		INPUT => mem_output,
		PIXEL_OUT => output
	);

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
		
		VSYNC => vga_enable,
		OUTPUT => mem_output,
		TRIGGER => mem_trigger
	);

process(ACLK, ARESETN)
begin
	if rising_edge(ACLK) then
		if ARESETN = '0' then
			vga_sync_reg <= EMPTY_VGAIFACE;
			vga_sync_delay <= EMPTY_VGAIFACE;
			vga_color_reg <= EMPTY_VGAIFACE;
			overscan_reg <= '0';
		else
			vga_sync_reg <= vga_sync_delay;
			vga_sync_delay <= vga_sync_next;
			vga_color_reg <= vga_color_next;
			overscan_reg <= overscan_next;
		end if;
	end if;
end process;

-- sync signal is delayed by 1 cycle here, color signal is delayed by 1 cycle in vector controller
process(overscan_reg, output, hsync, vsync)
begin
	vga_sync_next.hsync <= not hsync; -- positive sync polarity
	vga_sync_next.vsync <= vsync; -- negative sync polarity
	
	if overscan_reg = '0' then
		vga_color_next.red <= std_logic_vector(output(2 downto 0));
		vga_color_next.green <= std_logic_vector(output(5 downto 3));
		vga_color_next.blue <= std_logic_vector(output(7 downto 6));
	else
		vga_color_next.red <= "000";
		vga_color_next.green <= "000";
		vga_color_next.blue <= "00";
	end if;
end process;

VGA_RED <= vga_color_reg.red;
VGA_GREEN <= vga_color_reg.green;
VGA_BLUE <= vga_color_reg.blue;
VGA_HSYNC <= vga_sync_reg.hsync;
VGA_VSYNC <= vga_sync_reg.vsync;

end implementation;
