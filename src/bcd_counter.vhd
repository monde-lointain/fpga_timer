library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity bcd_counter is
  generic (
    c_cnt   : natural := 50000000; -- (100 MHz / 1) * 50% duty cycle
    cnt_max : natural := 10
  );
  port (
    rst : in    std_logic;                   -- Synchronous active high reset
    clk : in    std_logic;                   -- Clock signal
    bcd : out   std_logic_vector(3 downto 0) -- BCD code
  );
end entity bcd_counter;

architecture behavioral of bcd_counter is

  signal en : std_logic := '0'; -- Enable signal for counter

  component enable_generator is
    generic (
      c_cnt : natural
    );
    port (
      rst : in    std_logic;
      clk : in    std_logic;
      en  : out   std_logic
    );
  end component enable_generator;

  component counter is
    generic (
      cnt_max : natural
    );
    port (
      rst : in    std_logic;
      en  : in    std_logic;
      clk : in    std_logic;
      bcd : out   std_logic_vector(3 downto 0)
    );
  end component counter;

begin

  clk_gen : component enable_generator
    generic map (
      c_cnt => c_cnt
    )
    port map (
      rst => rst,
      clk => clk,
      en  => en
    );

  bcd_count : component counter
    generic map (
      cnt_max => cnt_max
    )
    port map (
      rst => rst,
      en  => en,
      clk => clk,
      bcd => bcd
    );

end architecture behavioral;
