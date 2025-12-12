library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity datapath is
port(
    -- Entradas de dados
    clk: in std_logic;
    SW: in std_logic_vector(17 downto 0);
    
    -- Entradas de controle
    R1, R2, E1, E2, E3, E4, E5: in std_logic;
    
    -- Saídas de dados
    hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7: out std_logic_vector(6 downto 0);
    ledr: out std_logic_vector(15 downto 0);
    
    -- Saídas de status
    end_game, end_time, end_round, end_FPGA: out std_logic
);
end entity;

architecture arc of datapath is
---------------------------SIGNALS-----------------------------------------------------------
-- contadores
signal tempo, X: std_logic_vector(3 downto 0);
signal limite_fpga: std_logic_vector(3 downto 0);

-- FSM_clock
signal CLK_1Hz, CLK_050Hz, CLK_033Hz, CLK_025Hz, CLK_020Hz: std_logic;

-- Lógica combinacional
signal RESULT: std_logic_vector(7 downto 0);

-- Registradores
signal SEL: std_logic_vector(3 downto 0);
signal USER: std_logic_vector(14 downto 0);
signal Bonus, Bonus_reg: std_logic_vector(3 downto 0);

-- ROMs
signal CODE_aux: std_logic_vector(14 downto 0);
signal CODE: std_logic_vector(31 downto 0);

-- COMP
signal erro: std_logic_vector(14 downto 0);
signal erro_numerico : std_logic_vector(3 downto 0);
signal erro_faltante : std_logic_vector(14 downto 0);
signal erro_excedente: std_logic_vector(14 downto 0);

signal falt_cnt : std_logic_vector(3 downto 0);
signal exc_cnt  : std_logic_vector(3 downto 0);

-- NOR enables displays (ainda não usamos)
signal E23, E25, E12: std_logic;

-- dec termométrico
signal stermoround, stermobonus: std_logic_vector(15 downto 0);

-- decoders HEX 7-0 (Setup)
signal sdecod7, sdec7, sdecod6, sdec6, sdecod5, sdecod4, sdec4,
       sdecod3, sdecod2, sdec2, sdecod1, sdecod0, sdec0: std_logic_vector(6 downto 0);

-- dígitos da ROM (nibbles) e seus decodificados
signal digit7, digit6, digit5, digit4, digit3, digit2, digit1, digit0: std_logic_vector(3 downto 0);
signal s_code7, s_code6, s_code5, s_code4, s_code3, s_code2, s_code1, s_code0: std_logic_vector(6 downto 0);

signal edec2, edec0: std_logic_vector(3 downto 0);

-- saída ROMs
signal srom0, srom1, srom2, srom3: std_logic_vector(31 downto 0);
signal srom0a, srom1a, srom2a, srom3a: std_logic_vector(14 downto 0);

-- FSM_clock
signal E2orE3: std_logic;

-- Resultado final decodificado e saídas dos MUX para HEX7/HEX6
signal sresult_hi, sresult_lo : std_logic_vector(6 downto 0);
signal mux_hex7, mux_hex6     : std_logic_vector(6 downto 0);

-- Tempo decodificado e MUX para HEX5/HEX4 (Play_user)
signal sdec_tempo             : std_logic_vector(6 downto 0);
signal mux_hex5, mux_hex4     : std_logic_vector(6 downto 0);
signal tc_time : std_logic;


signal mux_hex0, mux_hex1, mux_hex2, mux_hex3 : std_logic_vector(6 downto 0);

-- Padrão da letra 't' no display (ajuste se a tua tabela for outra)
constant SEG_T : std_logic_vector(6 downto 0) := "0000111";
constant SEG_L : std_logic_vector(6 downto 0) := "1000111";
constant SEG_C : std_logic_vector(6 downto 0) := "1000110";


---------------------------COMPONENTS-----------------------------------------------------------
component counter_time is 
port(
    R, E, clock: in std_logic;
    Q: out std_logic_vector(3 downto 0);
    tc: out std_logic
);
end component;

component counter_round is
port(
    R, E, clock: in std_logic;
    Q: out std_logic_vector(3 downto 0);
    tc: out std_logic
);
end component;

component decoder_termometrico is
 port(
    X: in  std_logic_vector(3 downto 0);
    S: out std_logic_vector(15 downto 0)
);
end component;

component FSM_clock_de2 is
port(
    reset, E: in std_logic;
    clock: in std_logic;
    CLK_1Hz, CLK_050Hz, CLK_033Hz, CLK_025Hz, CLK_020Hz: out std_logic
);
end component;

component FSM_clock_emu is
port(
    reset, E: in std_logic;
    clock: in std_logic;
    CLK_1Hz, CLK_050Hz, CLK_033Hz, CLK_025Hz, CLK_020Hz: out std_logic
);
end component;

component decod7seg is
port(
    C: in std_logic_vector(3 downto 0);
    F: out std_logic_vector(6 downto 0)
 );
end component;

component d_code is
port(
    C: in std_logic_vector(3 downto 0);
    F: out std_logic_vector(6 downto 0)
 );
end component;

component mux2x1_7bits is
port(
    E0, E1: in std_logic_vector(6 downto 0);
    sel: in std_logic;
    saida: out std_logic_vector(6 downto 0)
);
end component;

component mux2x1_16bits is
port(
    E0, E1: in std_logic_vector(15 downto 0);
    sel: in std_logic;
    saida: out std_logic_vector(15 downto 0)
);
end component;

component mux4x1_1bit is
port(
    E0, E1, E2, E3: in std_logic;
    sel: in std_logic_vector(1 downto 0);
    saida: out std_logic
);
end component;

component mux4x1_15bits is
port(
    E0, E1, E2, E3: in std_logic_vector(14 downto 0);
    sel: in std_logic_vector(1 downto 0);
    saida: out std_logic_vector(14 downto 0)
);
end component;

component mux4x1_32bits is
port(
    E0, E1, E2, E3: in std_logic_vector(31 downto 0);
    sel: in std_logic_vector(1 downto 0);
    saida: out std_logic_vector(31 downto 0)
);
end component;

component registrador_sel is 
port(
    R, E, clock: in std_logic;
    D: in std_logic_vector(3 downto 0);
    Q: out std_logic_vector(3 downto 0) 
);
end component;

component registrador_user is 
port(
    R, E, clock: in std_logic;
    D: in std_logic_vector(14 downto 0);
    Q: out std_logic_vector(14 downto 0) 
);
end component;

component registrador_bonus is 
port(
    S, E, clock: in std_logic;
    D: in std_logic_vector(3 downto 0);
    Q: out std_logic_vector(3 downto 0) 
);
end component;

component COMP_erro is
port(
    E0, E1: in std_logic_vector(14 downto 0);
    diferente: out std_logic_vector(14 downto 0)
);
end component;

component COMP_end is
port(
    E0: in std_logic_vector(3 downto 0);
    endgame: out std_logic
);
end component;

component subtracao is
port(
    E0: in std_logic_vector(3 downto 0);
    E1: in std_logic_vector(3 downto 0);
    resultado: out std_logic_vector(3 downto 0)
);
end component;

component logica is 
port(
    round, bonus: in std_logic_vector(3 downto 0);
    nivel: in std_logic_vector(1 downto 0);
    points: out std_logic_vector(7 downto 0)
);
end component;

component ROM0 is
port(
    address: in std_logic_vector(3 downto 0);
    output : out std_logic_vector(31 downto 0)
);
end component;

component ROM1 is
port(
    address: in std_logic_vector(3 downto 0);
    output : out std_logic_vector(31 downto 0)
);
end component;

component ROM2 is
port(
    address: in std_logic_vector(3 downto 0);
    output : out std_logic_vector(31 downto 0)
);
end component;

component ROM3 is
port(
    address: in std_logic_vector(3 downto 0);
    output : out std_logic_vector(31 downto 0)
);
end component;

component ROM0a is
port(
    address: in std_logic_vector(3 downto 0);
    output : out std_logic_vector(14 downto 0)
);
end component;

component ROM1a is
port(
    address: in std_logic_vector(3 downto 0);
    output : out std_logic_vector(14 downto 0)
);
end component;

component ROM2a is
port(
    address: in std_logic_vector(3 downto 0);
    output : out std_logic_vector(14 downto 0)
);
end component;

component ROM3a is
port(
    address: in std_logic_vector(3 downto 0);
    output : out std_logic_vector(14 downto 0)
);
end component;

component bit_sum is
    port (
        entrada : in  std_logic_vector(14 downto 0);
        soma    : out std_logic_vector(3 downto 0)
    );
end component;

-- COMEÇO DO CÓDIGO ---------------------------------------------------------------------------------------
begin

    E2orE3 <= E2 or E3;
	E23 <= E2 or E3;
	E25 <= E2 or E5;
	E12 <= E1 or E2;


    freq_emu: FSM_clock_emu
        port map(
            reset      => R1,
            E          => E2orE3,
            clock      => clk,
            CLK_1Hz    => CLK_1Hz,
            CLK_050Hz  => CLK_050Hz,
            CLK_033Hz  => CLK_033Hz,
            CLK_025Hz  => CLK_025Hz,
            CLK_020Hz  => CLK_020Hz
        );


    U_mux_end_fpga: mux4x1_1bit
        port map(
            E0   => CLK_020Hz,
            E1   => CLK_025Hz,
            E2   => CLK_033Hz,
            E3   => CLK_050Hz,
            sel  => SEL(1 downto 0),
            saida => end_FPGA
        );


    U_time: counter_time
        port map(
            R     => R1,
            E     => E3,
            clock => CLK_1Hz,
            Q     => tempo,
            tc    => tc_time
        );


	dec_tempo: decod7seg
	port map(
		C => tempo,
		F => sdec_tempo
	);


    U_SEL: registrador_sel
        port map(
            R     => R2,
            E     => E1,
            clock => clk,
            D     => SW(3 downto 0),
            Q     => SEL
        );


    U_round: counter_round
        port map(
            R     => R2,
            E     => E4,
            clock => clk,
            Q     => X,
            tc    => end_round
        );

    U_bonus: registrador_bonus
        port map(
            S     => R2,
            E     => E4,
            clock => clk,
            D     => Bonus,
            Q     => Bonus_reg
        );


	U_SUBTRACAO_BONUS: subtracao
	port map(
		E0        => Bonus_reg,
		E1        => erro_numerico,
		resultado => Bonus
	);


	U_USER: registrador_user
		port map(
			R     => R2,
			E     => E3,
			clock => clk,
			D     => SW(14 downto 0),
			Q     => USER
		);


    U_termoround: decoder_termometrico
        port map(
            X => X,
            S => stermoround
        );

    U_termobonus: decoder_termometrico
        port map(
            X => Bonus_reg,
            S => stermobonus
        );


    LEDR <= stermoround when SW(17) = '0' else
            stermobonus;

    edec0 <= "00" & SEL(1 downto 0);

    dec_nivel: decod7seg
        port map(
            C => edec0,
            F => sdecod0
        );

    edec2 <= "00" & SEL(3 downto 2);
    dec_code: decod7seg
        port map(
            C => edec2,
            F => sdecod2
        );


    U_rom0: ROM0  port map(address => X, output => srom0);
    U_rom1: ROM1  port map(address => X, output => srom1);
    U_rom2: ROM2  port map(address => X, output => srom2);
    U_rom3: ROM3  port map(address => X, output => srom3);

    U_rom0a: ROM0a port map(address => X, output => srom0a);
    U_rom1a: ROM1a port map(address => X, output => srom1a);
    U_rom2a: ROM2a port map(address => X, output => srom2a);
    U_rom3a: ROM3a port map(address => X, output => srom3a);


    ROM_select: mux4x1_32bits
        port map(
            E0   => srom0,
            E1   => srom1,
            E2   => srom2,
            E3   => srom3,
            sel  => SEL(3 downto 2),
            saida => CODE
        );

    ROMA_select: mux4x1_15bits
        port map(
            E0   => srom0a,
            E1   => srom1a,
            E2   => srom2a,
            E3   => srom3a,
            sel  => SEL(3 downto 2),
            saida => CODE_aux
        );


	U_COMP_ERRO: COMP_erro
	port map(
		E0        => CODE_aux,
		E1        => USER,
		diferente => erro
	);


	erro_faltante  <= erro and CODE_aux;
	erro_excedente <= erro and USER;

	U_BIT_SUM_FALT: bit_sum
	port map(
		entrada => erro_faltante,
		soma    => falt_cnt
	);

	U_BIT_SUM_EXC: bit_sum
	port map(
		entrada => erro_excedente,
		soma    => exc_cnt
	);

	erro_numerico <= falt_cnt when unsigned(falt_cnt) >= unsigned(exc_cnt)
                 else exc_cnt;


	U_LOGICA_PONTOS: logica
	port map(
		round => X,
		bonus => Bonus_reg,
		nivel => SEL(1 downto 0),
		points => RESULT
	);

    digit7 <= CODE(31 downto 28);
    digit6 <= CODE(27 downto 24);
    digit5 <= CODE(23 downto 20);
    digit4 <= CODE(19 downto 16);
    digit3 <= CODE(15 downto 12);
    digit2 <= CODE(11 downto 8);
    digit1 <= CODE(7  downto 4);
    digit0 <= CODE(3  downto 0);

    dec_code7: d_code port map(C => digit7, F => s_code7);
    dec_code6: d_code port map(C => digit6, F => s_code6);
    dec_code5: d_code port map(C => digit5, F => s_code5);
    dec_code4: d_code port map(C => digit4, F => s_code4);
    dec_code3: d_code port map(C => digit3, F => s_code3);
    dec_code2: d_code port map(C => digit2, F => s_code2);
    dec_code1: d_code port map(C => digit1, F => s_code1);
    dec_code0: d_code port map(C => digit0, F => s_code0);

	dec_result_hi: decod7seg
	port map(
		C => RESULT(7 downto 4),
		F => sresult_hi
	);

	dec_result_lo: decod7seg
	port map(
		C => RESULT(3 downto 0),
		F => sresult_lo
	);

	mux_hex7_inst: mux2x1_7bits
	port map(
		E0    => s_code7,
		E1    => sresult_hi,
		sel   => E5,
		saida => mux_hex7
	);

	mux_hex6_inst: mux2x1_7bits
	port map(
		E0    => s_code6,
		E1    => sresult_lo,
		sel   => E5,
		saida => mux_hex6
	);
	

	mux_hex5_inst: mux2x1_7bits
	port map(
		E0    => s_code5,
		E1    => SEG_T,
		sel   => E3,
		saida => mux_hex5
	);


	mux_hex4_inst: mux2x1_7bits
	port map(
		E0    => s_code4,
		E1    => sdec_tempo,
		sel   => E3,
		saida => mux_hex4
	);

	mux_hex0_inst: mux2x1_7bits
	port map(
		E0    => s_code0,
		E1    => sdecod0,
		sel   => E1,
		saida => mux_hex0
	);

	mux_hex1_inst: mux2x1_7bits
	port map(
		E0    => s_code1,
		E1    => SEG_L,
		sel   => E1,
		saida => mux_hex1
	);

	mux_hex2_inst: mux2x1_7bits
	port map(
		E0    => s_code2,
		E1    => sdecod2, 
		sel   => E1,
		saida => mux_hex2
	);

	mux_hex3_inst: mux2x1_7bits
	port map(
		E0    => s_code3,
		E1    => SEG_C,
		sel   => E1,
		saida => mux_hex3
	);


	hex0 <= mux_hex0 when E12 = '1' else "1111111";
	hex1 <= mux_hex1 when E12 = '1' else "1111111";
	hex2 <= mux_hex2 when E12 = '1' else "1111111";
	hex3 <= mux_hex3 when E12 = '1' else "1111111";
	hex4 <= mux_hex4 when E23 = '1' else "1111111";
	hex5 <= mux_hex5 when E23 = '1' else "1111111";
	hex6 <= mux_hex6 when E25 = '1' else "1111111";
	hex7 <= mux_hex7 when E25 = '1' else "1111111";

 
    end_time <= tc_time;
	

	U_COMP_END: COMP_end
	port map(
		E0      => Bonus_reg,
		endgame => end_game
	);

end arc;
