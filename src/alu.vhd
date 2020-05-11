library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;
    use IEEE.std_logic_signed.all


entity ALU is
port
(
    OP : in std_logic_vector(1 downto 0);
    A  : in std_logic_vector(31 downto 0);
    B  : in std_logic_vector(31 downto 0);
    S  : out std_logic_vector(31 downto 0);
    N  : out std_logic
);
end entity ALU;


architecture ARCH of ALU is
begin
    process(OP, A, B)
    begin
        case OP is
            when "00" =>
                S <= A + B;
            when "01" =>
                S <= B
            when "10" =>
                S <= A - B;
            when "11" =>
                S <= A;
            when others =>
                null;
        end case;
        if S < 0 then
            N <= '1';
        else
            N <= '0';
        end if;
    end process;
end architecture ARCH;
