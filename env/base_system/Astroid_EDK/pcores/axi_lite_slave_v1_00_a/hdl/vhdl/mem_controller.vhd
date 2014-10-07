library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

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
	 
	 VSYNC : in std_logic;
	 OUTPUT : out linereg_t;
	 TRIGGER : out std_logic
	 );
end mem_controller;

architecture Behavioral of mem_controller is

type state_t is (XY0, XY1);

signal output_reg : linereg_t;
signal output_next : linereg_t;

signal state_reg : state_t;
signal state_next : state_t;

signal write_reg : std_logic;
signal write_next : std_logic;

signal ready_reg : std_logic;
signal ready_next : std_logic;

signal prog_enable_reg : std_logic;
signal prog_enable_next : std_logic;

signal rvalid_reg : std_logic;
signal rvalid_next : std_logic;

signal prog_done : std_logic;

begin

programmer1 : entity work.line_programmer
	port map
	(
		CLK => ACLK,
		RST => ARESETN,
		
		ENABLE => prog_enable_reg,
		
		INPUT => output_reg,
		OUTPUT => OUTPUT,
		
		DONE => prog_done
	);

S_AXI_ARREADY <= '1';
S_AXI_RVALID <= rvalid_reg;
S_AXI_RDATA <= (others => '0') when VSYNC = '0' else (others => '1');
S_AXI_RRESP <= (others => '0');

S_AXI_AWREADY <= '1';
S_AXI_WREADY <= '1' when write_reg = '0' and ready_reg = '1' else '0';

S_AXI_BVALID <= write_reg;
S_AXI_BRESP <= (others => '0');

TRIGGER <= prog_done;

process(ACLK, ARESETN)
begin
	if (ARESETN = '0') then
		output_reg <= EMPTY_LINE_REG;
		state_reg <= XY0;
		write_reg <= '0';
		ready_reg <= '1';
		rvalid_reg <= '0';
		prog_enable_reg <= '0';
	elsif rising_edge(ACLK) then
		output_reg <= output_next;
		state_reg <= state_next;
		write_reg <= write_next;
		ready_reg <= ready_next;
		rvalid_reg <= rvalid_next;
		prog_enable_reg <= prog_enable_next;
	end if;
end process;

process(S_AXI_BREADY, S_AXI_WDATA, S_AXI_WVALID, S_AXI_ARVALID, S_AXI_RREADY, state_reg, write_reg, prog_enable_reg, ready_reg, prog_done, output_reg, rvalid_reg)
begin
	prog_enable_next <= prog_enable_reg;
	write_next <= write_reg;
	ready_next <= ready_reg;
	output_next <= output_reg;
	state_next <= state_reg;
	rvalid_next <= rvalid_reg;
	
	if S_AXI_ARVALID = '1' and rvalid_reg = '0' then
		rvalid_next <= '1';
	end if;
	
	if S_AXI_RREADY = '1' and rvalid_reg = '1' then
		rvalid_next <= '0';
	end if;

	if S_AXI_WVALID = '1' and write_reg = '0' and ready_reg = '1' then
		write_next <= '1';
		
		if state_reg = XY0 then
			output_next.x0 <= signed(S_AXI_WDATA(VGAPOS_WIDTH-1 downto 0));
			output_next.color(16-VGAPOS_WIDTH-1 downto 0) <= unsigned(S_AXI_WDATA(15 downto VGAPOS_WIDTH));
			output_next.y0 <= signed(S_AXI_WDATA(VGAPOS_WIDTH-1+16 downto 16));
			output_next.color((16-VGAPOS_WIDTH)*2-1 downto 16-VGAPOS_WIDTH) <= unsigned(S_AXI_WDATA(31 downto 16+VGAPOS_WIDTH));
			state_next <= XY1;
		else
			output_next.x1 <= signed(S_AXI_WDATA(VGAPOS_WIDTH-1 downto 0));
			output_next.color(7 downto (16-VGAPOS_WIDTH)*2) <= unsigned(S_AXI_WDATA(14 downto VGAPOS_WIDTH));
			--output_next.color((16-VGAPOS_WIDTH)*3-1 downto (16-VGAPOS_WIDTH)*2) <= unsigned(S_AXI_WDATA(15 downto VGAPOS_WIDTH));
			output_next.y1 <= signed(S_AXI_WDATA(VGAPOS_WIDTH-1+16 downto 16));
			--output_next.color((16-VGAPOS_WIDTH)*4-1 downto (16-VGAPOS_WIDTH)*3) <= unsigned(S_AXI_WDATA(31 downto 16+VGAPOS_WIDTH));
			state_next <= XY0;
			prog_enable_next <= '1';
			ready_next <= '0';
		end if;
	end if;
	
	if S_AXI_BREADY = '1' and write_reg = '1' then
		write_next <= '0';
	end if;
	
	if ready_reg = '0' and prog_done = '1' then
		ready_next <= '1';
		prog_enable_next <= '0';
	end if;
end process;

end Behavioral;
