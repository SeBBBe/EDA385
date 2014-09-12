-------------------------------------------------------------------------------
-- system_fsl_hwa_1_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library fsl_hwa_v1_00_c;
use fsl_hwa_v1_00_c.all;

entity system_fsl_hwa_1_wrapper is
  port (
    fsl_clk : in std_logic;
    fsl_rst : in std_logic;
    fsl_s_clk : out std_logic;
    fsl_s_read : out std_logic;
    fsl_s_data : in std_logic_vector(0 to 31);
    fsl_s_control : in std_logic;
    fsl_s_exists : in std_logic;
    fsl_m_clk : out std_logic;
    fsl_m_write : out std_logic;
    fsl_m_data : out std_logic_vector(0 to 31);
    fsl_m_control : out std_logic;
    fsl_m_full : in std_logic
  );
end system_fsl_hwa_1_wrapper;

architecture STRUCTURE of system_fsl_hwa_1_wrapper is

  component fsl_hwa is
    generic (
      C_FSL_DWIDTH : integer;
      C_EXT_RESET_HIGH : integer
    );
    port (
      fsl_clk : in std_logic;
      fsl_rst : in std_logic;
      fsl_s_clk : out std_logic;
      fsl_s_read : out std_logic;
      fsl_s_data : in std_logic_vector(0 to 31);
      fsl_s_control : in std_logic;
      fsl_s_exists : in std_logic;
      fsl_m_clk : out std_logic;
      fsl_m_write : out std_logic;
      fsl_m_data : out std_logic_vector(0 to 31);
      fsl_m_control : out std_logic;
      fsl_m_full : in std_logic
    );
  end component;

begin

  fsl_hwa_1 : fsl_hwa
    generic map (
      C_FSL_DWIDTH => 32,
      C_EXT_RESET_HIGH => 1
    )
    port map (
      fsl_clk => fsl_clk,
      fsl_rst => fsl_rst,
      fsl_s_clk => fsl_s_clk,
      fsl_s_read => fsl_s_read,
      fsl_s_data => fsl_s_data,
      fsl_s_control => fsl_s_control,
      fsl_s_exists => fsl_s_exists,
      fsl_m_clk => fsl_m_clk,
      fsl_m_write => fsl_m_write,
      fsl_m_data => fsl_m_data,
      fsl_m_control => fsl_m_control,
      fsl_m_full => fsl_m_full
    );

end architecture STRUCTURE;

