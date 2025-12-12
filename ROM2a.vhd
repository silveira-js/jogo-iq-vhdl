library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM2a is
port(
      address: in  std_logic_vector(3 downto 0);
      output : out std_logic_vector(14 downto 0)
);
end ROM2a;

architecture arc_ROM2a of ROM2a is
begin

--         EDCBA9876543210                       round
output <= "100100010010001" when address = "0000" else  -- {0,4,7,B,E}
          "011000100100010" when address = "0001" else  -- {1,5,8,C,D}
          "100011001000100" when address = "0010" else  -- {2,6,9,A,E}
          "001100100011000" when address = "0011" else  -- {3,4,8,B,C}
          "010001000100101" when address = "0100" else  -- {0,2,5,9,D}
          "100010001001010" when address = "0101" else  -- {1,3,6,A,E}
          "101001010000001" when address = "0110" else  -- {0,7,9,C,E}
          "010010100010100" when address = "0111" else  -- {2,4,8,A,D}
          "100100010100010" when address = "1000" else  -- {1,5,7,B,E}
          "001001001001001" when address = "1001" else  -- {0,3,6,9,C}
          "010100100100100" when address = "1010" else  -- {2,5,8,B,D}
          "100010011001000" when address = "1011" else  -- {3,6,7,A,E}
          "001000101010001" when address = "1100" else  -- {0,4,6,8,C}
          "010001010000110" when address = "1101" else  -- {1,2,7,9,D}
          "101000100101000" when address = "1110" else  -- {3,5,8,C,E}
          "000110000010101";                            -- {0,2,4,A,B}

end arc_ROM2a;
