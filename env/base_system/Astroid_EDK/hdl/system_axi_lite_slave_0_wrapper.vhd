-------------------------------------------------------------------------------
-- system_axi_lite_slave_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library axi_lite_slave_v1_00_a;
use axi_lite_slave_v1_00_a.all;

entity system_axi_lite_slave_0_wrapper is
  port (
    ACLK : in std_logic;
    ARESETN : in std_logic;
    S_AXI_AWADDR : in std_logic_vector(31 downto 0);
    S_AXI_AWPROT : in std_logic_vector(2 downto 0);
    S_AXI_AWVALID : in std_logic;
    S_AXI_AWREADY : out std_logic;
    S_AXI_WDATA : in std_logic_vector(31 downto 0);
    S_AXI_WSTRB : in std_logic_vector(3 downto 0);
    S_AXI_WVALID : in std_logic;
    S_AXI_WREADY : out std_logic;
    S_AXI_BRESP : out std_logic_vector(1 downto 0);
    S_AXI_BVALID : out std_logic;
    S_AXI_BREADY : in std_logic;
    S_AXI_ARADDR : in std_logic_vector(31 downto 0);
    S_AXI_ARPROT : in std_logic_vector(2 downto 0);
    S_AXI_ARVALID : in std_logic;
    S_AXI_ARREADY : out std_logic;
    S_AXI_RDATA : out std_logic_vector(31 downto 0);
    S_AXI_RRESP : out std_logic_vector(1 downto 0);
    S_AXI_RVALID : out std_logic;
    S_AXI_RREADY : in std_logic;
    VGA_HSYNC : out std_logic;
    VGA_VSYNC : out std_logic;
    VGA_RED : out std_logic_vector(2 downto 0);
    VGA_GREEN : out std_logic_vector(2 downto 0);
    VGA_BLUE : out std_logic_vector(2 downto 0)
  );
end system_axi_lite_slave_0_wrapper;

architecture STRUCTURE of system_axi_lite_slave_0_wrapper is

  component axi_lite_slave is
    generic (
      C_S_AXI_ADDR_WIDTH : integer;
      C_S_AXI_DATA_WIDTH : integer
    );
    port (
      ACLK : in std_logic;
      ARESETN : in std_logic;
      S_AXI_AWADDR : in std_logic_vector((C_S_AXI_ADDR_WIDTH-1) downto 0);
      S_AXI_AWPROT : in std_logic_vector(2 downto 0);
      S_AXI_AWVALID : in std_logic;
      S_AXI_AWREADY : out std_logic;
      S_AXI_WDATA : in std_logic_vector((C_S_AXI_DATA_WIDTH-1) downto 0);
      S_AXI_WSTRB : in std_logic_vector(((C_S_AXI_DATA_WIDTH/8) -1) downto 0);
      S_AXI_WVALID : in std_logic;
      S_AXI_WREADY : out std_logic;
      S_AXI_BRESP : out std_logic_vector(1 downto 0);
      S_AXI_BVALID : out std_logic;
      S_AXI_BREADY : in std_logic;
      S_AXI_ARADDR : in std_logic_vector((C_S_AXI_ADDR_WIDTH-1) downto 0);
      S_AXI_ARPROT : in std_logic_vector(2 downto 0);
      S_AXI_ARVALID : in std_logic;
      S_AXI_ARREADY : out std_logic;
      S_AXI_RDATA : out std_logic_vector((C_S_AXI_DATA_WIDTH-1) downto 0);
      S_AXI_RRESP : out std_logic_vector(1 downto 0);
      S_AXI_RVALID : out std_logic;
      S_AXI_RREADY : in std_logic;
      VGA_HSYNC : out std_logic;
      VGA_VSYNC : out std_logic;
      VGA_RED : out std_logic_vector(2 downto 0);
      VGA_GREEN : out std_logic_vector(2 downto 0);
      VGA_BLUE : out std_logic_vector(2 downto 0)
    );
  end component;

begin

  axi_lite_slave_0 : axi_lite_slave
    generic map (
      C_S_AXI_ADDR_WIDTH => 32,
      C_S_AXI_DATA_WIDTH => 32
    )
    port map (
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
      VGA_HSYNC => VGA_HSYNC,
      VGA_VSYNC => VGA_VSYNC,
      VGA_RED => VGA_RED,
      VGA_GREEN => VGA_GREEN,
      VGA_BLUE => VGA_BLUE
    );

end architecture STRUCTURE;

