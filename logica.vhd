library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity logica is 
    port(
        round, bonus: in std_logic_vector(3 downto 0);
        nivel: in std_logic_vector(1 downto 0);
        points: out std_logic_vector(7 downto 0)
    );
end entity;

architecture rtl of logica is
begin

    process(round, bonus, nivel)
        variable L      : unsigned(1 downto 0);
        variable B      : unsigned(3 downto 0);
        variable X      : unsigned(3 downto 0);

        variable B_div2 : unsigned(3 downto 0);
        variable X_div4 : unsigned(3 downto 0);

        variable term_L : unsigned(7 downto 0);
        variable term_B : unsigned(7 downto 0);
        variable term_X : unsigned(7 downto 0);
        variable res    : unsigned(7 downto 0);
    begin
        L := unsigned(nivel); 
        B := unsigned(bonus);
        X := unsigned(round);

        B_div2 := shift_right(B, 1); 
        X_div4 := shift_right(X, 2);

        term_L := resize(L, 8) sll 5;

        term_B := resize(B_div2, 8) sll 2;

        term_X := resize(X_div4, 8);

        res := term_L + term_B + term_X;

        points <= std_logic_vector(res);
    end process;

end architecture;
