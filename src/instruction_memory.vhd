library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity instruction_memory is
port
(
    PC: in std_logic_vector (31 downto 0);
    Instruction: out std_logic_vector (31 downto 0)
);
end entity;

architecture RTL of instruction_memory is
    type RAM64x32 is array (0 to 63) of std_logic_vector (31 downto 0);

function init_mem1 return RAM64x32 is
    variable result : RAM64x32;
begin
    for i in 63 downto 0 loop
        result (i):=(others=>'0');
    end loop;                -- PC          -- INSTRUCTION  -- COMMENTAIRE
    result (0):=x"E3A01020"; -- 0x0 _main   -- MOV R1,#0x20 -- R1 = 0x20
    result (1):=x"E3A02000"; -- 0x1         -- MOV R2,#0x00 -- R2 = 0
    result (2):=x"E6110000"; -- 0x2 _loop   -- LDR R0,0(R1) -- R0 = DATAMEM[R1]
    result (3):=x"E0822000"; -- 0x3         -- ADD R2,R2,R0 -- R2 = R2 + R0
    result (4):=x"E2811001"; -- 0x4         -- ADD R1,R1,#1 -- R1 = R1 + 1
    result (5):=x"E351002A"; -- 0x5         -- CMP R1,0x2A  -- (original faux? si R1 >= 0x2A) si R1 < 0x2A
    result (6):=x"BAFFFFFB"; -- 0x6         -- BLT loop     -- PC = PC + (-5) si N = 1
    result (7):=x"E6012000"; -- 0x7         -- STR R2,0(R1) -- DATAMEM[R1] = R2
    result (8):=x"EAFFFFF7"; -- 0x8         -- BAL main     -- PC = PC + (-7)
    return result;
end function;

function init_mem2 return RAM64x32 is
    variable result : RAM64x32;
begin
    for i in 63 downto 0 loop
        result (i):=(others=>'0');
    end loop;
    result (0):=x"E3A00020";  -- 0x0 main: MOV R0,#0x20    -- R0 = 0x20
    result (1):=x"E3A01001";  -- 0x1       MOV R1, #1      -- R1 = 1
    result (2):=x"E5903000";  -- 0x2 loop: LDR R3, [R0]    -- R3 = DATAMEM[R0]
    result (3):=x"E5904001";  -- 0x3       LDR R4, [R0,#1] -- R4 = DATAMEM[R0+1]
    result (4):=x"E5804000";  -- 0x4       STR R4, [R0]    -- DATAMEM[R0] = R4
    result (5):=x"E5803001";  -- 0x5       STR R3, [R0,#1] -- DATAMEM[R0+1] = R3
    result (6):=x"E2800001";  -- 0x6       ADD R0, R0, #1  -- R0 = R0 + 1
    result (7):=x"E2811001";  -- 0x7       ADD R1, R1, #1  -- R1 = R1 + 1
    result (8):=x"E351000A";  -- 0x8       CMP R1, #0xA    -- si R1 < 0xA
    result (9):=x"BAFFFFF8";  -- 0x9       BLT loop        -- PC = PC + (-8) si N = 1
    result (10):=x"EAFFFFFF"; -- 0xA wait: BAL wait        -- PC = PC + (-1)
    return result;
end function;

signal mem: RAM64x32 := init_mem2;

begin
    Instruction <= mem(to_integer (unsigned (PC)));
end architecture;
