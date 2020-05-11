library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;


entity ALU_REGBENCH_TB IS
port
(
    OK : out boolean := TRUE
);
end ALU_REGBENCH_TB;


architecture Bench of ALU_REGBENCH_TB is
    signal CLK : std_logic := '0';
    signal RST : std_logic := '0';
    signal W   : std_logic_vector(31 downto 0);
    signal RA  : std_logic_vector(3 downto 0);
    signal RB  : std_logic_vector(3 downto 0);
    signal RW  : std_logic_vector(3 downto 0);
    signal WE  : std_logic;
    signal A   : std_logic_vector(31 downto 0);
    signal B   : std_logic_vector(31 downto 0);
    signal OP  : std_logic_vector(1 downto 0);
    signal N   : std_logic;
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
        WE => WE,
        A => A,
        B => B
    );

    ALU_TEST : entity work.ALU
    port map
    (
        OP => OP,
        A => A,
        B => B,
        S => W
    );

    process
    begin
        N <= 'Z';
        W <= (others => 'Z');
        RA <= (others => 'Z');
        RB <= (others => 'Z');
        RW <= (others => 'Z');
        WE <= '0';
        A <= (others => 'Z');
        B <= (others => 'Z');
        OP <= (others => 'Z');

        RST <= '1';
        wait for 10 ns;

        RST <= '0';
        RA <= std_logic_vector(to_unsigned(15, 4));
        RB <= std_logic_vector(to_unsigned(1, 4));
        OP <= "11";
        wait for 10 ns;

        RW <= std_logic_vector(to_unsigned(1, 4));
        WE <= '1';
        wait for 10 ns;

        OK <= A = B;
        WE <= '0';
        wait for 10 ns;

        wait;
    end process;
end Bench;
