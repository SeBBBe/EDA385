LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

library axi_lite_slave_v1_00_a; --USER-- library name
use axi_lite_slave_v1_00_a.all;

use work.types.all;

ENTITY vga_tb IS 
END vga_tb;

ARCHITECTURE behavior OF vga_tb IS

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
	signal vga_blue  : std_logic_vector(0 to 1);

	signal rst : std_logic := '1';

   signal clk : std_logic := '0';
   constant clk_period : time := 1 us;

BEGIN

   uut: entity work.axi_lite_slave
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
	
	test_process : process
	begin
		wait until S_AXI_RDATA(0) = '1' and S_AXI_WREADY = '1';
		S_AXI_WDATA <= "1110000000000000" & "1110000000000000";
		S_AXI_WVALID <= '1';
		wait until S_AXI_BVALID = '1';
		S_AXI_WVALID <= '0';
		S_AXI_BREADY <= '1';
		
		wait until S_AXI_RDATA(0) = '1' and S_AXI_WREADY = '1';
		S_AXI_WDATA <= "1110000000001111" & "1110000000001111";
		S_AXI_WVALID <= '1';
		wait until S_AXI_BVALID = '1';
		S_AXI_WVALID <= '0';
		S_AXI_BREADY <= '1';
		
		
		wait until S_AXI_RDATA(0) = '1' and S_AXI_WREADY = '1';
		S_AXI_WDATA <= "1110000000000000" & "1110000000001111";
		S_AXI_WVALID <= '1';
		wait until S_AXI_BVALID = '1';
		S_AXI_WVALID <= '0';
		S_AXI_BREADY <= '1';
		
		wait until S_AXI_RDATA(0) = '1' and S_AXI_WREADY = '1';
		S_AXI_WDATA <= "1110000000001111" & "1110000000000000";
		S_AXI_WVALID <= '1';
		wait until S_AXI_BVALID = '1';
		S_AXI_WVALID <= '0';
		S_AXI_BREADY <= '1';
		
		wait until S_AXI_RDATA(0) = '0';
	end process;

END;

