library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;


entity REGISTER_BENCH is
port
(
    CLK : in std_logic;
    RST : in std_logic;
    W   : in std_logic_vector(31 downto 1);
    RA  : in std_logic_vector(3 downto 0);
    RB  : in std_logic_vector(3 downto 0);
    RW  : in std_logic_vector(3 downto 0);
    WE  : in std_logic;
    A   : out std_logic_vector(31 downto 0);
    B   : out std_logic_vector(31 downto 0)
);
end entity REGISTER_BENCH;


architecture ARCH of REGISTER_BENCH is
begin
end architecture ARCH;
