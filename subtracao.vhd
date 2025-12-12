library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity subtracao is
    port(
        E0: in std_logic_vector(3 downto 0);
        E1: in std_logic_vector(3 downto 0);
        resultado: out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of subtracao is
begin
    process(E0, E1)
        variable a, b : unsigned(3 downto 0);
        variable r    : unsigned(3 downto 0);
    begin
        a := unsigned(E0);
        b := unsigned(E1);

        if b >= a then
            r := (others => '0');      -- satura em 0
        else
            r := a - b;
        end if;

        resultado <= std_logic_vector(r);
    end process;
end architecture;
