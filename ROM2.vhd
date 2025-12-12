library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM2 is
port(
      address: in  std_logic_vector(3 downto 0);
      output : out std_logic_vector(31 downto 0)
);
end ROM2;

architecture arc_ROM2 of ROM2 is
begin

--         HEX7   HEX6   HEX5   HEX4   HEX3   HEX2   HEX1   HEX0                 round
--         (dígitos e "1111" = desligado)

output <= "1110" & "1111" & "0100" & "1111" & "1011" & "0111" & "1111" & "0000" when address = "0000" else
--         E       des    4      des    B      7      des    0    -- {0,4,7,B,E}

          "1111" & "0001" & "1111" & "0101" & "1000" & "1111" & "1100" & "1101" when address = "0001" else
--         des      1     des     5      8     des     C      D    -- {1,5,8,C,D}

          "0010" & "1111" & "0110" & "1001" & "1111" & "1010" & "1110" & "1111" when address = "0010" else
--         2       des    6      9      des     A      E      des  -- {2,6,9,A,E}

          "1111" & "0011" & "0100" & "1111" & "1000" & "1011" & "1111" & "1100" when address = "0011" else
--         des      3     4      des     8      B      des     C   -- {3,4,8,B,C}

          "1101" & "0000" & "1111" & "0010" & "0101" & "1111" & "1001" & "1111" when address = "0100" else
--         D        0     des     2      5     des     9      des  -- {0,2,5,9,D}

          "0001" & "1111" & "0011" & "0110" & "1111" & "1010" & "1111" & "1110" when address = "0101" else
--         1       des    3      6      des     A      des     E   -- {1,3,6,A,E}

          "1111" & "0000" & "0111" & "1111" & "1001" & "1100" & "1110" & "1111" when address = "0110" else
--         des      0     7      des     9      C      E      des  -- {0,7,9,C,E}

          "0010" & "0100" & "1111" & "1000" & "1111" & "1010" & "1111" & "1101" when address = "0111" else
--         2        4     des     8      des     A      des     D  -- {2,4,8,A,D}

          "1110" & "1111" & "0001" & "0101" & "1111" & "0111" & "1011" & "1111" when address = "1000" else
--         E       des    1      5      des     7      B      des  -- {1,5,7,B,E}

          "0000" & "1111" & "1111" & "0011" & "0110" & "1001" & "1111" & "1100" when address = "1001" else
--         0       des    des     3      6      9      des     C   -- {0,3,6,9,C}

          "1111" & "0010" & "0101" & "1111" & "1000" & "1011" & "1101" & "1111" when address = "1010" else
--         des      2     5      des     8      B      D      des  -- {2,5,8,B,D}

          "0011" & "0110" & "1111" & "0111" & "1111" & "1010" & "1110" & "1111" when address = "1011" else
--         3        6     des     7      des     A      E      des  -- {3,6,7,A,E}

          "1111" & "0000" & "0100" & "0110" & "1111" & "1000" & "1100" & "1111" when address = "1100" else
--         des      0     4      6      des     8      C      des  -- {0,4,6,8,C}

          "0001" & "1111" & "0010" & "0111" & "1111" & "1001" & "1111" & "1101" when address = "1101" else
--         1       des    2      7      des     9      des     D   -- {1,2,7,9,D}

          "1111" & "0011" & "0101" & "1111" & "1000" & "1111" & "1100" & "1110" when address = "1110" else
--         des      3     5      des     8      des     C      E   -- {3,5,8,C,E}

          "0000" & "0010" & "1111" & "0100" & "1010" & "1111" & "1011" & "1111" when address = "1111";
--         0        2     des     4      A      des     B      des  -- {0,2,4,A,B}

end arc_ROM2;
