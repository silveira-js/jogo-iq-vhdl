library ieee;
use ieee.std_logic_1164.all;

entity controle is
    port(
        enter  : in std_logic;
        reset  : in std_logic;
        CLOCK  : in std_logic;

        end_game  : in std_logic;
        end_time  : in std_logic;
        end_round : in std_logic;
        end_FPGA  : in std_logic;

        R1, R2    : out std_logic;
        E1, E2, E3, E4, E5 : out std_logic
    );
end entity controle;

architecture fsm of controle is

    type state_type is (
        Init,
        Setup,
        Play_FPGA,
        Play_user,
        Count_Round,
        Check,
        Wait_s,
        Result
    );

    signal state_reg, state_next : state_type;

begin

    process (CLOCK, reset)
    begin
        if reset = '1' then
            state_reg <= Init;
        elsif rising_edge(CLOCK) then
            state_reg <= state_next;
        end if;
    end process;


    process (state_reg, enter, reset,
             end_game, end_time, end_round, end_FPGA)
    begin
        R1 <= '1';
        R2 <= '0';
        E1 <= '0';
        E2 <= '0';
        E3 <= '0';
        E4 <= '0';
        E5 <= '0';
        state_next <= state_reg;

        case state_reg is


            when Init =>
                R1 <= '1';
                R2 <= '1';
                state_next <= Setup;

            when Setup =>
                R1 <= '1';
                E1 <= '1';

                if reset = '1' then
                    state_next <= Init;
                elsif enter = '1' then
                    state_next <= Play_FPGA;
                end if;


            when Play_FPGA =>
                R1 <= '0';
                E2 <= '1';

                if reset = '1' then
                    state_next <= Init;
                elsif end_FPGA = '1' then
                    state_next <= Play_user;
                end if;

            when Play_user =>
                R1 <= '0';
                E3 <= '1';

                if reset = '1' then
                    state_next <= Init;
                elsif end_time = '1' then
                    state_next <= Result;
                elsif enter = '1' then
                    state_next <= Count_Round;
                end if;

            when Count_Round =>
                R1 <= '1'; 
                E4 <= '1';

                if reset = '1' then
                    state_next <= Init;
                else
                    state_next <= Check;
                end if;


            when Check =>
                R1 <= '1';

                if reset = '1' then
                    state_next <= Init;
                elsif (end_round = '1') or (end_game = '1') then
                    state_next <= Result;
                else
                    state_next <= Wait_s;
                end if;

            when Wait_s =>
                R1 <= '1';

                if reset = '1' then
                    state_next <= Init;
                elsif enter = '1' then
                    state_next <= Play_FPGA;
                end if;


            when Result =>
                R1 <= '1';
                E5 <= '1';

                if reset = '1' then
                    state_next <= Init;
                elsif enter = '1' then
                    state_next <= Init;
                end if;

            when others =>
                state_next <= Init;

        end case;
    end process;

end architecture fsm;
