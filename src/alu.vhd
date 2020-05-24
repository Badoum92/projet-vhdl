library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;


entity ALU is
port
(
    OP : in std_logic_vector(1 downto 0);
    A  : in std_logic_vector(31 downto 0);
    B  : in std_logic_vector(31 downto 0);
    S  : out std_logic_vector(31 downto 0);
    N  : out std_logic;
);
end entity ALU;

architecture ARCH of ALU is
begin
    process(OP, A, B)
        variable res : std_logic_vector(31 downto 0);
    begin
        case OP is
            when "00" =>
                res := A + B;
            when "01" =>
                res := B;
            when "10" =>
                res := A - B;
            when "11" =>
                res := A;
            when others =>
                null;
        end case;
        if res < 0 then
            N <= '1';
        else
            N <= '0';
        end if;
        S <= res;
    end process;
end architecture ARCH;
