library ieee;
use ieee.std_logic_1164.all;

entity registrador_sel is 
    port(
        R, E, clock : in  std_logic;
        D           : in  std_logic_vector(3 downto 0);
        Q           : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of registrador_sel is
    signal reg_q : std_logic_vector(3 downto 0);
begin

    process(clock, R)
    begin
        if R = '1' then 
            reg_q <= (others => '0');
        elsif rising_edge(clock) then
            if E = '1' then
                reg_q <= D;
            end if;
        end if;
    end process;

    Q <= reg_q;

end architecture rtl;
