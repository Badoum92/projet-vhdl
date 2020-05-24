library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;
    use IEEE.std_logic_signed.all;

library modelsim_lib;
use modelsim_lib.util.all;


entity CPU_TB IS
port
(
    OK : out boolean := TRUE
);
end entity;


architecture Bench of CPU_TB is
    signal CLK : std_logic := '0';
    signal RST : std_logic := '0';
    signal spy_nPCsel : std_logic;
    signal spy_Offset : std_logic_vector(23 downto 0);
    signal spy_Instruction : std_logic_vector(31 downto 0);
    signal spy_Rn : std_logic_vector(3 downto 0);
    signal spy_Rd : std_logic_vector(3 downto 0);
    signal spy_Rm : std_logic_vector(3 downto 0);
    signal spy_Rb : std_logic_vector(3 downto 0);
    signal spy_Imm : std_logic_vector(7 downto 0);
    signal spy_RegWR : std_logic;
    signal spy_ALUSrc : std_logic;
    signal spy_ALUctr  : std_logic_vector(1 downto 0);
    signal spy_PSREn : std_logic;
    signal spy_MemWR  : std_logic;
    signal spy_WrSrc : std_logic;
    signal spy_RegSel  : std_logic;
    signal spy_PSRDATA : std_logic_vector(31 downto 0);
    signal spy_PSRIN : std_logic_vector(31 downto 0);
begin

    process
    begin
        init_signal_spy("/cpu_tb/cpu_test/nPCsel", "spy_nPCsel");
        init_signal_spy("/cpu_tb/cpu_test/Offset", "spy_Offset");
        init_signal_spy("/cpu_tb/cpu_test/Instruction", "spy_Instruction");
        init_signal_spy("/cpu_tb/cpu_test/Rn", "spy_Rn");
        init_signal_spy("/cpu_tb/cpu_test/Rd", "spy_Rd");
        init_signal_spy("/cpu_tb/cpu_test/Rm", "spy_Rm");
        init_signal_spy("/cpu_tb/cpu_test/Rb", "spy_Rb");
        init_signal_spy("/cpu_tb/cpu_test/Imm", "spy_Imm");
        init_signal_spy("/cpu_tb/cpu_test/RegWR", "spy_RegWR");
        init_signal_spy("/cpu_tb/cpu_test/ALUSrc", "spy_ALUSrc");
        init_signal_spy("/cpu_tb/cpu_test/ALUctr", "spy_ALUctr");
        init_signal_spy("/cpu_tb/cpu_test/PSREn", "spy_PSREn");
        init_signal_spy("/cpu_tb/cpu_test/MemWR", "spy_MemWR");
        init_signal_spy("/cpu_tb/cpu_test/WrSrc", "spy_WrSrc");
        init_signal_spy("/cpu_tb/cpu_test/RegSel", "spy_RegSel");
        init_signal_spy("/cpu_tb/cpu_test/PSRDATA", "spy_PSRDATA");
        init_signal_spy("/cpu_tb/cpu_test/PSRIN", "spy_PSRIN");
        wait;
    end process;

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
        RST => RST
    );

    process
    begin
        RST <= '1';
        wait for 10 ns;
        RST <= '0';

        OK <= spy_nPCsel = '0';
        wait for 10 ns;

        wait;
    end process;
end architecture;
