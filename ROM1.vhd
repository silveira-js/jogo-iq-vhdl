library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM1 is
port(
      address: in  std_logic_vector(3 downto 0);
      output : out std_logic_vector(31 downto 0)
);
end ROM1;

architecture arc_ROM1 of ROM1 is
begin

--         HEX7   HEX6   HEX5   HEX4   HEX3   HEX2   HEX1   HEX0                 round
--         (dígitos e '1111' = des)

output <= "0000" & "1111" & "0001" & "1111" & "0010" & "1111" & "0011" & "1111" when address = "0000" else
--         0       des    1      des    2      des    3      des

          "1111" & "0100" & "1111" & "0101" & "1111" & "0110" & "1111" & "0111" when address = "0001" else
--         des      4     des     5     des     6     des     7

          "1000" & "1001" & "1111" & "1010" & "1111" & "1011" & "1111" & "1111" when address = "0010" else
--         8        9     des     A     des     B     des     des

          "1111" & "1111" & "1100" & "1111" & "1101" & "1111" & "1110" & "0000" when address = "0011" else
--         des      des    C      des    D      des    E      0

          "0001" & "1111" & "1111" & "0011" & "1111" & "1111" & "0101" & "0111" when address = "0100" else
--         1        des    des     3     des    des    5      7

          "1111" & "0010" & "0100" & "1111" & "1111" & "0110" & "1000" & "1111" when address = "0101" else
--         des      2      4      des    des     6     8      des

          "1001" & "1111" & "1111" & "1111" & "1011" & "1101" & "1111" & "0000" when address = "0110" else
--         9        des    des    des    B      D      des    0

          "1111" & "1010" & "1111" & "1100" & "1110" & "1111" & "0001" & "1111" when address = "0111" else
--         des      A     des      C     E      des    1      des

          "0010" & "0101" & "1111" & "1111" & "1111" & "1111" & "1000" & "1011" when address = "1000" else
--         2        5     des     des    des    des    8      B

          "1111" & "1111" & "0011" & "0110" & "1111" & "1001" & "1111" & "1100" when address = "1001" else
--         des      des    3      6      des     9     des     C

          "0100" & "1111" & "0111" & "1111" & "1111" & "1010" & "1101" & "1111" when address = "1010" else
--         4        des    7      des    des     A     D      des

          "1111" & "0101" & "1111" & "1111" & "1000" & "1111" & "1011" & "1110" when address = "1011" else
--         des      5     des     des    8      des    B      E

          "0110" & "1111" & "1111" & "1001" & "1100" & "0000" & "1111" & "1111" when address = "1100" else
--         6        des    des     9     C      0      des    des

          "1111" & "0111" & "1010" & "1101" & "1111" & "1111" & "0001" & "1111" when address = "1101" else
--         des      7     A       D     des    des    1      des

          "1000" & "1011" & "1111" & "1111" & "1111" & "1110" & "1111" & "0010" when address = "1110" else
--         8        B     des     des    des     E     des    2

          "1111" & "1111" & "1001" & "1111" & "1100" & "0000" & "0011" & "1111" when address = "1111";
--         des      des    9      des    C      0      3      des

end arc_ROM1;
