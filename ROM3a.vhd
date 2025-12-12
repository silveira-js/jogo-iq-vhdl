library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM3a is
port(
      address: in  std_logic_vector(3 downto 0);
      output : out std_logic_vector(14 downto 0)
);
end ROM3a;

architecture arc_ROM3a of ROM3a is
begin

--         EDCBA9876543210                       round
output <= "101000100101001" when address = "0000" else  -- {0,3,5,8,C,E}
          "010101001010010" when address = "0001" else  -- {1,4,6,9,B,D}
          "101010010100100" when address = "0010" else  -- {2,5,7,A,C,E}
          "110100100010001" when address = "0011" else  -- {0,4,8,B,D,E}
          "101001001001010" when address = "0100" else  -- {1,3,6,9,C,E}
          "010110010010100" when address = "0101" else  -- {2,4,7,A,B,D}
          "001010100100101" when address = "0110" else  -- {0,2,5,8,A,C}
          "010101001001010" when address = "0111" else  -- {1,3,6,9,B,D}
          "011010010001001" when address = "1000" else  -- {0,3,7,A,C,D}
          "100100101010100" when address = "1001" else  -- {2,4,6,8,B,E}
          "011001010100010" when address = "1010" else  -- {1,5,7,9,C,D}
          "100100010010101" when address = "1011" else  -- {0,2,4,7,B,E}
          "101010100101000" when address = "1100" else  -- {3,5,8,A,C,E}
          "110000101010010" when address = "1101" else  -- {1,4,6,8,D,E}
          "001101010100100" when address = "1110" else  -- {2,5,7,9,B,C}
          "010010010101001" when address = "1111";      -- {0,3,5,7,A,D}

end arc_ROM3a;
