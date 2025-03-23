library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity top is
  generic (
    c_cnt   : natural := 100000000; -- (100 MHz / 1)
    cnt_max : natural := 10
  );
  port (
    rst : in    std_logic; -- Synchronous active high reset
    clk : in    std_logic; -- Clock signal
    an  : out   std_logic_vector(3 downto 0); -- Counters
    seg : out   std_logic_vector(6 downto 0); -- Segments
    dp  : out   std_logic
  );
end entity top;

architecture behavioral of top is

  signal bcd_10s   : std_logic_vector(3 downto 0); -- BCD code for the 10s digit
  signal bcd_1s    : std_logic_vector(3 downto 0);-- BCD code for the 1s digit
  signal bcd_100ms : std_logic_vector(3 downto 0);-- BCD code for the 100ms digit
  signal bcd_10ms  : std_logic_vector(3 downto 0);-- BCD code for the 10ms digit

  component clock_logic is
    generic (
      constant c_cnt_100hz : natural := 1000000;
      constant c_cnt_10hz  : natural := 10000000;
      constant c_cnt_1hz   : natural := 100000000;
      constant c_cnt_0_1hz : natural := 1000000000
    );
    port (
      rst       : in    std_logic;
      clk       : in    std_logic;
      bcd_10s   : out   std_logic_vector(3 downto 0);
      bcd_1s    : out   std_logic_vector(3 downto 0);
      bcd_100ms : out   std_logic_vector(3 downto 0);
      bcd_10ms  : out   std_logic_vector(3 downto 0)
    );
  end component clock_logic;

  component display_control is
    port (
      clk       : in    std_logic;
      bcd_10s   : in    std_logic_vector(3 downto 0);
      bcd_1s    : in    std_logic_vector(3 downto 0);
      bcd_100ms : in    std_logic_vector(3 downto 0);
      bcd_10ms  : in    std_logic_vector(3 downto 0);
      an        : out   std_logic_vector(3 downto 0);
      seg       : out   std_logic_vector(6 downto 0);
      dp        : out   std_logic
    );
  end component display_control;

begin

  clock_block : component clock_logic
    port map (
      rst       => rst,
      clk       => clk,
      bcd_10s   => bcd_10s,
      bcd_1s    => bcd_1s,
      bcd_100ms => bcd_100ms,
      bcd_10ms  => bcd_10ms
    );

  display_ctrl : component display_control
    port map (
      clk       => clk,
      bcd_10s   => bcd_10s,
      bcd_1s    => bcd_1s,
      bcd_100ms => bcd_100ms,
      bcd_10ms  => bcd_10ms,
      an        => an,
      seg       => seg,
      dp        => dp
    );

end architecture behavioral;
