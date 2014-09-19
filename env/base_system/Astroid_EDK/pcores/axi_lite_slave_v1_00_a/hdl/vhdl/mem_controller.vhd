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
	 VECMEM : out vecmem_t
	 );
end mem_controller;

architecture Behavioral of mem_controller is

signal vecmem_reg : vecmem_t;
signal vecmem_next : vecmem_t;

signal write_reg : std_logic;
signal write_next : std_logic;

signal addr_reg : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
signal addr_next : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);

begin

S_AXI_ARREADY <= '1';
S_AXI_RVALID <= '1';
S_AXI_RDATA <= (others => '0') when VSYNC = '0' else (others => '1');
S_AXI_RRESP <= (others => '0');

S_AXI_AWREADY <= '1';
S_AXI_WREADY <= '1' when write_reg = '0' else '0';

S_AXI_BVALID <= write_reg;
S_AXI_BRESP <= (others => '0');

VECMEM <= vecmem_reg;

process(ACLK, ARESETN)
begin
	if (ARESETN = '0') then
		vecmem_reg <= (others => (others => '0'));
		write_reg <= '0';
		addr_reg <= (others => '0');
	elsif rising_edge(ACLK) then
		vecmem_reg <= vecmem_next;
		write_reg <= write_next;
		addr_reg <= addr_next;
	end if;
end process;

process(S_AXI_AWADDR, S_AXI_AWVALID, addr_reg)
begin
	addr_next <= addr_reg;
	
	if S_AXI_AWVALID = '1' then
		addr_next <= S_AXI_AWADDR;
	end if;
end process;

process(S_AXI_BREADY, S_AXI_AWADDR, S_AXI_AWVALID, S_AXI_WDATA, S_AXI_WSTRB, S_AXI_WVALID, vecmem_reg, addr_reg, write_reg)
	variable addr : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
	variable vecaddr : integer;
begin
	vecmem_next <= vecmem_reg;
	write_next <= write_reg;
	
	addr := addr_reg;

	if S_AXI_WVALID = '1' and write_reg = '0'	then
		if S_AXI_AWVALID = '1' then
			addr := S_AXI_AWADDR;
		end if;
		
		write_next <= '1';
		
		for I in 0 to (C_S_AXI_ADDR_WIDTH/8-1) loop
			if S_AXI_WSTRB(I) = '1' then
				vecaddr := to_integer(unsigned(addr)) + I;
				
				if vecaddr mod 2 = 0 then
					vecmem_next(vecaddr / 2)(7 downto 0) <= S_AXI_WDATA(((I + 1) * 8)-1 downto (I * 8));
				else
					vecmem_next(vecaddr / 2)(VGAPOS_WIDTH-1 downto 8) <= S_AXI_WDATA(((I + 1) * 8)-(16-VGAPOS_WIDTH)-1 downto (I * 8));
				end if;
			end if;
		end loop;
	end if;
	
	if S_AXI_BREADY = '1' and write_reg = '1' then
		write_next <= '0';
	end if;
end process;

end Behavioral;

