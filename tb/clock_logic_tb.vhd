library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity clock_logic_tb is
end entity clock_logic_tb;

architecture behavioral of clock_logic_tb is

  constant clk_period  : time    := 10 ns;
  constant c_cnt_100hz : natural := 5;
  constant an3_max     : natural := 6;
  constant an0_2_max   : natural := 10;

  signal rst       : std_logic := '0';
  signal clk       : std_logic := '0';
  signal bcd_10s   : std_logic_vector(3 downto 0);
  signal bcd_1s    : std_logic_vector(3 downto 0);
  signal bcd_100ms : std_logic_vector(3 downto 0);
  signal bcd_10ms  : std_logic_vector(3 downto 0);

  component clock_logic is
    generic (
      constant c_cnt_100hz : natural := 5;
      constant c_cnt_10hz  : natural := 50;
      constant c_cnt_1hz   : natural := 500;
      constant c_cnt_0_1hz : natural := 5000
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

begin

  uut : component clock_logic
    port map (
      rst       => rst,
      clk       => clk,
      bcd_10s   => bcd_10s,
      bcd_1s    => bcd_1s,
      bcd_100ms => bcd_100ms,
      bcd_10ms  => bcd_10ms
    );

  clk_process : process is
  begin

    wait for clk_period / 2;
    clk <= not clk;

  end process clk_process;

  stimulus_process : process is
  begin

    for i in 0 to an3_max + 3 loop

      for j in 0 to an0_2_max - 1 loop

        for k in 0 to an0_2_max - 1 loop

          for l in 0 to an0_2_max - 1 loop

            for m in 0 to c_cnt_100hz - 1 loop

              wait until rising_edge(clk);

            end loop;

          end loop;

        end loop;

      end loop;

    end loop;

    wait for 530 ns;

    rst <= '1';

    wait for 100 ns;

    assert (bcd_10s = "0000" and bcd_1s = "0000" and bcd_100ms = "0000" and bcd_10ms = "0000")
      report "Signals did not reset."
      severity error;

    rst <= '0';

    wait for 536 us;

    assert false
      report "Simulation finished."
      severity failure;

  end process stimulus_process;

end architecture behavioral;
