library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity bcd_to_7_seg is
  port (
    bcd : in    std_logic_vector(3 downto 0); -- BCD code
    seg : out   std_logic_vector(6 downto 0) -- Segments
  );
end entity bcd_to_7_seg;

architecture behavioral of bcd_to_7_seg is

begin

  process (bcd) is
  begin

    case bcd is

      when "0000" =>

        seg <= "1000000";

      when "0001" =>

        seg <= "1111001";

      when "0010" =>

        seg <= "0100100";

      when "0011" =>

        seg <= "0110000";

      when "0100" =>

        seg <= "0011001";

      when "0101" =>

        seg <= "0010010";

      when "0110" =>

        seg <= "0000010";

      when "0111" =>

        seg <= "1111000";

      when "1000" =>

        seg <= "0000000";

      when "1001" =>

        seg <= "0010000";

      when others =>

        seg <= "1111111";

    end case;

  end process;

end architecture behavioral;
