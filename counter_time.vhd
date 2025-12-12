library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity counter_time is
    port(
        R     : in  std_logic;   
        E     : in  std_logic;
        clock : in  std_logic;
        Q     : out std_logic_vector(3 downto 0);
        tc    : out std_logic
    );
end entity;

architecture behav of counter_time is
    signal Q_reg : std_logic_vector(3 downto 0) := "1010";
begin

    process(clock, R)
    begin
        if R = '1' then
            Q_reg <= "1010";
        elsif rising_edge(clock) then
            if E = '1' then
                if Q_reg = "0000" then
                    Q_reg <= "0000";
                else
                    Q_reg <= Q_reg - 1;
                end if;
            end if;
        end if;
    end process;

    Q  <= Q_reg;
    tc <= '1' when (Q_reg = "0000" and E = '1') else '0';

end architecture;
