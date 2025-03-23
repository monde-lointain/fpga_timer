library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity enable_generator_tb is
end entity enable_generator_tb;

architecture behavioral of enable_generator_tb is

  -- Constants
  constant clk_period : time    := 10 ns;
  constant c_cnt      : natural := 10;

  -- Test signals
  signal rst : std_logic := '0';
  signal clk : std_logic := '0';
  signal en  : std_logic;

  -- Component declaration for the Unit Under Test (UUT)
  component enable_generator is
    generic (
      c_cnt : natural := 50000000
    );
    port (
      rst : in    std_logic;
      clk : in    std_logic;
      en  : out   std_logic
    );
  end component enable_generator;

begin

  -- Instantiate the Unit Under Test (UUT)
  uut : component enable_generator
    generic map (
      c_cnt => c_cnt
    )
    port map (
      rst => rst,
      clk => clk,
      en  => en
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

    variable enable_count : integer := 0;

  begin

    -- Wait for a few enable pulses
    for i in 0 to (3 * c_cnt) loop

      wait until rising_edge(clk);

      if (en = '1') then
        enable_count := enable_count + 1;
      end if;

    end loop;

    -- Check if enable pulses occur at the right count intervals
    assert enable_count = 3
      report "Test failed: Expected 3 enable pulses, got " & integer'image(enable_count)
      severity error;

    assert false
      report "Simulation finished."
      severity failure;

  end process stim_proc;

end architecture behavioral;
