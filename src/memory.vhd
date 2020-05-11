library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity MEMORY is
port
(
    CLK     : in std_logic;
    DATAIN  : in std_logic_vector(31 downto 0);
    ADDR    : in std_logic_vector(5 downto 0);
    WE      : in std_logic;
    DATAOUT : out std_logic_vector(31 downto 0)
);
end entity;

architecture ARCH of MEMORY is
    type table is array(63 downto 0) of std_logic_vector(31 downto 0);
    signal cells : table := (others => (others => '0'));
begin    

process(CLK, WE, DATAIN, ADDR)
begin
    if rising_edge(CLK) then
        if WE = '1' then
            cells(to_integer(unsigned(ADDR))) <= DATAIN;
        end if;
    end if;
end process;

DATAOUT <= cells(to_integer(unsigned(ADDR)));
end architecture;