library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;


entity SIGNED_EXTENSION is
generic
(
    N : integer := 8
);
port
(
    E : in std_logic_vector(N - 1 downto 0);
    S : out std_logic_vector(31 downto 0)
);
end entity SIGNED_EXTENSION;


architecture ARCH of SIGNED_EXTENSION is
begin
    S <= std_logic_vector(resize(signed(E), S'length));
end architecture ARCH;
