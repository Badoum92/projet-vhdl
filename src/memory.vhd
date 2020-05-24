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

    function init_mem1 return table is
        variable result : table;
    begin
        for i in 63 downto 0 loop
            result(i) := (others=>'0');
        end loop;
        result(32) := x"00000000";
        result(33) := x"00000001";
        result(34) := x"00000002";
        result(35) := x"00000003";
        result(36) := x"00000004";
        result(37) := x"00000005";
        result(38) := x"00000006";
        result(39) := x"00000007";
        result(40) := x"00000008";
        result(41) := x"00000009";
        return result;
    end function;

    signal cells : table := init_mem1;
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
