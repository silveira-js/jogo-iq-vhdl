# 🎮 Jogo IQ - VHDL

Projeto desenvolvido para a disciplina de Sistemas Digitais da UFSC. O jogo consiste em um desafio de memória visual onde o jogador deve reproduzir padrões exibidos nos LEDs da placa FPGA DE2.

## 🎥 Demonstração

📺 **Vídeo de apresentação:** [Clique aqui para assistir](https://www.youtube.com/watch?v=AK_lSBFI42E&feature=youtu.be)

## 📁 Estrutura do Projeto

```
jogo-iq-vhdl/
├── doc/                        # Documentação
│   ├── Datapath_controle_Alunos (1).pdf
│   └── Jogo.pdf
├── topo.vhd                    # Entidade de topo (integração completa)
├── controle.vhd                # Máquina de estados (FSM) do jogo
├── datapath.vhd                # Caminho de dados principal
│
├── Contadores
│   ├── counter_time.vhd        # Contador de tempo (10s → 0s)
│   └── counter_round.vhd       # Contador de rodadas (0 → 15)
│
├── Registradores
│   ├── registrador_sel.vhd     # Registrador de seleção (nível/código)
│   ├── registrador_user.vhd    # Registrador da resposta do usuário
│   └── registrador_bonus.vhd   # Registrador de bônus/pontuação
│
├── ROMs (Padrões do Jogo)
│   ├── ROM0.vhd / ROM0a.vhd    # Código 0 (displays / LEDs)
│   ├── ROM1.vhd / ROM1a.vhd    # Código 1 (displays / LEDs)
│   ├── ROM2.vhd / ROM2a.vhd    # Código 2 (displays / LEDs)
│   └── ROM3.vhd / ROM3a.vhd    # Código 3 (displays / LEDs)
│
├── Multiplexadores
│   ├── mux2x1_7bits.vhd        # MUX 2:1 para displays
│   ├── mux2x1_16bits.vhd       # MUX 2:1 para LEDs
│   ├── mux4x1_1bit.vhd         # MUX 4:1 para seleção de clock
│   ├── mux4x1_15bits.vhd       # MUX 4:1 para seleção de ROM auxiliar
│   └── mux4x1_32bits.vhd       # MUX 4:1 para seleção de ROM principal
│
├── Comparadores
│   ├── COMP_erro.vhd           # Comparador de erros (XOR)
│   └── COMP_end.vhd            # Comparador de fim de jogo
│
├── Decodificadores
│   ├── decod7seg.vhd           # Decodificador 7 segmentos (números)
│   ├── d_code.vhd              # Decodificador para códigos especiais
│   └── decoder_termometrico.vhd # Decodificador termométrico para LEDs
│
├── Lógica e Aritmética
│   ├── logica.vhd              # Lógica de cálculo de pontos
│   ├── bit_sum.vhd             # Somador de bits (conta erros)
│   └── subtracao.vhd           # Subtração para bônus
│
├── Geradores de Clock
│   ├── FSM_clock_de2.vhd       # Divisor de clock para DE2 (50MHz)
│   └── FSM_clock_emu.vhd       # Divisor de clock para emulação
│
└── ButtonSync.vhd              # Sincronizador de botões
```

## 🎯 Como Funciona

### Estados do Jogo

1. **Init**: Estado inicial - reseta todos os registradores e contadores
2. **Setup**: Jogador seleciona nível (0-3) e código (0-3) via switches
3. **Play_FPGA**: FPGA exibe o padrão nos display HEX por tempo variável
4. **Play_user**: Jogador tem 10 segundos para reproduzir o padrão
5. **Count_Round**: Incrementa a rodada e calcula bônus
6. **Check**: Verifica se o jogo terminou (15 rodadas ou bônus zerado)
7. **Wait_s**: Aguarda próxima rodada
8. **Result**: Exibe pontuação final

### Controles

- **SW(3:0)**: Seleção de nível (bits 1:0) e código (bits 3:2)
- **SW(14:0)**: Entrada da resposta do usuário (LEDs a acender)
- **SW(17)**: Alterna display entre rodada e bônus
- **KEY(0)**: Reset
- **KEY(1)**: Enter/Confirmar

---

## 📝 Respostas às Perguntas

### 1. Por que existem dois comandos de Reset entrando no datapath (R1 e R2)? Explique a funcionalidade de cada um.

Os dois resets têm funcionalidades distintas para permitir controle granular sobre diferentes partes do datapath:

**R1 (Reset do Timer/Clock):**
- Reseta o `counter_time` (temporizador de 10 segundos)
- Reseta o `FSM_clock` (gerador de frequências)
- É ativado na maioria dos estados (Init, Setup, Count_Round, Check, Wait_s, Result)
- Desativado apenas em **Play_FPGA** e **Play_user** para permitir a contagem de tempo
- **Função**: Controlar quando o temporizador deve contar e quando deve ser reiniciado entre rodadas

**R2 (Reset Geral do Jogo):**
- Reseta o `registrador_sel` (seleção de nível/código)
- Reseta o `registrador_user` (resposta do usuário)
- Reseta o `registrador_bonus` (inicializa com 15 pontos)
- Reseta o `counter_round` (contador de rodadas)
- É ativado **apenas** no estado **Init**
- **Função**: Inicializar completamente o jogo, preservando os valores durante as transições entre rodadas

**Por que separar?** Se houvesse apenas um reset, ao reiniciar o temporizador entre rodadas, também perderia a seleção de nível, o bônus acumulado e o contador de rodadas. A separação permite reiniciar o tempo sem perder o progresso do jogo.

---

### 2. O reset da Counter_time do seu VHDL é síncrono ou assíncrono com o relógio de 1Hz?

O reset é **ASSÍNCRONO** com o relógio de 1Hz.

**Evidência no código (`counter_time.vhd`):**

```vhdl
process(clock, R)          -- R está na lista de sensibilidade
begin
    if R = '1' then        -- Verificação do reset ANTES da borda
        Q_reg <= "1010";
    elsif rising_edge(clock) then
        -- lógica síncrona aqui
    end if;
end process;
```

**Características que comprovam o reset assíncrono:**
1. O sinal `R` está na **lista de sensibilidade** do processo
2. A verificação `if R = '1'` acontece **antes** e **independente** de `rising_edge(clock)`
3. O reset ocorre **imediatamente** quando R='1', sem esperar a borda de subida do clock

Se fosse síncrono, a verificação do reset estaria **dentro** do `elsif rising_edge(clock)`.

---

### 3. O que faria para ter os enables dos registradores do datapath assíncronos com o relógio?

Atualmente, os enables são **síncronos** (funcionam apenas na borda de subida do clock):

```vhdl
-- Código ATUAL (enable síncrono):
process(clock, R)
begin
    if R = '1' then
        reg_q <= (others => '0');
    elsif rising_edge(clock) then
        if E = '1' then              -- Enable só funciona na borda
            reg_q <= D;
        end if;
    end if;
end process;
```

Para tornar o enable **assíncrono**, seria necessário:

```vhdl
-- Código MODIFICADO (enable assíncrono):
process(clock, R, E, D)              -- Adicionar E e D na sensibilidade
begin
    if R = '1' then
        reg_q <= (others => '0');
    elsif E = '1' then               -- Enable FORA do rising_edge
        reg_q <= D;                  -- Atualiza imediatamente quando E='1'
    end if;
end process;
```

**Mudanças necessárias:**
1. Adicionar `E` e `D` na lista de sensibilidade
2. Mover a verificação `if E = '1'` para **fora** do `elsif rising_edge(clock)`
3. O registrador atualizaria imediatamente quando E='1', sem esperar o clock
---

### 4. Caso quiser substituir C por "J" de jogo, nos displays de 7 segmentos, o que deveria ser feito?

Para substituir a letra "C" por "J" no display de 7 segmentos:

**Representação visual do display:**
```
     a
    ━━━
 f ┃   ┃ b
    ━g━
 e ┃   ┃ c
    ━━━
     d
```

**Letra J** acende os segmentos: **b, c, d, e** (forma um J)
```
        
       ┃ b
        
       ┃ c
    ━━━
     d
```

**Modificação no código (`datapath.vhd`, linha 91):**

```vhdl
-- Código ATUAL:
constant SEG_C : std_logic_vector(6 downto 0) := "1000110";  -- C

-- Código MODIFICADO:
constant SEG_J : std_logic_vector(6 downto 0) := "1100001";  -- J
```

**Cálculo do código (lógica ativa baixo - 0 acende, 1 apaga):**
| Segmento | a | b | c | d | e | f | g |
|----------|---|---|---|---|---|---|---|
| Posição  | 6 | 5 | 4 | 3 | 2 | 1 | 0 |
| J        | 1 | 0 | 0 | 0 | 0 | 1 | 1 |

Resultado: `"1100001"` = J

**Também seria necessário atualizar** a linha onde `SEG_C` é usado (linha 593-594 do datapath).

---

### 5. O que aconteceria se a contagem no Counter_round fosse "round <= round - 1"? Justifique.

Se a contagem fosse **decremental** (`round <= round - 1`), ocorreriam os seguintes problemas:

**Código ATUAL:**
```vhdl
if R = '1' then
    count_reg <= (others => '0');  -- Inicia em 0000
elsif rising_edge(clock) then
    if E = '1' then
        count_reg <= count_reg + 1;  -- Conta para cima: 0→1→2→...→15
    end if;
end if;

tc <= '1' when count_reg = "1111" else '0';  -- TC quando chega em 15
```

**Se fosse decremental:**
```vhdl
count_reg <= count_reg - 1;  -- Contaria: 0→15→14→...→1→0
```

**Problemas:**
1. **Underflow imediato**: O contador inicia em `"0000"` (0) após reset. Na primeira rodada, faria `0 - 1 = "1111"` (15), causando underflow

2. **Acesso invertido às ROMs**: As ROMs seriam acessadas de trás para frente (rodada 15 → 14 → ... → 1 → 0), invertendo a ordem dos desafios

3. **Terminal Count prematuro**: O sinal `tc` detecta quando `count_reg = "1111"`. Isso aconteceria **logo na primeira jogada** (0-1=15), fazendo `end_round = '1'` e terminando o jogo prematuramente

4. **Jogo terminaria após 1 rodada**: Como `end_round` ficaria ativo na primeira rodada, o jogo iria direto para o estado Result

---

### 6. O que aconteceria se o relógio de Counter_time fosse relógio CLOCK_50? Justifique.

**Situação atual:**
- `Counter_time` usa o relógio de **1Hz** (gerado pelo `FSM_clock`)
- Conta de 10 até 0, totalizando 10 segundos para o jogador responder

**Se usasse CLOCK_50 (50 MHz):**

**Cálculo do tempo:**
- CLOCK_50 = 50 MHz = 50.000.000 ciclos por segundo
- O contador decrementa de 10 a 0 = 11 contagens
- Tempo total = 11 ÷ 50.000.000 = **0,00000022 segundos** = **220 nanossegundos**

**Consequências:**
1. **Tempo zero para resposta**: O jogador teria 220 nanossegundos para ver o padrão e reproduzi-lo nos switches - humanamente impossível

2. **Jogo injogável**: O sinal `end_time` seria ativado quase instantaneamente após entrar em `Play_user`, fazendo a FSM ir direto para `Result`

3. **Pontuação sempre mínima**: Como o jogador nunca conseguiria responder a tempo, o bônus seria sempre perdido

4. **Comportamento aparente**: Para o usuário, pareceria que o jogo "trava" ou "pula" direto para o resultado sem dar chance de jogar

**Por isso existe o FSM_clock:** O divisor de frequência é essencial para criar um clock de 1Hz a partir dos 50MHz da placa, permitindo temporização em escala humana.

---

## 👥 Autores

- Josué Silveira

## 📄 Licença

Projeto acadêmico - UFSC - Sistemas Digitais
