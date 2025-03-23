library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity counter is
  generic (
    cnt_max : natural := 10
  );
  port (
    rst : in    std_logic; -- Synchronous active high reset
    en  : in    std_logic; -- Synchronous active high enable
    clk : in    std_logic; -- Clock signal
    bcd : out   std_logic_vector(3 downto 0) -- BCD code
  );
end entity counter;

architecture behavioral of counter is

  signal count : natural range 0 to cnt_max - 1 := 0;

begin

  process (clk) is
  begin

    if rising_edge(clk) then
      if (rst = '1') then
        count <= 0;
      elsif (en = '1') then
        count <= count + 1;
        if (count = cnt_max - 1) then
          count <= 0;
        end if;
      end if;
    end if;

  end process;

  bcd <= std_logic_vector(to_unsigned(count, bcd'length));

end architecture behavioral;
