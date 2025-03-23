library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity counter_tb is
end entity counter_tb;

architecture behavioral of counter_tb is

  -- Constants
  constant clk_period : time    := 10 ns;
  constant cnt_max    : natural := 6;

  -- Test signals
  signal rst         : std_logic := '0';
  signal en          : std_logic := '0';
  signal clk         : std_logic := '0';
  signal bcd         : std_logic_vector(3 downto 0);
  signal partial_bcd : std_logic_vector(3 downto 0);

  -- Component declaration for the Unit Under Test (UUT)
  component counter is
    generic (
      cnt_max : natural := 10
    );
    port (
      rst : in    std_logic;
      en  : in    std_logic;
      clk : in    std_logic;
      bcd : out   std_logic_vector(3 downto 0)
    );
  end component counter;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut : component counter
    generic map (
      cnt_max => cnt_max
    )
    port map (
      rst => rst,
      en  => en,
      clk => clk,
      bcd => bcd
    );

  -- Clock generation
  clk_process : process is
  begin

    wait for clk_period / 2;
    clk <= not clk;

  end process clk_process;

  -- Stimulus process
  stim_proc : process is

    variable expected : std_logic_vector(3 downto 0);

  begin

    en <= '1';

    for i in 0 to (cnt_max + 1) loop

      wait until rising_edge(clk);
      wait for 1 ns;

      -- Check if counter rolls over after cnt_max cycles
      if (i mod cnt_max = cnt_max - 1) then
        assert bcd = "0000"
          report "Expected BCD output to reset to 0000 after " & integer'image(cnt_max) & " counts."
          severity error;
      else
        expected := std_logic_vector(to_unsigned((i + 1) mod cnt_max, bcd'length));
        assert (bcd = expected)
          report "Incorrect BCD output at count " & integer'image(i + 1) & ":" &
                 " expected=" & integer'image(to_integer(unsigned(expected))) &
                 ", actual=" & integer'image(to_integer(unsigned(bcd)))
          severity error;
      end if;

    end loop;

    -- Loop partially through a cycle
    for i in 0 to ((cnt_max / 2) - 1) loop

      wait until rising_edge(clk);

    end loop;

    wait for 1 ns;

    -- Capture the current BCD value at the partial stop
    partial_bcd <= bcd;

    wait for 1 ns;

    -- Disable counting
    en <= '0';

    wait for clk_period * 2;

    assert bcd = partial_bcd
      report "Counter changed when enable was low."
      severity error;

    -- Reset test
    rst <= '1';

    wait for clk_period;

    assert bcd = "0000"
      report "Counter did not reset."
      severity error;

    assert false
      report "Simulation finished."
      severity failure;

  end process stim_proc;

end architecture behavioral;
