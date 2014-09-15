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

entity axi_lite_slave is
  generic (
    C_S_AXI_ADDR_WIDTH   : integer := 32;
    C_S_AXI_DATA_WIDTH   : integer := 32;
	 VGA_POS_WIDTH        : integer := 16
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
    VGA_RED	    : out std_logic_vector(0 to 2);
    VGA_GREEN	: out std_logic_vector(0 to 2);
    VGA_BLUE	: out std_logic_vector(0 to 2)
    );

end axi_lite_slave;

architecture implementation of axi_lite_slave is

signal vga_x, vga_y : std_logic_vector(VGA_POS_WIDTH-1 downto 0);
signal hsync, vsync : std_logic;
signal output : std_logic;

component vga_controller is
	generic (
		VGA_POS_WIDTH        : integer := 16
    );
  port
  (
    CLK       : in std_logic; -- clock
    RST	      : in std_logic; -- reset, active low
    HSYNC     : out std_logic;
	VSYNC     : out std_logic;
	X         : out std_logic_vector(VGA_POS_WIDTH-1 downto 0);
	Y         : out std_logic_vector(VGA_POS_WIDTH-1 downto 0);
	VGA_HSYNC : out std_logic;
	VGA_VSYNC : out std_logic
  );
end component vga_controller;

component vector_controller is
	generic (
		VGA_POS_WIDTH        : integer := 16
    );
	port
	(
		CLK      : in std_logic; -- clock
		RST	     : in std_logic; -- reset, active low
		HSYNC    : in std_logic;
		VSYNC    : in std_logic;
		X        : in std_logic_vector(VGA_POS_WIDTH-1 downto 0);
		Y        : in std_logic_vector(VGA_POS_WIDTH-1 downto 0);
		OUTPUT   : out std_logic
	);
end component vector_controller;

begin

vga1 : vga_controller
	generic map (
		VGA_POS_WIDTH        => VGA_POS_WIDTH
    )
	port map
	(
		CLK => ACLK,
		RST => ARESETN,
		HSYNC => hsync,
		VSYNC => vsync,
		X => vga_x,
		Y => vga_y,
		VGA_HSYNC => VGA_HSYNC,
		VGA_VSYNC => VGA_VSYNC
	);
	
vector1 : vector_controller
	generic map (
		VGA_POS_WIDTH        => VGA_POS_WIDTH
    )
	port map
	(
		CLK => ACLK,
		RST => ARESETN,
		HSYNC => hsync,
		VSYNC => vsync,
		X => vga_x,
		Y => vga_y,
		OUTPUT => output
	);

VGA_RED <= "111" when output = '1' else "000";
VGA_GREEN <= "111" when output = '1' else "000";
VGA_BLUE <= "111" when output = '1' else "000";

end implementation;
