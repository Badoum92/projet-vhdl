library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;


entity MUX21 is
port
generic
(
    N : integer := 8
);
(
    A   : in std_logic_vector(N - 1 downto 0);
    B   : in std_logic_vector(N - 1 downto 0);
    COM : in std_logic;
    S   : out std_logic_vector(N - 1 downto 0);
);
end entity MUX21;


architecture ARCH of MUX21 is
begin
end architecture ARCH;
