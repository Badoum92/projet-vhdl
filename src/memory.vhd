library IEEE;
    use IEEE.std_logic_1164.all;
    use IEEE.numeric_std.all;


entity MEMORY is
port
(
    CLK     : in std_logic;
    DATAIN  : in std_logic_vector(31 downto 1);
    ADDR    : in std_logic_vector(5 downto 0);
    WE      : in std_logic;
    DATAOUT : out std_logic_vector(31 downto 0)
);
end entity MEMORY;


architecture ARCH of MEMORY is
begin
end architecture ARCH;
