-------------------------------------------------------------------------------
-- system_stub.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity system_stub is
  port (
    RS232_Uart_1_sout : out std_logic;
    RS232_Uart_1_sin : in std_logic;
    RESET : in std_logic;
    Push_Buttons_4Bits_TRI_I : in std_logic_vector(0 to 3);
    GCLK : in std_logic;
    DIP_Switches_8Bits_TRI_I : in std_logic_vector(7 downto 0);
    VGA_HSYNC : out std_logic;
    VGA_VSYNC : out std_logic;
    VGA_RED : out std_logic_vector(2 downto 0);
    VGA_GREEN : out std_logic_vector(2 downto 0);
    JA : out std_logic_vector(7 downto 0);
    VGA_BLUE : out std_logic_vector(1 downto 0)
  );
end system_stub;

architecture STRUCTURE of system_stub is

  component system is
    port (
      RS232_Uart_1_sout : out std_logic;
      RS232_Uart_1_sin : in std_logic;
      RESET : in std_logic;
      Push_Buttons_4Bits_TRI_I : in std_logic_vector(0 to 3);
      GCLK : in std_logic;
      DIP_Switches_8Bits_TRI_I : in std_logic_vector(7 downto 0);
      VGA_HSYNC : out std_logic;
      VGA_VSYNC : out std_logic;
      VGA_RED : out std_logic_vector(2 downto 0);
      VGA_GREEN : out std_logic_vector(2 downto 0);
      JA : out std_logic_vector(7 downto 0);
      VGA_BLUE : out std_logic_vector(1 downto 0)
    );
  end component;

  attribute BOX_TYPE : STRING;
  attribute BOX_TYPE of system : component is "user_black_box";

begin

  system_i : system
    port map (
      RS232_Uart_1_sout => RS232_Uart_1_sout,
      RS232_Uart_1_sin => RS232_Uart_1_sin,
      RESET => RESET,
      Push_Buttons_4Bits_TRI_I => Push_Buttons_4Bits_TRI_I,
      GCLK => GCLK,
      DIP_Switches_8Bits_TRI_I => DIP_Switches_8Bits_TRI_I,
      VGA_HSYNC => VGA_HSYNC,
      VGA_VSYNC => VGA_VSYNC,
      VGA_RED => VGA_RED,
      VGA_GREEN => VGA_GREEN,
      JA => JA,
      VGA_BLUE => VGA_BLUE
    );

end architecture STRUCTURE;
