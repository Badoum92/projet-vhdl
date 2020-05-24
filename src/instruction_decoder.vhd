library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;


entity INSTR_DECODER is
port
(
    CLK : in std_logic;
    RST : in std_logic := '0';

    PSR : in std_logic_vector(31 downto 0);
    Instruction : in std_logic_vector(31 downto 0);

    nPCsel  : out std_logic;
    RegWR  : out std_logic;
    ALUSrc : out std_logic; -- select between immediate or register B for ALU 2nd input
    ALUctr  : out std_logic_vector(1 downto 0);
    PSREn : out std_logic;
    MemWR  : out std_logic;
    WrSrc : out std_logic;  -- select between AluOut or DataOut for busW
    RegSel  : out std_logic;

    Rd : out std_logic_vector(3 downto 0); -- Destination register
    Rn : out std_logic_vector(3 downto 0); -- First register operand
    Rm : out std_logic_vector(3 downto 0); -- Second register operand
    Imm : out std_logic_vector(7 downto 0); -- Immediate operand
    Offset : out std_logic_vector(23 downto 0)
);
end entity;

architecture ARCH of INSTR_DECODER is
    type instr_type is (MOV, ADDi, ADDr, CMP, LDR, STR, BAL, BLT, BNE, STRGT, ADDGT);
    signal cur_instr : instr_type;
begin

    process(Instruction)
    begin
        -- data
        if Instruction(27 downto 26) = "00" then

            if Instruction(25 downto 21) = "10100" then
                cur_instr <= ADDi;
            elsif Instruction(25 downto 21) = "00100" then
                cur_instr <= ADDr;
            elsif Instruction(24 downto 21) = "1101" then
                cur_instr <= MOV;
            elsif Instruction(24 downto 21) = "1010" then
                cur_instr <= CMP;
            end if;

        -- memory
        elsif Instruction(27 downto 26) = "01" then

            if Instruction(20) = '1' then
                cur_instr <= LDR;
            elsif Instruction(20) = '0' then
                cur_instr <= STR;
            end if;

        -- branches
        elsif Instruction(27 downto 26) = "10" then

            if Instruction(31 downto 28) = "1110" then
                cur_instr <= BAL;
            elsif Instruction(31 downto 28) = "1011" then
                cur_instr <= BLT;
            end if;

        end if;

    end process;

    process(cur_instr, Instruction)
    begin
        Offset <= (others => '0');
        Rn <= (others => '0');
        Rd <= (others => '0');
        Rm <= (others => '0');
        Imm <= (others => '0');

        case cur_instr is
            when ADDi =>
                nPCsel <= '0';
                RegWR <= '1';
                ALUSrc <= '1';
                ALUctr <= "00";
                PSREn <= '1';
                MemWR <= '0';
                WrSrc <= '0';
                RegSel <= '0';

                Rn <= Instruction(19 downto 16);
                Rd <= Instruction(15 downto 12);
                Rm <= Instruction(3 downto 0);
                Imm <= Instruction(7 downto 0);

            when ADDr =>
                nPCsel <= '0';
                RegWR <= '1';
                ALUSrc <= '0';
                ALUctr <= "00";
                PSREn <= '1';
                MemWR <= '0';
                WrSrc <= '0';
                RegSel <= '0';

                Rn <= Instruction(19 downto 16);
                Rd <= Instruction(15 downto 12);
                Rm <= Instruction(3 downto 0);
                Imm <= Instruction(7 downto 0);

            when BAL =>
                nPCsel <= '1';
                RegWR <= '0';
                ALUSrc <= '0';
                ALUctr <= "00";
                PSREn <= '0';
                MemWR <= '0';
                WrSrc <= '0';
                RegSel <= '0';

                Offset <= Instruction(23 downto 0);

            when BLT =>
                if PSR(0) = '1' then
                    nPCsel <= '1';
                else
                    nPCsel <= '0';
                end if;

                RegWR <= '0';
                ALUSrc <= '0';
                ALUctr <= "00";
                PSREn <= '0';
                MemWR <= '0';
                WrSrc <= '0';
                RegSel <= '0';

                Offset <= Instruction(23 downto 0);

            when CMP =>
                nPCsel <= '0';
                RegWR <= '0';
                ALUSrc <= '1';
                ALUctr <= "10";
                PSREn <= '1';
                MemWR <= '0';
                WrSrc <= '0';
                RegSel <= '0';

                Rn <= Instruction(19 downto 16);
                Rd <= Instruction(15 downto 12);
                Rm <= Instruction(3 downto 0);
                Imm <= Instruction(7 downto 0);

            when LDR =>
                nPCsel <= '0';
                RegWR <= '1';
                ALUSrc <= '1';
                ALUctr <= "00";
                PSREn <= '0';
                MemWR <= '0';
                WrSrc <= '1';
                RegSel <= '1';

                Rn <= Instruction(19 downto 16);
                Rd <= Instruction(15 downto 12);
                Imm <= Instruction(7 downto 0);

            when MOV =>
                nPCsel <= '0';
                RegWR <= '1';
                ALUSrc <= '1';
                ALUctr <= "01";
                PSREn <= '0';
                MemWR <= '0';
                WrSrc <= '0';
                RegSel <= '0';

                Rn <= Instruction(19 downto 16);
                Rd <= Instruction(15 downto 12);
                Rm <= Instruction(3 downto 0);
                Imm <= Instruction(7 downto 0);

            when STR =>
                nPCsel <= '0';
                RegWR <= '0';
                ALUSrc <= '1';
                ALUctr <= "00";
                PSREn <= '0';
                MemWR <= '1';
                WrSrc <= '0';
                RegSel <= '1';

                Rn <= Instruction(19 downto 16);
                Rd <= Instruction(15 downto 12);
                Imm <= Instruction(7 downto 0);

            when BNE =>

            when STRGT =>

            when ADDGT =>
        end case;
    end process;

end architecture;
