library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM1a is
port(
      address: in  std_logic_vector(3 downto 0);
      output : out std_logic_vector(14 downto 0)
);
end ROM1a;

architecture arc_ROM1a of ROM1a is
begin

--         EDCBA9876543210                 round
output <= "000000000001111" when address = "0000" else  -- 0,1,2,3
          "000000011110000" when address = "0001" else  -- 4,5,6,7
          "000111100000000" when address = "0010" else  -- 8,9,A,B
          "111000000000001" when address = "0011" else  -- C,D,E,0
          "000000010101010" when address = "0100" else  -- 1,3,5,7
          "000000101010100" when address = "0101" else  -- 2,4,6,8
          "010101000000001" when address = "0110" else  -- 9,B,D,0
          "101010000000010" when address = "0111" else  -- A,C,E,1
          "000100100100100" when address = "1000" else  -- 2,5,8,B
          "001001001001000" when address = "1001" else  -- 3,6,9,C
          "010010010010000" when address = "1010" else  -- 4,7,A,D
          "100100100100000" when address = "1011" else  -- 5,8,B,E
          "001001001000001" when address = "1100" else  -- 6,9,C,0
          "010010010000010" when address = "1101" else  -- 7,A,D,1
          "100100100000100" when address = "1110" else  -- 8,B,E,2
          "001001000001001" when address = "1111";      -- 9,C,0,3

end arc_ROM1a;
