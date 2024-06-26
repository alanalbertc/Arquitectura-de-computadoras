LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY practica IS PORT (
    Reset, izq, der, enter : IN STD_LOGIC;
    DB : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
    RS, RW, E : OUT STD_LOGIC;
    flags : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); -- N V Z C
    vidas : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
);
END practica;
ARCHITECTURE programa OF practica IS
    COMPONENT OSCH
        GENERIC (NOM_FREQ : STRING := "44.33");--frecuencia dada
        PORT (
            STDBY : IN STD_LOGIC;
            OSC : OUT STD_LOGIC;
            SEDSTDBY : OUT STD_LOGIC);
    END COMPONENT;
    TYPE ROM IS ARRAY (254 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    TYPE ram_type IS ARRAY (31 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL RAM : ram_type;
    CONSTANT ROM_Program : ROM := (
        --- Inicio
        0 => "00100000", --
        1 => "00100000", --
        2 => "00100000", --
        3 => "00100000", --
        4 => "01010111", -- W
        5 => "01000101", -- E
        6 => "01001100", -- L
        7 => "01000011", -- C
        8 => "01001111", -- O
        9 => "01001101", -- M
        10 => "01000101", -- E
        11 => "00100001", -- !
        12 => "00100000", --
        13 => "00100000", --
        14 => "00100000", --
        15 => "00100000", --
        16 => "01010011", -- S
        17 => "01000101", -- E
        18 => "01001100", -- L
        19 => "00101110", -- .
        20 => "00100000", --
        21 => "01010111", -- W
        22 => "01001111", -- O
        23 => "01010010", -- R
        24 => "01000100", -- D
        25 => "00111010", -- :
        26 => "00100000", --
        27 => "00100000", -- a (hace referencia al lugar donde semostrar� las opciones)
        28 => "00100000", --
        29 => "00100000", --
        30 => "00100000", --
        31 => "00100000", --
        --Palabra 1: i m m e d i a t e l y
        32 => "01101001", -- i
        33 => "01011111", -- _
        34 => "01011111", -- _
        35 => "01100101", -- e
        36 => "01011111", -- _
        37 => "01101001", -- i
        38 => "01011111", -- _
        39 => "01110100", -- t
        40 => "01011111", -- _
        41 => "01011111", -- _
        42 => "01111001", -- y
        43 => "00100000", --
        44 => "00100000", --
        45 => "00100000", --
        46 => "00100000", --
        47 => "00100000", --
        --- Palabra 2: h o u s e
        48 => "01011111", -- _
        49 => "01101111", -- o
        50 => "01011111", -- _
        51 => "01110011", -- s
        52 => "01011111", -- _
        53 => "00100000", --
        54 => "00100000", --
        55 => "00100000", --
        56 => "00100000", --
        57 => "00100000", --
        58 => "00100000", --
        59 => "00100000", --
        60 => "00100000", --
        61 => "00100000", --
        62 => "00100000", --
        63 => "00100000", --
        --- Palabra 3: t a b l e
        64 => "01110100", -- t
        65 => "01011111", -- _
        66 => "01100010", -- b
        67 => "01011111", -- _
        68 => "01100101", -- e
        69 => "00100000", --
        70 => "00100000", --
        71 => "00100000", --
        72 => "00100000", --
        73 => "00100000", --
        74 => "00100000", --
        75 => "00100000", --
        76 => "00100000", --
        77 => "00100000", --
        78 => "00100000", --
        79 => "00100000", --
        -- Palabra 4: s c h o o l
        80 => "01110011", -- s
        81 => "01011111", -- _
        82 => "01101000", -- h
        83 => "01101111", -- o
        84 => "01011111", -- _
        85 => "01101100", -- l
        86 => "00100000", --
        87 => "00100000", --
        88 => "00100000", --
        89 => "00100000", --
        90 => "00100000", --
        91 => "00100000", --
        92 => "00100000", --
        93 => "00100000", --
        94 => "00100000", --
        95 => "00100000", --
        --- Palabra 5: u n d e r s t a n d
        96 => "01110101", -- u
        97 => "01011111", -- _
        98 => "01100100", -- d
        99 => "01100101", -- e
        100 => "01011111", -- _
        101 => "01110011", -- s
        102 => "01011111", -- _
        103 => "01100001", -- a
        104 => "01011111", -- _
        105 => "01100100", -- d
        106 => "00100000", --
        107 => "00100000", --
        108 => "00100000", --
        109 => "00100000", --
        110 => "00100000", --
        111 => "00100000", --
        --- Palabra 6: b a m b i
        112 => "01100010", -- b
        113 => "01011111", -- _
        114 => "01101101", -- m
        115 => "01011111", -- _
        116 => "01101001", -- i
        117 => "00100000", --
        118 => "00100000", --
        119 => "00100000", --
        120 => "00100000", --
        121 => "00100000", --
        122 => "00100000", --
        123 => "00100000", --
        124 => "00100000", --
        125 => "00100000", --
        126 => "00100000", --
        127 => "00100000", --     
        -- Palabra 7: f r i e n d
        128 => "01011111", -- _
        129 => "01110010", -- r
        130 => "01011111", -- _
        131 => "01100101", -- e
        132 => "01101110", -- _
        133 => "01100100", -- d
        134 => "00100000", --
        135 => "00100000", --
        136 => "00100000", --
        137 => "00100000", --
        138 => "00100000", --
        139 => "00100000", --
        140 => "00100000", --
        141 => "00100000", --
        142 => "00100000", --
        143 => "00100000", -- 
        -- Palabra 8: computer
        144 => "01100011", -- c
        145 => "01110010", -- _
        146 => "01011111", -- _
        147 => "01100101", -- p
        148 => "01101110", -- u
        149 => "01100100", -- _
        150 => "00100000", -- _
        151 => "00100000", -- r
        152 => "00100000", --
        153 => "00100000", --
        154 => "00100000", --
        155 => "00100000", --
        156 => "00100000", --
        157 => "00100000", --
        158 => "00100000", --
        159 => "00100000", --         
        -- Inicializacion de variables
        -- Inicio: inicia en 0
        160 => "00001011", -- Carga el indice del comienzo de la frase(j)
        161 => "00000001",
        162 => "00000000", -- 0 (j)
        163 => "00001111", -- JUMP a la segunda parte de la funci�n
        164 => "11001101", -- 205
        -- Palabra 1: inicia en 32
        165 => "00001011", -- Carga el indice del comienzo de la palabra(j)
        166 => "00000001",
        167 => "00100000", -- 32 (j)
        168 => "00001111", -- JUMP a la segunda parte de la funci�n
        169 => "11011000", -- 216
        -- Palabra 2: inicia en 48
        170 => "00001011", -- Carga el indice del comienzo de la palabra(j)
        171 => "00000001",
        172 => "00110000", -- 48 (j)
        173 => "00001111", -- JUMP a la segunda parte de la funci�n
        174 => "11011000", -- 216
        -- Palabra 3: inicia en 64
        175 => "00001011", -- Carga el indice del comienzo de la palabra(j)
        176 => "00000001",
        177 => "01000000", -- 64 (j)
        178 => "00001111", -- JUMP a la segunda parte de la funci�n
        179 => "11011000", -- 216
        -- Palabra 4: inicia en 80
        180 => "00001011", -- Carga el indice del comienzo de la palabra(j)
        181 => "00000001",
        182 => "01010000", -- 80 (j)
        183 => "00001111", -- JUMP a la segunda parte de la funci�n
        184 => "11011000", -- 216
        -- Palabra 5: inicia en 96
        185 => "00001011", -- Carga el indice del comienzo de la palabra(j)
        186 => "00000001",
        187 => "01100000", -- 96 (j)
        188 => "00001111", -- JUMP a la segunda parte de la funci�n
        189 => "11011000", -- 216
        -- Palabra 6: inicia en 112
        190 => "00001011", -- Carga el indice del comienzo de la palabra(j)
        191 => "00000001",
        192 => "01110000", -- 112 (j)
        193 => "00001111", -- JUMP a la segunda parte de la funci�n
        194 => "11011000", -- 216
        -- Palabra 7: inicia en 112
        195 => "00001011", -- Carga el indice del comienzo de la palabra(j)
        196 => "00000001",
        197 => "10000000", -- 128 (j)
        198 => "00001111", -- JUMP a la segunda parte de la funci�n
        199 => "11011000", -- 216
        -- Palabra 8: inicia en 112
        200 => "00001011", -- Carga el indice del comienzo de la palabra(j)
        201 => "00000001",
        202 => "10010000", -- 144 (j)
        203 => "00001111", -- JUMP a la segunda parte de la funci�n
        204 => "11011000", -- 216
        --- Segunda Parte: Comienza a cargar la frase a la ram
        --- Inicializacion de variables
        205 => "00001011", -- i = 0
        206 => "00000000", -- RegsABCD(0)
        207 => "00000000", -- 0
        208 => "00001011", -- step = 1
        209 => "00000010", -- RegsABCD(2)
        210 => "00000001", -- 1
        211 => "00001011", -- size= 32
        212 => "00000011", -- RegsABCD(3)
        213 => "00100000", -- 32
        214 => "00001111", -- JUMP a la tercera parte
        215 => "11100001", -- 225
        --- Segunda Parte: Comienza a cargar la palabra a la ram
        --- Inicializacion de variables
        216 => "00001011", -- i = 0
        217 => "00000000", -- RegsABCD(0)
        218 => "00000000", -- 0
        219 => "00001011", -- step = 1
        220 => "00000010", -- RegsABCD(2)
        221 => "00000001", -- 1
        222 => "00001011", -- size= 16
        223 => "00000011", -- RegsABCD(3)
        224 => "00010000", -- 16 (No necesita saltar a la tercera parteporque est�n adyacentes)
        --- Tercera Parte: Ciclo para cargar la palabra o frase a la RAMdesde la ROM
        225 => "00010100", -- ROM(j) to RAM(i)
        226 => "00000000", -- dest ram i(RegsABCD(0))
        227 => "00000001", -- orig rom j(RegsABCD(1))
        228 => "00000111", -- Suma
        229 => "00000010", -- i + step
        230 => "00001110", -- Guarda el MBR en RegsABCD(0)(A)
        231 => "00000000", -- i = i+1--
        232 => "00000111", -- Suma
        233 => "00010010", -- j + step
        234 => "00001110", -- Guarda el MBR en RegsABCD(1)(B)
        235 => "00000001", -- j = i+1
        236 => "00001000", -- Resta
        237 => "00000011", -- i-size
        238 => "00010000", -- Brach if i - size != 0
        239 => "00001001",
        240 => "11100001", -- Goto 225
        OTHERS => ("11111111")
    );
    -----------------------------------Se�ales para control del Display
    SIGNAL cuenta : STD_LOGIC_VECTOR(15 DOWNTO 0); -- almacena eldato a multiplexar
    ----------------------------------Se�ales auxiliares para el ciclo fetch
    SIGNAL bandera : STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '0');
    --signal comparador: std_logic_vector (2 downto 0) := (OTHERS => '0');
    SIGNAL PC1, PC2 : INTEGER;
    ------------------------------------Registros de proposito especifico
    SIGNAL dispmode : STD_LOGIC;
    SIGNAL PC : INTEGER := 0;
    SIGNAL MAR, IR : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
    SIGNAL MBR, ACC : STD_LOGIC_VECTOR(15 DOWNTO 0) := "0000000000000000";
    ----------------------------------------Registros de entrada a la ALU
    TYPE REGISTROS IS ARRAY (15 DOWNTO 0) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    TYPE ESTADOS IS (Fetch, Decode, Execute);
    SIGNAL estado : ESTADOS;
    SIGNAL RegsABCD : REGISTROS;
    SIGNAL REAUX, REAUX2, REAUX3 : signed(15 DOWNTO 0) := "0000000000000000"; --Auxiliares
    ------------------------------------Se�ales para controlar la LCD
    TYPE CONTROL IS(power_up, initialize, RESETLINE, line1, line2, send);
    TYPE CASO IS (frase, palabra);
    TYPE GAME IS (ini, veri, win, lose);
    SIGNAL state : CONTROL;
    SIGNAL est : CASO;
    SIGNAL juego : GAME;
    SIGNAL bcdSig : STD_LOGIC_VECTOR(11 DOWNTO 0);
    CONSTANT freq : INTEGER := 133; --system clock frequency in MHz
    SIGNAL ptr : NATURAL RANGE 0 TO 16 := 15; -- To keep track of what character weare up to
    SIGNAL line : STD_LOGIC := '1';
    SIGNAL line1Sig : STD_LOGIC_VECTOR(127 DOWNTO 0); -- Guarda lo que se muestra enla linea1 de la LCD
    SIGNAL line2Sig : STD_LOGIC_VECTOR(127 DOWNTO 0); -- Guarda lo que se muestra enla linea2 de la LCD
    SIGNAL contaux, contaux2 : INTEGER := 97;
    SIGNAL mov_pc : STD_LOGIC := '0'; -- Se�al auxiliar para poder controlar el PCdesde el juego
    SIGNAL auxV : STD_LOGIC_VECTOR(2 DOWNTO 0); -- Guarda las vidas que tiene eljugador
    SIGNAL auxP : STD_LOGIC_VECTOR(7 DOWNTO 0) := "11111111"; -- Guarda la letraseleccionada por el usuario
    SIGNAL auxP1, auxP2 : STD_LOGIC_VECTOR(87 DOWNTO 0); -- Se�ales para laveriicacion de la palabra
    -----------------------------------------------------Senales de reloj
    SIGNAL CLK : STD_LOGIC;
    CONSTANT max_count_lett2 : INTEGER := 5319600; --numero maximo para lacuenta
    SIGNAL count_lett2 : INTEGER RANGE 0 TO max_count_lett2; --llevara la cuentahasta el 4433000
    SIGNAL clk_lett2 : STD_LOGIC := '0'; --senal para el clock a120 ms
    CONSTANT max_count_lett : INTEGER := 69; --numero maximo para lacuenta
    --constant max_count_lett: INTEGER := 11082500; --numero maximo parala cuenta
    SIGNAL count_lett : INTEGER RANGE 0 TO max_count_lett; --llevara la cuentahasta el 692656 || 11082500
    SIGNAL clk_lett : STD_LOGIC := '0'; --senal para el clockde las letras de la LCD
    CONSTANT max_count_med : INTEGER := 10000; --numero maximo para lacuenta
    SIGNAL count_med : INTEGER RANGE 0 TO max_count_med; --llevara la cuentahasta el 10000
    SIGNAL clk_med : STD_LOGIC := '0'; --senal para el clockmedio
    
    PROCEDURE veriBandera(a, x, y : IN STD_LOGIC_VECTOR(15 DOWNTO 0); SIGNAL bandera :
    OUT STD_LOGIC_VECTOR(3 DOWNTO 0)) IS
BEGIN
    IF (a(14) = '1') THEN --Negative
        bandera(3) <= '1';
    ELSE
        bandera(3) <= '0';
    END IF;
    bandera(2) <= a(14) XOR x(14) XOR y(14) XOR a(15); --Overflow
    IF (a(14 DOWNTO 0) = "000000000000000") THEN --Zero
        bandera(1) <= '1';
    ELSE
        bandera(1) <= '0';
    END IF;
    IF (a(15) = '1') THEN --Carry
        bandera(0) <= '1';
    ELSE
        bandera(0) <= '0';
    END IF;
END veriBandera;

BEGIN

OSCInst0 : OSCH
GENERIC MAP(NOM_FREQ => "44.33")
PORT MAP(STDBY => '0', OSC => CLK, SEDSTDBY => OPEN);
gen_clk_medio : PROCESS (CLK) --reduccion del clock de 44.33 MHz

BEGIN
    IF (CLK'event AND CLK = '1') THEN
        IF (count_med < max_count_med) THEN
            count_med <= count_med + 1;
        ELSE
            clk_med <= NOT clk_med;
            count_med <= 0;
        END IF;
    END IF;
END PROCESS gen_clk_medio;
gen_clk_lett : PROCESS (CLK) --reduccion del clock de 44.33 MHz

BEGIN
    IF (CLK'event AND CLK = '1') THEN
        IF (count_lett < max_count_lett) THEN
            count_lett <= count_lett + 1;
        ELSE
            clk_lett <= NOT clk_lett;
            count_lett <= 0;
        END IF;
    END IF;
END PROCESS gen_clk_lett;


gen_clk_lett2 : PROCESS (CLK) --reduccion del clock de 44.33 MHz a 120 ms
BEGIN
    IF (CLK'event AND CLK = '1') THEN
        IF (count_lett2 < max_count_lett2) THEN
            count_lett2 <= count_lett2 + 1;
        ELSE
            clk_lett2 <= NOT clk_lett2;
            count_lett2 <= 0;
        END IF;
    END IF;
END PROCESS gen_clk_lett2;

dispmode <= RegsABCD(15)(0);

ControlUnit : PROCESS (Reset, PC, IR, CLK_lett, mov_pc)
BEGIN
    PC1 <= PC + 1;
    PC2 <= PC + 2;
    IF (Reset = '0') THEN
        estado <= Fetch;
        flags <= "0000";
        -- comp <= "000";
        IR <= (OTHERS => '0');
        REAUX <= (OTHERS => '0');
        REAUX2 <= (OTHERS => '0');
        MBR <= (OTHERS => '0');
        RegsABCD <= (OTHERS => "0000000000000000");
        PC <= 112;
    ELSIF (CLK_lett'event AND CLK_lett = '1') THEN
        -- elsif (CLK'event and CLK = '1' and IR /="11111111")then
        IF (mov_pc = '1') THEN
            CASE (contaux2) IS
                WHEN 97 =>
                    PC <= 133;
                    estado <= Fetch;
                WHEN 98 =>
                    PC <= 138;
                    estado <= Fetch;
                WHEN 99 =>
                    PC <= 143;
                    estado <= Fetch;
                WHEN 100 =>
                    PC <= 148;
                    estado <= Fetch;
                WHEN 101 =>
                    PC <= 153;
                    estado <= Fetch;
                WHEN OTHERS =>
                    PC <= 158;
                    estado <= Fetch;
            END CASE;
        END IF;
        CASE estado IS
            WHEN Fetch =>
                IR <= ROM_program(PC);
                MAR <= ROM_program(PC1);
                estado <= Decode;
            WHEN Decode =>
                IF (IR = "11111111") THEN
                    PC <= PC;
                    estado <= Fetch;
                ELSIF (IR = "00001011") THEN
                    -- Cargar Num a RegsABCD
                    RegsABCD(to_integer(unsigned(MAR))) <= "00000000" & ROM_program(PC2);
                    PC <= PC + 3;
                    estado <= Fetch;
                ELSIF (IR = "00001100") THEN
                    -- Cargar Dato de ROM_prog a RegsABCD
                    RegsABCD(to_integer(unsigned(MAR(7
                    DOWNTO 4)))) <= "00000000" & ROM_program(to_integer(unsigned(MAR(1 DOWNTO 0))));
                    estado <= Fetch;
                    PC <= PC + 2;
                ELSIF (IR = "00001101") THEN
                    -- Copiar Registro(orig) a Registro(dest)
                    RegsABCD(to_integer(unsigned(MAR(7
                    DOWNTO 4)))) <= RegsABCD(to_integer(unsigned(MAR(3 DOWNTO 0))));
                    estado <= Fetch;
                    PC <= PC + 2;
                ELSIF (IR = "00001110") THEN
                    -- Copiar del MBR al Registro(dest)
                    RegsABCD(to_integer(unsigned(MAR))) <= MBR;
                    estado <= Fetch;
                    PC <= PC + 2;
                ELSIF (IR = "00001111") THEN
                    -- Jump a una direccion
                    estado <= Fetch;
                    PC <= to_integer(unsigned(MAR));
                ELSIF (IR = "00010000") THEN
                    -- Branch (jump con condicion)
                    IF ((MAR(3 DOWNTO 0) XOR
                        bandera) = "0000") THEN
                        PC <=
                            to_integer(unsigned(ROM_program(PC2)));
                    ELSE
                        PC <= PC + 3;
                    END IF;
                    estado <= Fetch;
                ELSIF (IR = "00010001") THEN
                    -- Comparador
                ELSIF (IR = "00010010") THEN
                    -- Escribir del MBR a la RAM
                    RAM(to_integer(unsigned(MAR))) <=
                    MBR;
                    PC <= PC + 2;
                    estado <= Fetch;
                ELSIF (IR = "00010011") THEN
                    -- Leer de la RAM a RegsABCD
                    RegsABCD(to_integer(unsigned(MAR))) <=
                    RAM(to_integer(unsigned(RegsABCD(to_integer(unsigned(ROM_Program(PC2)))))));
                    PC <= PC + 3;
                    estado <= Fetch;
                ELSIF (IR = "00010100") THEN
                    -- Escribir de la ROM a la RAM
                    RAM(to_integer(unsigned(RegsABCD(to_integer(unsigned(MAR)))))) <= "00000000" & ROM_program(to_integer(unsigned(RegsABCD(to_integer(unsigned(ROM_Program(PC2)))))));
                    PC <= PC + 3;
                    estado <= Fetch;
                ELSIF (IR = "00010101") THEN
                    -- Omitir el resto del ciclo fetch
                ELSIF (IR = "00010110") THEN
                    RegsABCD(15)(0) <= '1';
                    PC <= PC + 1;
                    estado <= Fetch;
                ELSE
                    REAUX <=
                        signed(RegsABCD(to_integer(unsigned(MAR(7 DOWNTO 4)))));
                    REAUX2 <=
                        signed(RegsABCD(to_integer(unsigned(MAR(3 DOWNTO 0)))));
                    estado <= Execute;
                END IF;
            WHEN Execute =>
                MBR <= ACC;
                flags <= bandera;
                estado <= Fetch;
                PC <= PC + 2;
        END CASE;
    END IF;

    cuenta <= '0' & MBR(14 DOWNTO 0);
END PROCESS;


ahorcado : PROCESS (clk_lett2, izq, der, enter, line1Sig, line2Sig, mov_pc, contaux2) -- Control del ahorcado
BEGIN
    IF (clk_lett2'EVENT AND clk_lett2 = '1') THEN
        IF (reset = '0') THEN
            est <= frase;
            auxV <= "111";
            auxP <= "11111111";
            contaux <= 97;
            contaux2 <= 97;
        END IF;

        CASE est IS
            WHEN frase =>
                line1Sig <= RAM(0)(7 DOWNTO 0) &
                    RAM(1)(7
                    DOWNTO 0) &
                    RAM(2)(7
                    DOWNTO 0) &
                    RAM(3)(7
                    DOWNTO 0) &
                    RAM(4)(7
                    DOWNTO 0) &
                    RAM(5)(7
                    DOWNTO 0) &
                    RAM(6)(7
                    DOWNTO 0) &
                    RAM(7)(7
                    DOWNTO 0) &
                    RAM(8)(7
                    DOWNTO 0) &
                    RAM(9)(7
                    DOWNTO 0) &
                    RAM(10)(7
                    DOWNTO 0) &
                    RAM(11)(7
                    DOWNTO 0) &
                    RAM(12)(7
                    DOWNTO 0) &
                    RAM(13)(7
                    DOWNTO 0) &
                    RAM(14)(7
                    DOWNTO 0) &
                    RAM(15)(7
                    DOWNTO 0);
                line2Sig <= RAM(16)(7 DOWNTO 0) &
                    RAM(17)(7
                    DOWNTO 0) &
                    RAM(18)(7
                    DOWNTO 0) &
                    RAM(19)(7
                    DOWNTO 0) &
                    RAM(20)(7
                    DOWNTO 0) &
                    RAM(21)(7
                    DOWNTO 0) &
                    RAM(22)(7
                    DOWNTO 0) &
                    RAM(23)(7
                    DOWNTO 0) &
                    RAM(24)(7
                    DOWNTO 0) &
                    RAM(25)(7
                    DOWNTO 0) &
                    RAM(26)(7
                    DOWNTO 0) &
                    STD_LOGIC_VECTOR(to_unsigned(contaux, IR'length)) &
                    RAM(28)(7
                    DOWNTO 0) &
                    RAM(29)(7
                    DOWNTO 0) &
                    RAM(30)(7
                    DOWNTO 0) &
                    RAM(31)(7
                    DOWNTO 0);
                IF (izq = '1') THEN
                    IF (contaux = 97) THEN
                        contaux <= 104;
                    ELSE
                        contaux <= contaux - 1;
                    END IF;
                ELSIF (der = '1') THEN
                    IF (contaux = 104) THEN
                        contaux <= 97;
                    ELSE
                        contaux <= contaux + 1;
                    END IF;
                ELSIF (enter = '1') THEN
                    est <= palabra;
                    juego <= ini;
                    line2Sig <= "00100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000001000000010000000100000";
                    contaux2 <= contaux;
                    contaux <= 97;
                    mov_pc <= '1';
                END IF;
            WHEN palabra =>
                mov_pc <= '0';
                vidas <= auxV;
                auxP2 <= line1Sig(127 DOWNTO 40);
                CASE juego IS
                    WHEN ini =>
                        line1Sig <= RAM(0)(7
                            DOWNTO 0) &
                            RAM(1)(7 DOWNTO 0) &
                            RAM(2)(7 DOWNTO 0) &
                            RAM(3)(7 DOWNTO 0) &
                            RAM(4)(7 DOWNTO 0) &
                            RAM(5)(7 DOWNTO 0) &
                            RAM(6)(7 DOWNTO 0) &
                            RAM(7)(7 DOWNTO 0) &
                            RAM(8)(7 DOWNTO 0) &
                            RAM(9)(7 DOWNTO 0) &
                            RAM(10)(7 DOWNTO 0) &
                            RAM(11)(7 DOWNTO 0) &
                            RAM(12)(7 DOWNTO 0) &
                            RAM(13)(7 DOWNTO 0) &
                            RAM(14)(7 DOWNTO 0) &
                            RAM(15)(7 DOWNTO 0);
                        line2Sig(119 DOWNTO 112)
                        <= STD_LOGIC_VECTOR(to_unsigned(contaux, IR'length));
                    WHEN veri =>
                        CASE (contaux2) IS
                            WHEN 97 =>
                                IF (auxV /= "000") THEN
                                    IF (auxP2 = "0110100101101101011011010110010101100100011010010110000101110100011001010110110001111001") THEN -- immediately
                                        juego <= win;
                                    ELSE
                                        IF (auxP = "01101101") THEN -- m
                                            auxP1(79 DOWNTO 72) <= "01101101";
                                            auxP1(71 DOWNTO 64) <= "01101101";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01100100") THEN -- d
                                            auxP1(55 DOWNTO 48) <= "01100100";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01100001") THEN -- a
                                            auxP1(39 DOWNTO 32) <= "01100001";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01100101") THEN -- e
                                            auxP1(23 DOWNTO 16) <= "01100101";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01101100") THEN -- l
                                            auxP1(15 DOWNTO 8) <= "01101100";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "11111111") THEN
                                            auxP1 <= auxP1;
                                        ELSE
                                            auxP <= "11111111";
                                            auxP1 <= auxP1;
                                            auxV <= to_stdlogicvector(to_bitvector(auxV) SRL 1);
                                            contaux <= 97;
                                        END IF;
                                        line1Sig(127 DOWNTO 40) <= auxP1;
                                    END IF;
                                    ELSE
                                        juego <= lose;
                                END IF;
                            WHEN 98 =>
                                IF (auxV /= "000") THEN
                                    IF (auxP2 = "0110100001101111011101010111001101100101001000000010000000100000001000000010000000100000") THEN -- house
                                        line1Sig <= line1Sig;
                                        juego <= win;
                                    ELSE
                                        IF (auxP = "01101000") THEN -- h
                                            auxP1(87 DOWNTO 80) <= "01101000";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01110101") THEN -- u
                                            auxP1(71 DOWNTO 64) <= "01110101";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01100101") THEN -- e
                                            auxP1(55 DOWNTO 48) <= "01100101";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "11111111") THEN
                                                auxP1 <= auxP1;
                                        ELSE
                                            auxP <= "11111111";
                                            auxP1 <= auxP1;
                                            auxV <= to_stdlogicvector(to_bitvector(auxV) SRL 1);
                                            contaux <= 97;
                                        END IF;
                                        line1Sig(127 DOWNTO 40) <= auxP1;
                                    END IF;
                                ELSE
                                    juego <= lose;
                                END IF;
                            WHEN 99 =>
                                IF (auxV /= "000") THEN
                                    IF (auxP2 = "0111010001100001011000100110110001100101001000000010000000100000001000000010000000100000") THEN -- table
                                        line1Sig <= line1Sig;
                                        juego <= win;
                                    ELSE
                                        IF (auxP = "01100001") THEN -- a
                                            auxP1(79 DOWNTO 72) <= "01100001";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01101100") THEN -- l
                                            auxP1(63 DOWNTO 56) <= "01101100";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "11111111") THEN
                                            auxP1 <= auxP1;
                                        ELSE
                                            auxP <= "11111111";
                                            auxP1 <= auxP1;
                                            auxV <= to_stdlogicvector(to_bitvector(auxV) SRL 1);
                                            contaux <= 97;
                                        END IF;
                                        line1Sig(127 DOWNTO 40) <= auxP1;
                                    END IF;
                                ELSE
                                    juego <= lose;
                                END IF;
                            WHEN 100 =>
                                IF (auxV /= "000") THEN
                                    IF (auxP2 = "0111001101100011011010000110111101101111011011000010000000100000001000000010000000100000") THEN -- school
                                        line1Sig <= line1Sig;
                                        juego <= win;
                                    ELSE
                                        IF (auxP = "01100011") THEN -- c
                                            auxP1(79 DOWNTO 72) <= "01100011";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01101111") THEN -- o
                                            auxP1(55 DOWNTO 48) <= "01101111";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "11111111") THEN
                                            auxP1 <= auxP1;
                                        ELSE
                                            auxP <= "11111111";
                                            auxP1 <= auxP1;
                                            auxV <= to_stdlogicvector(to_bitvector(auxV) SRL 1);
                                            contaux <= 97;
                                        END IF;
                                            line1Sig(127 DOWNTO 40) <= auxP1;
                                    END IF;
                                ELSE
                                    juego <= lose;
                                END IF;
                            WHEN 101 =>
                                IF (auxV /= "000") THEN
                                    IF (auxP2 = "0111010101101110011001000110010101110010011100110111010001100001011011100110010000100000") THEN -- understand
                                        juego <= win;
                                    ELSE
                                        IF (auxP = "01101110") THEN -- n
                                            auxP1(79 DOWNTO 72) <= "01101110";
                                            auxP1(23 DOWNTO 16) <= "01101110";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01110010") THEN -- r
                                            auxP1(55 DOWNTO 48) <= "01110010";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01110100") THEN -- t
                                            auxP1(39 DOWNTO 32) <= "01110100";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "11111111") THEN
                                            auxP1 <= auxP1;
                                        ELSE
                                            auxP <= "11111111";
                                            auxP1 <= auxP1;
                                            auxV <= to_stdlogicvector(to_bitvector(auxV) SRL 1);
                                            contaux <= 97;
                                        END IF;
                                        line1Sig(127 DOWNTO 40) <= auxP1;
                                    END IF;
                                ELSE
                                    juego <= lose;
                                END IF;
                            WHEN 102 =>
                                IF (auxV /= "000") THEN
                                    IF (auxP2 = "0110001001100001011011010110001001101001001000000010000000100000001000000010000000100000") THEN -- bambi
                                        juego <= win;
                                        
                                    ELSE
                                        IF (auxP = "01100001") THEN -- a
                                            auxP1(79 DOWNTO 72) <= "01100001";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01100010") THEN -- b
                                            auxP1(63 DOWNTO 56) <= "01100010";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "11111111") THEN
                                            auxP1 <= auxP1;
                                        ELSE
                                            auxP <= "11111111";
                                            auxP1 <= auxP1;
                                            auxV <= to_stdlogicvector(to_bitvector(auxV) SRL 1);
                                            contaux <= 97;
                                        END IF;
                                        line1Sig(127 DOWNTO 40) <= auxP1;

                                    END IF;
                                ELSE
                                    juego <= lose;
                                END IF;
                            WHEN 103 =>
                                IF (auxV /= "000") THEN
                                    IF (auxP2 = "0110011001110010011010010110010101101110011001000010000000100000001000000010000000100000") THEN -- friend
                                        juego <= win;
                                        
                                    ELSE
                                        IF (auxP = "01100110") THEN -- f
                                            auxP1(87 DOWNTO 80) <= "01100110";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01101001") THEN -- i
                                            auxP1(71 DOWNTO 64) <= "01101001";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01101110") THEN -- n
                                            auxP1(55 DOWNTO 48) <= "01101110";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "11111111") THEN
                                            auxP1 <= auxP1;
                                        ELSE
                                            auxP <= "11111111";
                                            auxP1 <= auxP1;
                                            auxV <= to_stdlogicvector(to_bitvector(auxV) SRL 1);
                                            contaux <= 97;
                                        END IF;
                                        line1Sig(127 DOWNTO 40) <= auxP1;

                                    END IF;
                                ELSE
                                    juego <= lose;
                                END IF;

                            WHEN OTHERS =>
                                IF (auxV /= "000") THEN
                                    IF (auxP2 = "0110001101101111011011010111000001110101011101000110010101110010001000000010000000100000") THEN -- computer
                                        juego <= win;
                                        
                                    ELSE
                                        IF (auxP = "01101111") THEN -- o
                                            auxP1(79 DOWNTO 72) <= "01101111";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01101101") THEN -- m
                                            auxP1(71 DOWNTO 64) <= "01101101";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01110100") THEN -- t
                                            auxP1(47 DOWNTO 40) <= "01110100";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "01100101") THEN -- e
                                            auxP1( 39 DOWNTO 32) <= "01100101";
                                            auxP <= "11111111";
                                            contaux <= 97;
                                        ELSIF (auxP = "11111111") THEN
                                            auxP1 <= auxP1;
                                        ELSE
                                            auxP <= "11111111";
                                            auxP1 <= auxP1;
                                            auxV <= to_stdlogicvector(to_bitvector(auxV) SRL 1);
                                            contaux <= 97;
                                        END IF;
                                        line1Sig(127 DOWNTO 40) <= auxP1;

                                    END IF;
                                ELSE
                                    juego <= lose;
                                END IF;
                        END CASE;

                        line2Sig(119 DOWNTO 112) <= STD_LOGIC_VECTOR(to_unsigned(contaux, IR'length));
                            
                    WHEN win =>
                        line2Sig(119 DOWNTO 56) <=
                        "0111011101101001011011100010000100100001001000010010000100100001";--Palabra win!!!
                            
                    WHEN lose => line2Sig(119 DOWNTO 48) <= 
                        "011011000110111101110011011001010010000100100001001000010010000100100001";--Palabra lose!!!
                            
                END CASE;
                            
                    IF (izq = '1') THEN
                        IF (contaux = 97) THEN
                            contaux <= 122;
                        ELSE
                            contaux <= contaux - 1;
                        END IF;
                    ELSIF (der = '1') THEN
                        IF (contaux = 122) THEN
                            contaux <= 97;
                        ELSE
                            contaux <= contaux + 1;
                        END IF;
                    ELSIF (enter = '1') THEN
                        juego <= veri;
                        auxP <= STD_LOGIC_VECTOR(to_unsigned(contaux, IR'length));
                        auxP1 <= line1Sig(127 DOWNTO 40);
                    END IF;
        END CASE;
    END IF;
END PROCESS ahorcado;


regALU : PROCESS (IR, REAUX, REAUX2) -- ALU
    VARIABLE shift : STD_LOGIC_VECTOR(15 DOWNTO 0);
    VARIABLE desplazamientos : INTEGER;

BEGIN
    CASE IR IS
        WHEN "00000001" => ACC <= STD_LOGIC_VECTOR(NOT REAUX);

        WHEN "00000010" => ACC <= STD_LOGIC_VECTOR(REAUX AND REAUX2);
        
        WHEN "00000011" => ACC <= STD_LOGIC_VECTOR((NOT REAUX) + 1);
        
        WHEN "00000100" => ACC <= STD_LOGIC_VECTOR(REAUX OR REAUX2);
        
        WHEN "00000111" => ACC <= STD_LOGIC_VECTOR(REAUX + REAUX2); --S U M A
            veriBandera(ACC, STD_LOGIC_VECTOR(REAUX), STD_LOGIC_VECTOR(REAUX2), bandera);
        
        WHEN "00001000" => -- REAUX3 <= REAUX-REAUX2;
            --R E S T A
            REAUX3(14 DOWNTO 0) <= (NOT REAUX2(14 DOWNTO 0)) + 1; --complemento a 2
            IF ((REAUX(14) XOR REAUX3(14)) = '1') THEN
                ACC <= STD_LOGIC_VECTOR(REAUX - REAUX2);
                veriBandera(ACC, STD_LOGIC_VECTOR(REAUX), STD_LOGIC_VECTOR(REAUX2), bandera);

            ELSE
                ACC <= STD_LOGIC_VECTOR(((NOT REAUX) + 1) + REAUX2);
                REAUX3 <= REAUX + ((NOT REAUX2) + 1);
                veriBandera(STD_LOGIC_VECTOR(REAUX3), STD_LOGIC_VECTOR(REAUX), STD_LOGIC_VECTOR((NOT REAUX2) + 1), bandera);

            END IF;
        WHEN OTHERS => ACC <= (OTHERS => '0');
    END CASE;
END PROCESS;

contLCD : PROCESS (clk, reset, line1Sig, line2Sig, dispmode) -- Interfaz de laLCD
    VARIABLE count : INTEGER := 0;
BEGIN
    IF (Reset = '0') THEN
        state <= power_up;
    ELSIF (clk'EVENT AND clk = '1') THEN
        CASE state IS
            WHEN power_up => --wait 50 ms to ensure Vddhas risen and required LCD wait is met
                IF (count < (50000 * freq)) THEN --wait50 ms
                    count := count + 1;
                    state <= power_up;
                ELSE --power-up complete
                    count := 0;
                    RS <= '0';
                    RW <= '0';
                    DB <= "00110000";
                    state <= initialize;
                END IF;
            
            WHEN initialize => --cycle throughinitialization sequence
                count := count + 1;
                IF (count < (10 * freq)) THEN --function set
                    DB <= "00111100"; --2-linemode, display on
                    E <= '1';
                    state <= initialize;
                ELSIF (count < (60 * freq)) THEN --wait50 us
                    DB <= "00000000";
                    E <= '0';
                    state <= initialize;
                ELSIF (count < (70 * freq)) THEN --display on/off control
                    DB <= "00001100"; --displayon, cursor off, blink off
                    E <= '1';
                    state <= initialize;
                ELSIF (count < (120 * freq)) THEN --wait50 us
                    DB <= "00000000";
                    E <= '0';
                    state <= initialize;
                ELSIF (count < (130 * freq)) THEN --display clear
                    DB <= "00000001";
                    E <= '1';
                    state <= initialize;
                ELSIF (count < (2130 * freq)) THEN --wait2 ms
                    DB <= "00000000";
                    E <= '0';
                    state <= initialize;
                ELSIF (count < (2140 * freq)) THEN --entrymode set
                    DB <= "00000110"; --incrementmode, entire shift off
                    E <= '1';
                    state <= initialize;
                ELSIF (count < (2200 * freq)) THEN --wait60 us
                    DB <= "00000000";
                    E <= '0';
                    state <= initialize;
                ELSE --initialization complete
                    count := 0;
                    state <= RESETLINE;
                END IF;
            
            WHEN RESETLINE =>
                ptr <= 16;
                IF line = '1' THEN
                    DB <= "10000000";
                    RS <= '0';
                    RW <= '0';
                    count := 0;
                    state <= send;
                ELSE
                    DB <= "11000000";
                    RS <= '0';
                    RW <= '0';
                    count := 0;
                    state <= send;
                END IF;
        
            WHEN line1 =>
                line <= '1';
                IF dispmode = '1' AND (ptr = 6 OR ptr = 7) THEN
                    IF ptr = 7 THEN
                        DB <= "0011" & bcdsig(7 DOWNTO 4);
                    ELSE
                        DB <= "0011" & bcdsig(3 DOWNTO 0);
                    END IF;
                ELSE
                    DB <= line1Sig(ptr * 8 + 7 DOWNTO ptr * 8);
                END IF;
                    RS <= '1';
                    RW <= '0';
                    count := 0;
                    line <= '1';
                    state <= send;
                WHEN line2 =>
                    line <= '0';
                    DB <= line2Sig(ptr * 8 + 7 DOWNTO ptr * 8);
                    RS <= '1';
                    RW <= '0';
                    count := 0;
                    state <= send;
                WHEN send => --send instruction to lcd
                    IF (count < (50 * freq)) THEN --do notexit for 50us
                        IF (count < freq) THEN --negative enable
                            E <= '0';
                        ELSIF (count < (14 * freq)) THEN --positive enable half-cycle
                            E <= '1';
                        ELSIF (count < (27 * freq)) THEN --negative enable half-cycle
                            E <= '0';
                        END IF;
                            count := count + 1;
                            state <= send;
                    ELSE
                        count := 0;
                        IF line = '1' THEN
                            IF ptr = 0 THEN
                                line <= '0';
                                state <= resetline;
                            ELSE
                                ptr <= ptr - 1;
                                state <= line1;
                            END IF;
                        ELSE
                            IF ptr = 0 THEN
                                line <= '1';
                                state <= resetline;
                            ELSE
                                ptr <= ptr - 1;
                                state <= line2;
                            END IF;
                        END IF;
                    END IF;
        END CASE;
    END IF;
END PROCESS contLCD;

END programa;