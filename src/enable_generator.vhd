library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity enable_generator is
  generic (
    c_cnt : natural := 50000000 -- (100 MHz / 1) * 50% duty cycle
  );
  port (
    rst : in    std_logic; -- Synchronous active high reset
    clk : in    std_logic; -- Clock signal
    en  : out   std_logic  -- Enable signal
  );
end entity enable_generator;

architecture behavioral of enable_generator is

  signal counter : natural range 0 to c_cnt;

begin

  process (clk) is
  begin

    if rising_edge(clk) then
      if (rst = '1') then
        en      <= '0';
        counter <= 0;
      else
        en      <= '0';
        counter <= counter + 1;
        if (counter = c_cnt - 1) then
          en      <= '1';
          counter <= 0;
        end if;
      end if;
    end if;

  end process;

end architecture behavioral;
