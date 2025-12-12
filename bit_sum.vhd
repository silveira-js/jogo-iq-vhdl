library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bit_sum is
    port (
        entrada : in  std_logic_vector(14 downto 0);
        soma    : out std_logic_vector(3 downto 0)
    );
end entity;

architecture rtl of bit_sum is
begin

    process(entrada)
        variable count : unsigned(3 downto 0);
    begin
        count := (others => '0');

        for i in 0 to 14 loop
            if entrada(i) = '1' then
                count := count + 1;
            end if;
        end loop;

        soma <= std_logic_vector(count);
    end process;

end architecture;
