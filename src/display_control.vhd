library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity display_control is
  port (
    clk       : in    std_logic;                    -- Clock signal
    bcd_10s   : in    std_logic_vector(3 downto 0); -- BCD code for the 10s digit
    bcd_1s    : in    std_logic_vector(3 downto 0); -- BCD code for the 1s digit
    bcd_100ms : in    std_logic_vector(3 downto 0); -- BCD code for the 100ms digit
    bcd_10ms  : in    std_logic_vector(3 downto 0); -- BCD code for the 10ms digit
    an        : out   std_logic_vector(3 downto 0); -- Counters
    seg       : out   std_logic_vector(6 downto 0); -- Segments
    dp        : out   std_logic                     -- Decimal point segment
  );
end entity display_control;

architecture behavioral of display_control is

  signal count         : unsigned(19 downto 0); -- 20 bit counter
  signal display_index : unsigned(1 downto 0);  -- The 7-segment display to update
  signal bcd           : std_logic_vector(3 downto 0);

  component bcd_to_7_seg is
    port (
      bcd : in    std_logic_vector(3 downto 0);
      seg : out   std_logic_vector(6 downto 0)
    );
  end component bcd_to_7_seg;

begin

  -- The 4 seven segment displays must be updated separately within the update 
  -- period. The update period can be between 1 and 20ms. We use a 20 bit
  -- counter here to generate a period of (2^19) * (1/100MHz) = 5.2ms.
  process (clk) is
  begin

    if rising_edge(clk) then
      count <= count + 1;
    end if;

  end process;

  display_index <= count(19 downto 18); -- Select 2 MSB of counter to divide

  process (clk) is
  begin

    if rising_edge(clk) then

      case (display_index) is

        when "00" =>

          an  <= "1110";
          bcd <= bcd_10ms;
          dp  <= '1';

        when "01" =>

          an  <= "1101";
          bcd <= bcd_100ms;
          dp  <= '1';

        when "10" =>

          an  <= "1011";
          bcd <= bcd_1s;
          dp  <= '0';

        when "11" =>

          an  <= "0111";
          bcd <= bcd_10s;
          dp  <= '1';

      end case;

    end if;

  end process;

  decoder : component bcd_to_7_seg
    port map (
      bcd => bcd,
      seg => seg
    );

end architecture behavioral;
