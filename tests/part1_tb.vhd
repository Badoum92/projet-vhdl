library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity PART1_TB IS
port
(
    OK : out boolean := TRUE
);
end;

architecture Bench of PART1_TB is
    signal CLK : std_logic := '0';
    signal RST : std_logic := '0';

    -- registers bench
    signal W   : std_logic_vector(31 downto 0);
    signal RA  : std_logic_vector(3 downto 0);
    signal RB  : std_logic_vector(3 downto 0);
    signal RW  : std_logic_vector(3 downto 0);
    signal RegWE  : std_logic;
    signal A   : std_logic_vector(31 downto 0);
    signal B   : std_logic_vector(31 downto 0);

    -- Imm
    signal Imm : std_logic_vector(7 downto 0);
    signal ImmExtented : std_logic_vector(31 downto 0);

    -- ALU input
    signal AluInBCom : std_logic;                        -- select between ImmExtented and Register B
    signal AluInB : std_logic_vector(31 downto 0);       -- ALU 2nd input


    -- ALU
    signal OP  : std_logic_vector(1 downto 0);
    signal N   : std_logic;
    signal AluOut : std_logic_vector(31 downto 0);

    -- Memory
    signal MemWE  : std_logic;
    signal DataOut : std_logic_vector(31 downto 0);

    -- register W
    signal RegWCom : std_logic;                          -- select between AluOut and DataOut

begin
    process
    begin
        while Now < 200 ns loop
            CLK <= '0';
            wait for 5 ns;
            CLK <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    REGISTER_BENCH_TEST : entity work.REGISTER_BENCH
    port map
    (
        CLK => CLK,
        RST => RST,
        W => W,
        RA => RA,
        RB => RB,
        RW => RW,
        WE => RegWE,
        A => A,
        B => B
    );

    SIGN_EXTENDER : entity work.SIGNED_EXTENSION
    port map
    (
        E => Imm,
        S => ImmExtented
    );

    ALU_IN_B_MUX : entity work.MUX21
    generic map (N => 32)
    port map
    (
        A => B,
        B => ImmExtented,
        COM => AluInBCom,
        S => AluInB
    );

    ALU_TEST : entity work.ALU
    port map
    (
        OP => OP,
        A => A,
        B => AluInB,
        S => AluOut
    );

    MEMORY : entity work.MEMORY
    port map
    (
        CLK => CLK,
        DATAIN => B,
        ADDR => AluOut(5 downto 0),
        WE => MemWE,
        DATAOUT => DataOut
    );


    REG_W_MUX : entity work.MUX21
    generic map (N => 32)
    port map
    (
        A => AluOut,
        B => DataOut,
        COM => RegWCom,
        S => W
    );

    process
    begin
        Ok <= TRUE;
        RST <= '1';

        W <= (others => 'Z');
        RA <= (others => 'Z');
        RB <= (others => 'Z');
        RW <= (others => 'Z');
        RegWE <= '0';
        A <= (others => 'Z');
        B <= (others => 'Z');

        Imm <= (others => 'Z');
        ImmExtented <= (others => 'Z');
        AluInBCom <= '0';
        AluInB <= (others => 'Z');

        OP <= "11";
        N <= 'Z';
        AluOut <= (others => 'Z');

        MemWE <= '0';
        DataOut <= (others => 'Z');
        RegWCom <= '0';

        wait for 10 ns;

        RST <= '0';
        -- tests
        wait for 10 ns;

        -- L’addition d’1 registre avec une valeur immédiate
        Imm <= "00000010";
        RegWE <= '0';
        MemWE <= '0';
        RA <= "0001";
        RB <= (others => '0');
        RW <= (others => '0');
        AluInBCom <= '1'; -- select imm
        RegWCom <= '0';
        OP <= "00"; -- addition
        wait for 10 ns;

        Ok <= AluOut = X"00000002";

        -- ecrit AluOut dans Registre 0
        RegWE <= '1';
        wait for 10 ns;
        -- reg0  = X"00000002"
        -- reg15 = X"00000030"

        -- L’addition de 2 registres
        RegWE <= '0';
        MemWE <= '0';
        RA <= "0000";
        RB <= "1111";
        RW <= (others => '0');
        AluInBCom <= '0'; -- select 2nd reg
        RegWCom <= '0';
        OP <= "00"; -- addition
        wait for 10 ns;

        Ok <= AluOut = X"00000032";

        -- La soustraction de 2 registres
        RegWE <= '0';
        MemWE <= '0';
        RA <= "1111";
        RB <= "0000";
        RW <= (others => '0');
        AluInBCom <= '0'; -- select 2nd reg
        RegWCom <= '0';
        OP <= "10"; -- soustraction
        wait for 10 ns;

        Ok <= AluOut = X"0000002E";

        -- La soustraction d’1 valeur immédiate à 1 registre
        Imm <= "00000001";
        RegWE <= '0';
        MemWE <= '0';
        RA <= "1111";
        RB <= (others => '0');
        RW <= (others => '0');
        AluInBCom <= '1'; -- select imm
        RegWCom <= '0';
        OP <= "10"; -- addition
        wait for 10 ns;

        Ok <= AluOut = X"0000002F";

        -- La copie de la valeur d’un registre dans un autre registre
        RegWE <= '1';
        MemWE <= '0';
        RA <= "1111";
        RB <= "0010";
        RW <= "0010";
        AluInBCom <= '0'; -- select 2nd reg
        RegWCom <= '0';
        OP <= "11"; -- keep A
        wait for 10 ns;

        RegWE <= '0';
        Ok <= A = B;
        wait for 10 ns;

        -- L’écriture d’un registre dans un mot de la mémoire.
        Imm <= "00001111";
        RegWE <= '0';
        MemWE <= '1';
        RA <= "0000";
        RB <= "1111";
        RW <= "0010";
        AluInBCom <= '1'; -- select 2nd reg
        RegWCom <= '0';
        OP <= "01"; -- keep B
        wait for 10 ns;

        -- La lecture d’un mot de la mémoire dans un registre.
        Imm <= "00001111";
        RegWE <= '1';
        MemWE <= '0';
        RA <= "0111";
        RB <= "1111";
        RW <= "0111";
        AluInBCom <= '1'; -- select 2nd reg
        RegWCom <= '1'; -- W = DataOut
        OP <= "01"; -- keep B
        wait for 10 ns;

        Ok <= A = B;
        wait for 10 ns;
        Ok <= A = X"00000030";

        wait;
    end process;
end architecture;
