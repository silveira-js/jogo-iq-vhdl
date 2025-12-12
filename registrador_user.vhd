library IEEE;
use IEEE.std_logic_1164.all;

entity registrador_user is 
    port(
        R, E, clock: in std_logic;
        D: in std_logic_vector(14 downto 0);
        Q: out std_logic_vector(14 downto 0) 
    );
end entity;

architecture rtl of registrador_user is
    signal Q_reg : std_logic_vector(14 downto 0);
begin

    process(clock, R)
    begin
        if R = '1' then
            Q_reg <= (others => '0');
        elsif rising_edge(clock) then
            if E = '1' then
                Q_reg <= D;
            end if;
        end if;
    end process;

    Q <= Q_reg;

end architecture;
