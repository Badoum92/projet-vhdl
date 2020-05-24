library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;


entity CPU is
port
(
    CLK    : in std_logic;
    RST    : in std_logic
);
end entity;

architecture ARCH of CPU is

    signal nPCsel : std_logic;
    signal Offset : std_logic_vector(23 downto 0);
    signal Instruction : std_logic_vector(31 downto 0);

    signal Rn : std_logic_vector(3 downto 0);
    signal Rd : std_logic_vector(3 downto 0);
    signal Rm : std_logic_vector(3 downto 0);
    signal Rb : std_logic_vector(3 downto 0);
    signal Imm : std_logic_vector(7 downto 0);

    signal RegWR : std_logic;
    signal ALUSrc : std_logic; -- select between immediate or register B for ALU 2nd input
    signal ALUctr  : std_logic_vector(1 downto 0);
    signal PSREn : std_logic;
    signal MemWR  : std_logic;
    signal WrSrc : std_logic;  -- select between AluOut or DataOut for busW
    signal RegSel  : std_logic;

    signal PSRDATA : std_logic_vector(31 downto 0) := (others => '0');
    signal PSRIN : std_logic_vector(31 downto 0) := (others => '0');

begin

    INSTR_HANDLER : entity work.INSTR_HANDLER
    port map
    (
        CLK => CLK,
        RST => RST,
        nPCsel => nPCsel,
        offset24 => Offset,
        instr => Instruction
    );

    INSTR_DECODER : entity work.INSTR_DECODER
    port map
    (
        CLK => CLK,
        RST => RST,

        PSR => PSRDATA,
        Instruction => Instruction,

        nPCsel => nPCsel,
        RegWR => RegWR,
        ALUSrc => ALUSrc,
        ALUctr => ALUctr,
        PSREn => PSREn,
        MemWR  => MemWR,
        WrSrc => WrSrc,
        RegSel  => RegSel,

        Rd => Rd,
        Rn => Rn,
        Rm => Rm,
        Imm => Imm,
        Offset => Offset
    );

    MUX_RD_RM : entity work.MUX21
    generic map (N => 4)
    port map
    (
        A   => Rd,
        B   => Rm,
        COM => RegSel,
        S   => Rb
    );

    PSR : entity work.PSR
    port map
    (
        CLK => CLK,
        RST => RST,
        WE => PSREn,
        DATAIN => PSRIN,
        DATAOUT => PSRDATA
    );

    PROCESSING_UNIT : entity work.PROCESSING_UNIT
    port map
    (
        CLK => CLK,
        RST => RST,
        RA => Rn,
        RW => Rd,
        RB => Rb,
        RegWR => RegWR,
        Imm => Imm,
        ALUSrc => ALUSrc,
        OP => ALUctr,
        WrSrc => WrSrc,
        MemWR => MemWR,
        N => PSRIN(0)
    );

end architecture;
