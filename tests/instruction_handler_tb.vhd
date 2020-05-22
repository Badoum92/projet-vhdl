library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;
    use IEEE.std_logic_signed.all;


entity INSTRUCTION_HANDLER_TB IS
port
(
    OK : out boolean := TRUE
);
end entity;


architecture Bench of INSTRUCTION_HANDLER_TB is
    signal CLK : std_logic := '0';
    signal RST : std_logic := '0';
    signal nPCsel : std_logic;
    signal offset24 : std_logic_vector(23 downto 0);
    signal instr : std_logic_vector(31 downto 0);
begin
    process
    begin
        while now < 100 ns loop
            CLK <= '0';
            wait for 5 ns;
            CLK <= '1';
            wait for 5 ns;
        end loop;
        wait;
    end process;

    INSTR_HANDLER_TEST : entity work.INSTR_HANDLER
    port map
    (
        CLK => CLK,
        RST => RST,
        nPCsel => nPCsel,
        offset24 => offset24,
        instr => instr
    );

    process
    begin
        nPCsel <= '0';
        offset24 <= (others => '0');
        instr <= (others => 'Z');

        RST <= '1';
        wait for 10 ns;
        RST <= '0';

        -- PC = 0 x"E3A01020"
        OK <= instr = x"E3A01020";
        wait for 10 ns;
        -- PC = 1 x"E3A02000"
        OK <= instr = x"E3A02000";
        wait for 10 ns;
        -- PC = 2 x"E6110000"
        OK <= instr = x"E6110000";
        wait for 10 ns;

        -- PC = 3 x"E0822000"
        OK <= instr = x"E0822000";
        nPCsel <= '1';
        offset24 <= std_logic_vector(to_signed(-2, 24));

        wait for 10 ns;
        -- PC = 2 x"E6110000"
        OK <= instr = x"E6110000";
        wait for 10 ns;
        -- PC = 1 x"E3A02000"
        OK <= instr = x"E3A02000";
        wait for 10 ns;
        -- PC = 0 x"E3A01020"
        OK <= instr = x"E3A01020";
        nPCsel <= '0';

        wait;
    end process;
end architecture;
