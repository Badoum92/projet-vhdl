library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity INSTR_HANDLER is
port
(
    CLK    : in std_logic;
    RST    : in std_logic;
    nPCsel : in std_logic;
    offset24 : in std_logic_vector(23 downto 0);
    instr  : out std_logic_vector(31 downto 0)
);
end entity INSTR_HANDLER;

architecture ARCH of INSTR_HANDLER is
    signal PC : std_logic_vector(31 downto 0) := (others => '0');
    signal PC1 : std_logic_vector(31 downto 0) := (others => '0');
    signal PC1offset : std_logic_vector(31 downto 0) := (others => '0');
    signal PCres : std_logic_vector(31 downto 0) := (others => '0');
    signal offset32 : std_logic_vector(31 downto 0) := (others => '0');
begin
    INSTR_MEM : entity work.instruction_memory
    port map
    (
        PC => PC,
        Instruction => instr
    );

    SIGN_EXT : entity work.SIGNED_EXTENSION
    generic map (N => 24)
    port map
    (
        E => offset24,
        S => offset32
    );

    MUX : entity work.MUX21
    generic map (N => 32)
    port map
    (
        A => PC1,
        B => PC1offset,
        COM => nPCsel,
        S => PCres
    );

    process(RST, CLK)
    begin
        if RST = '1' then
            PC <= (others => '0');
        elsif rising_edge(CLK) then
            PC <= PCres;
        end if;
    end process;

    PC1 <= PC + 1;
    PC1offset <= PC1 + offset32;

end architecture ARCH;