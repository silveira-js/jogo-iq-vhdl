library ieee;
use ieee.std_logic_1164.all;

entity mux4x1_1bit is
    port(
        E0, E1, E2, E3 : in  std_logic;
        sel            : in  std_logic_vector(1 downto 0);
        saida          : out std_logic
    );
end mux4x1_1bit;

architecture comb of mux4x1_1bit is
begin
    with sel select
        saida <= E0 when "00",
                 E1 when "01",
                 E2 when "10",
                 E3 when "11",
                 '0' when others;
end comb;
