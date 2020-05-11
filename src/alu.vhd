library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;


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
end architecture ARCH;
