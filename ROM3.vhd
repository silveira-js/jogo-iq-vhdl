library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM3 is
port(
      address: in  std_logic_vector(3 downto 0);
      output : out std_logic_vector(31 downto 0)
);
end ROM3;

architecture arc_ROM3 of ROM3 is
begin

--         HEX7   HEX6   HEX5   HEX4   HEX3   HEX2   HEX1   HEX0                 round
--         (dígitos; "1111" = desligado)

output <= "1110" & "1111" & "0000" & "1000" & "0011" & "1111" & "0101" & "1100" when address = "0000" else
--         E       des    0      8      3      des    5      C    -- {0,3,5,8,C,E}

          "1111" & "0001" & "0100" & "0110" & "1111" & "1001" & "1011" & "1101" when address = "0001" else
--         des      1      4      6      des    9      B      D    -- {1,4,6,9,B,D}

          "0010" & "0101" & "1111" & "0111" & "1010" & "1100" & "1111" & "1110" when address = "0010" else
--         2        5      des    7      A      C      des    E    -- {2,5,7,A,C,E}

          "1011" & "0100" & "1000" & "1111" & "1101" & "1110" & "0000" & "1111" when address = "0011" else
--         B        4      8      des    D      E      0      des  -- {0,4,8,B,D,E}

          "0001" & "1111" & "0011" & "0110" & "1001" & "1111" & "1100" & "1110" when address = "0100" else
--         1        des    3      6      9      des    C      E    -- {1,3,6,9,C,E}

          "0010" & "0100" & "1111" & "0111" & "1111" & "1010" & "1011" & "1101" when address = "0101" else
--         2        4      des    7      des    A      B      D    -- {2,4,7,A,B,D}

          "1111" & "0000" & "0010" & "0101" & "1000" & "1010" & "1111" & "1100" when address = "0110" else
--         des      0      2      5      8      A      des    C    -- {0,2,5,8,A,C}

          "0001" & "0011" & "0110" & "1111" & "1001" & "1111" & "1011" & "1101" when address = "0111" else
--         1        3      6      des    9      des    B      D    -- {1,3,6,9,B,D}

          "0000" & "0011" & "1111" & "0111" & "1010" & "1100" & "1101" & "1111" when address = "1000" else
--         0        3      des    7      A      C      D      des  -- {0,3,7,A,C,D}

          "1111" & "0010" & "0100" & "0110" & "1111" & "1000" & "1011" & "1110" when address = "1001" else
--         des      2      4      6      des    8      B      E    -- {2,4,6,8,B,E}

          "0001" & "1111" & "0101" & "0111" & "1001" & "1100" & "1111" & "1101" when address = "1010" else
--         1        des    5      7      9      C      des    D    -- {1,5,7,9,C,D}

          "0000" & "0010" & "0100" & "1111" & "0111" & "1111" & "1011" & "1110" when address = "1011" else
--         0        2      4      des    7      des    B      E    -- {0,2,4,7,B,E}

          "1111" & "0011" & "0101" & "1000" & "1111" & "1010" & "1100" & "1110" when address = "1100" else
--         des      3      5      8      des    A      C      E    -- {3,5,8,A,C,E}

          "0001" & "0100" & "1111" & "0110" & "1000" & "1101" & "1110" & "1111" when address = "1101" else
--         1        4      des    6      8      D      E      des  -- {1,4,6,8,D,E}

          "0010" & "1111" & "0101" & "1111" & "0111" & "1001" & "1011" & "1100" when address = "1110" else
--         2        des    5      des    7      9      B      C    -- {2,5,7,9,B,C}

          "0000" & "1111" & "0011" & "0101" & "1111" & "0111" & "1010" & "1101" when address = "1111";
--         0        des    3      5      des    7      A      D    -- {0,3,5,7,A,D}

end arc_ROM3;
