library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
-- se preferir numeric_std, dá pra ajustar depois, mas mantive std_logic_unsigned
-- porque já está sendo usado no datapath.

entity counter_round is
    port(
        R    : in  std_logic;                     -- reset assíncrono
        E    : in  std_logic;                     -- enable
        clock: in  std_logic;                     -- clock
        Q    : out std_logic_vector(3 downto 0);  -- valor da rodada (0..15)
        tc   : out std_logic                      -- terminal count (1 quando Q=15)
    );
end entity;

architecture rtl of counter_round is
    signal count_reg : std_logic_vector(3 downto 0);
begin

    ----------------------------------------------------------------
    -- Contador de 4 bits com reset assíncrono e enable
    ----------------------------------------------------------------
    process(clock, R)
    begin
        if R = '1' then
            count_reg <= (others => '0');        -- zera rodada
        elsif rising_edge(clock) then
            if E = '1' then
                count_reg <= count_reg + 1;      -- incrementa 1
            end if;
        end if;
    end process;

    Q <= count_reg;

    ----------------------------------------------------------------
    -- tc = '1' quando chega em 15 (1111)
    ----------------------------------------------------------------
    tc <= '1' when count_reg = "1111" else '0';

end architecture rtl;
