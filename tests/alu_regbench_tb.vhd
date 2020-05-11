library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;
    use IEEE.std_logic_signed.all;


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
        while now < 300 ns loop
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
        S => W,
        N => N
    );

    process
        type table is array(15 downto 0) of std_logic_vector(31 downto 0);
        variable reg : table;
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

        ----------
        RA <= std_logic_vector(to_unsigned(1, 4));
        RB <= std_logic_vector(to_unsigned(15, 4));
        OP <= "11";
        wait for 10 ns;

        reg(1) := W;
        RW <= std_logic_vector(to_unsigned(1, 4));
        WE <= '1';
        wait for 10 ns;

        WE <= '0';
        wait for 10 ns;
        ----------
        RA <= std_logic_vector(to_unsigned(1, 4));
        RB <= std_logic_vector(to_unsigned(15, 4));
        OP <= "00";
        wait for 10 ns;

        reg(1) := W;
        RW <= std_logic_vector(to_unsigned(1, 4));
        WE <= '1';
        wait for 10 ns;

        OK <= W = (A + B);
        WE <= '0';
        wait for 10 ns;
        ----------
        RA <= std_logic_vector(to_unsigned(1, 4));
        RB <= std_logic_vector(to_unsigned(15, 4));
        OP <= "00";
        wait for 10 ns;

        reg(2) := W;
        RW <= std_logic_vector(to_unsigned(2, 4));
        WE <= '1';
        wait for 10 ns;

        OK <= W = (A + B);
        WE <= '0';
        wait for 10 ns;
        ----------
        RA <= std_logic_vector(to_unsigned(1, 4));
        RB <= std_logic_vector(to_unsigned(15, 4));
        OP <= "10";
        wait for 10 ns;

        reg(3) := W;
        RW <= std_logic_vector(to_unsigned(3, 4));
        WE <= '1';
        wait for 10 ns;

        OK <= W = (A - B);
        WE <= '0';
        wait for 10 ns;
        ----------
        RA <= std_logic_vector(to_unsigned(7, 4));
        RB <= std_logic_vector(to_unsigned(15, 4));
        OP <= "10";
        wait for 10 ns;

        reg(5) := W;
        RW <= std_logic_vector(to_unsigned(5, 4));
        WE <= '1';
        wait for 10 ns;

        OK <= W = (A - B);
        WE <= '0';
        wait for 10 ns;
        ----------

        RA <= std_logic_vector(to_unsigned(1, 4));
        RB <= std_logic_vector(to_unsigned(15, 4));
        OP <= "11";
        wait for 10 ns;
        OK <= reg(1) = W;
        wait for 10 ns;

        RA <= std_logic_vector(to_unsigned(2, 4));
        RB <= std_logic_vector(to_unsigned(15, 4));
        OP <= "11";
        wait for 10 ns;
        OK <= reg(2) = W;
        wait for 10 ns;

        RA <= std_logic_vector(to_unsigned(3, 4));
        RB <= std_logic_vector(to_unsigned(15, 4));
        OP <= "11";
        wait for 10 ns;
        OK <= reg(3) = W;
        wait for 10 ns;

        RA <= std_logic_vector(to_unsigned(5, 4));
        RB <= std_logic_vector(to_unsigned(15, 4));
        OP <= "11";
        wait for 10 ns;
        OK <= reg(5) = W;
        wait for 10 ns;

        wait;
    end process;
end Bench;
