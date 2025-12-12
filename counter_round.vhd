library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


entity counter_round is
    port(
        R    : in  std_logic;
        E    : in  std_logic;
        clock: in  std_logic;
        Q    : out std_logic_vector(3 downto 0);
        tc   : out std_logic
    );
end entity;

architecture rtl of counter_round is
    signal count_reg : std_logic_vector(3 downto 0);
begin

    process(clock, R)
    begin
        if R = '1' then
            count_reg <= (others => '0');
        elsif rising_edge(clock) then
            if E = '1' then
                count_reg <= count_reg + 1;
            end if;
        end if;
    end process;

    Q <= count_reg;

    tc <= '1' when count_reg = "1111" else '0';

end architecture rtl;
