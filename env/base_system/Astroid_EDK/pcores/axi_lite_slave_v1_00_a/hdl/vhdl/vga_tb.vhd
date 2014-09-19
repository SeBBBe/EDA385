LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

library axi_lite_slave_v1_00_a; --USER-- library name
use axi_lite_slave_v1_00_a.all;

use work.types.all;

ENTITY vga_tb IS 
END vga_tb;

ARCHITECTURE behavior OF vga_tb IS

component axi_lite_slave is
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
    VGA_RED	   : out std_logic_vector(0 to 2);
    VGA_GREEN	: out std_logic_vector(0 to 2);
    VGA_BLUE	: out std_logic_vector(0 to 2)
    );

end component axi_lite_slave;

	signal S_AXI_AWADDR : std_logic_vector(32-1 downto 0);
	signal S_AXI_WDATA  : std_logic_vector(32-1 downto 0);
	signal S_AXI_WSTRB  : std_logic_vector(32/8-1 downto 0);
	signal S_AXI_ARADDR : std_logic_vector(32-1 downto 0);
	signal S_AXI_RDATA  : std_logic_vector(32-1 downto 0);
	
	signal S_AXI_AWVALID : std_logic;
	signal S_AXI_AWREADY : std_logic;
	signal S_AXI_WVALID  : std_logic;
	signal S_AXI_WREADY  : std_logic;
	signal S_AXI_BVALID  : std_logic;
	signal S_AXI_BREADY  : std_logic;
	signal S_AXI_ARVALID : std_logic;
	signal S_AXI_ARREADY : std_logic;
	signal S_AXI_RVALID  : std_logic;
	signal S_AXI_RREADY  : std_logic;
	
	signal S_AXI_AWPROT : std_logic_vector(3-1 downto 0);
	signal S_AXI_ARPROT : std_logic_vector(3-1 downto 0);
	
	signal S_AXI_BRESP  : std_logic_vector(2-1 downto 0);
	signal S_AXI_RRESP  : std_logic_vector(2-1 downto 0);
	
	signal vga_hsync : std_logic;
	signal vga_vsync : std_logic;
	signal vga_red   : std_logic_vector(0 to 2);
	signal vga_green : std_logic_vector(0 to 2);
	signal vga_blue  : std_logic_vector(0 to 2);

	signal rst : std_logic := '1';

   signal clk : std_logic := '0';
   constant clk_period : time := 1 us;

BEGIN

   uut: axi_lite_slave
		PORT MAP
		(
			ACLK => clk,
			ARESETN => rst,
			S_AXI_AWADDR => S_AXI_AWADDR,
			S_AXI_WDATA => S_AXI_WDATA,
			S_AXI_WSTRB => S_AXI_WSTRB,
			S_AXI_ARADDR => S_AXI_ARADDR,
			S_AXI_RDATA => S_AXI_RDATA,
			S_AXI_AWVALID => S_AXI_AWVALID,
			S_AXI_AWREADY => S_AXI_AWREADY,
			S_AXI_WVALID => S_AXI_WVALID,
			S_AXI_WREADY => S_AXI_WREADY,
			S_AXI_BVALID => S_AXI_BVALID,
			S_AXI_BREADY => S_AXI_BREADY,
			S_AXI_ARVALID => S_AXI_ARVALID,
			S_AXI_ARREADY => S_AXI_ARREADY,
			S_AXI_RVALID => S_AXI_RVALID,
			S_AXI_RREADY => S_AXI_RREADY,
			S_AXI_AWPROT => S_AXI_AWPROT,
			S_AXI_ARPROT => S_AXI_ARPROT,
			S_AXI_BRESP => S_AXI_BRESP,
			S_AXI_RRESP => S_AXI_RRESP,
			vga_hsync => vga_hsync,
			vga_vsync => vga_vsync,
			vga_red => vga_red,
			vga_green => vga_green,
			vga_blue => vga_blue
		);

   -- Clock process definitions( clock with 50% duty cycle is generated here.
   clk_process :process
   begin
        clk <= '0';
        wait for clk_period/2;  --for 0.5 ns signal is '0'.
        clk <= '1';
        wait for clk_period/2;  --for next 0.5 ns signal is '1'.
   end process;
	
	rst_process : process
	begin
		rst <= '0';
		wait for clk_period * 10;
		rst <= '1';
		wait;
	end process;

END;

