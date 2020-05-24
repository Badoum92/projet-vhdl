library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;
    use IEEE.std_logic_signed.all;


entity CPU_TB IS
port
(
    OK : out boolean := TRUE
);
end entity;


architecture Bench of CPU_TB is
    signal CLK : std_logic := '0';
    signal RST : std_logic := '0';
    signal nPCsel : std_logic;
    signal Offset : std_logic_vector(23 downto 0);
    signal Instruction : std_logic_vector(31 downto 0);
    signal Rn : std_logic_vector(3 downto 0);
    signal Rd : std_logic_vector(3 downto 0);
    signal Rm : std_logic_vector(3 downto 0);
    signal Rb : std_logic_vector(3 downto 0);
    signal Imm : std_logic_vector(7 downto 0);
    signal RegWR : std_logic;
    signal ALUSrc : std_logic;
    signal ALUctr  : std_logic_vector(1 downto 0);
    signal PSREn : std_logic;
    signal MemWR  : std_logic;
    signal WrSrc : std_logic;
    signal RegSel  : std_logic;
    signal PSRDATA : std_logic_vector(31 downto 0) := (others => 'Z');
    signal PSRIN : std_logic_vector(31 downto 0) := (others => 'Z');
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

    CPU_TEST : entity work.CPU
    port map
    (
        CLK => CLK,
        RST => RST,
        nPCsel => nPCsel,
        Offset => Offset,
        Instruction => Instruction,
        Rn => Rn,
        Rd => Rd,
        Rm => Rm,
        Rb => Rb,
        Imm => Imm,
        RegWR => RegWR,
        ALUSrc => ALUSrc,
        ALUctr => ALUctr,
        PSREn => PSREn,
        MemWR => MemWR,
        WrSrc => WrSrc,
        RegSel => RegSel,
        PSRDATA => PSRDATA,
        PSRIN => PSRIN
    );

    process
    begin
        RST <= '1';
        wait for 10 ns;
        RST <= '0';

        OK <= nPCsel = '0';
        wait for 10 ns;

        wait;
    end process;
end architecture;
