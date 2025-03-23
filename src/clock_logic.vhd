library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity clock_logic is
  generic (
    constant c_cnt_100hz : natural := 1000000;   -- (100 MHz / 100)
    constant c_cnt_10hz  : natural := 10000000;  -- (100 MHz / 10)
    constant c_cnt_1hz   : natural := 100000000; -- (100 MHz / 1)
    constant c_cnt_0_1hz : natural := 1000000000 -- 100 MHz / 0.1
  );
  port (
    rst       : in    std_logic;                    -- Clock signal
    clk       : in    std_logic;                    -- Clock signal
    bcd_10s   : out   std_logic_vector(3 downto 0); -- BCD code for the 10s digit
    bcd_1s    : out   std_logic_vector(3 downto 0); -- BCD code for the 1s digit
    bcd_100ms : out   std_logic_vector(3 downto 0); -- BCD code for the 100ms digit
    bcd_10ms  : out   std_logic_vector(3 downto 0)  -- BCD code for the 10ms digit
  );
end entity clock_logic;

architecture behavioral of clock_logic is

  component bcd_counter is
    generic (
      c_cnt   : natural;
      cnt_max : natural
    );
    port (
      rst : in    std_logic;
      clk : in    std_logic;
      bcd : out   std_logic_vector(3 downto 0)
    );
  end component bcd_counter;

begin

  -- Use a separate counter with enable generator to drive each digit. That way
  -- we can have the circuit driven solely by the good main clock.

  -- 10ms digit (0-9)
  counter_100hz : component bcd_counter
    generic map (
      c_cnt   => c_cnt_100hz,
      cnt_max => 10
    )
    port map (
      rst => rst,
      clk => clk,
      bcd => bcd_10ms
    );

  -- 100ms digit (0-9)
  counter_10hz : component bcd_counter
    generic map (
      c_cnt   => c_cnt_10hz,
      cnt_max => 10
    )
    port map (
      rst => rst,
      clk => clk,
      bcd => bcd_100ms
    );

  -- 1s digit (0-9)
  counter_1hz : component bcd_counter
    generic map (
      c_cnt   => c_cnt_1hz,
      cnt_max => 10
    )
    port map (
      rst => rst,
      clk => clk,
      bcd => bcd_1s
    );

  -- 10s digit (0-5)
  counter_0_1hz : component bcd_counter
    generic map (
      c_cnt   => c_cnt_0_1hz,
      cnt_max => 6
    )
    port map (
      rst => rst,
      clk => clk,
      bcd => bcd_10s
    );

end architecture behavioral;
