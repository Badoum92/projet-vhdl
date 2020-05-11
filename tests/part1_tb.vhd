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

        wait;
    end process;
end architecture;
