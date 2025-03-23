library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity bcd_counter_tb is
end entity bcd_counter_tb;

architecture behavioral of bcd_counter_tb is

  -- Constants
  constant clk_period : time    := 10 ns;
  constant c_cnt      : natural := 10;
  constant cnt_max    : natural := 10;

  -- Test signals
  signal rst : std_logic := '0';
  signal clk : std_logic := '0';
  signal bcd : std_logic_vector(3 downto 0);

  -- Component declaration for the Unit Under Test (UUT)
  component bcd_counter is
    generic (
      c_cnt   : natural := 50000000;
      cnt_max : natural := 10
    );
    port (
      rst : in    std_logic;
      clk : in    std_logic;
      bcd : out   std_logic_vector(3 downto 0)
    );
  end component bcd_counter;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut : component bcd_counter
    generic map (
      c_cnt   => c_cnt,
      cnt_max => cnt_max
    )
    port map (
      rst => rst,
      clk => clk,
      bcd => bcd
    );

  -- Clock generation
  clk_process : process is
  begin

    while true loop

      wait for clk_period / 2;
      clk <= not clk;

    end loop;

  end process clk_process;

  -- Stimulus process
  stim_proc : process is
  begin

    -- Reset sequence
    rst <= '1';
    wait for 2 * clk_period;
    rst <= '0';

    -- Let the counter run for a full cycle
    for i in 0 to (cnt_max * c_cnt + 1) loop

      wait until rising_edge(clk);

    end loop;

    -- Verify BCD reset after reaching count max
    assert bcd = "0000"
      report "Counter did not reset after reaching max count"
      severity error;

    report "Testbench completed successfully."
      severity note;

    assert false
      report ""
      severity failure;

  end process stim_proc;

end architecture behavioral;
