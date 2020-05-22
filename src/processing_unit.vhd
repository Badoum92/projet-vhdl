library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity PROCESSING_UNIT is
port
(
    CLK : in std_logic;
    RST : in std_logic := '0';
    -- registers bench
    RA  : in std_logic_vector(3 downto 0);
    RB  : in std_logic_vector(3 downto 0);
    RW  : in std_logic_vector(3 downto 0);
    RegWR  : in std_logic;
    Imm : in std_logic_vector(7 downto 0);
    ALUSrc : in std_logic; -- select between immediate or register B for ALU 2nd input
    OP  : in std_logic_vector(1 downto 0);
    WrSrc : in std_logic;  -- select between AluOut or DataOut for busW
    MemWR  : in std_logic;
    N : out std_logic
);
end entity;

architecture ARCH of PROCESSING_UNIT is
    signal W   : std_logic_vector(31 downto 0);
    signal A   : std_logic_vector(31 downto 0);
    signal B   : std_logic_vector(31 downto 0);
    signal ImmExtented : std_logic_vector(31 downto 0);
    signal AluInB : std_logic_vector(31 downto 0);
    signal AluOut : std_logic_vector(31 downto 0);
    signal DataOut : std_logic_vector(31 downto 0);
begin


    REGISTER_BENCH : entity work.REGISTER_BENCH
    port map
    (
        CLK => CLK,
        RST => RST,
        W => W,
        RA => RA,
        RB => RB,
        RW => RW,
        WE => RegWR,
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
        COM => ALUSrc,
        S => AluInB
    );

    ALU : entity work.ALU
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
        WE => MemWR,
        DATAOUT => DataOut
    );


    REG_W_MUX : entity work.MUX21
    generic map (N => 32)
    port map
    (
        A => AluOut,
        B => DataOut,
        COM => WrSrc,
        S => W
    );

end architecture;
