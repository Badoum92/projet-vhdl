library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity REGISTER_BENCH is
port
(
    CLK : in std_logic;
    RST : in std_logic;
    W   : in std_logic_vector(31 downto 0); -- bus donnee ecriture
    RA  : in std_logic_vector(3 downto 0);  -- addresse A
    RB  : in std_logic_vector(3 downto 0);  -- addresse B
    RW  : in std_logic_vector(3 downto 0);  -- addresse ecriture
    WE  : in std_logic;                     -- write enable
    A   : out std_logic_vector(31 downto 0);
    B   : out std_logic_vector(31 downto 0)
);
end entity;

architecture ARCH of REGISTER_BENCH is
    type table is array(15 downto 0) of std_logic_vector(31 downto 0);

    function init_bench return table is
        variable result : table;
    begin
        for i in 14 downto 0 loop
            result(i) := (others=>'0');
        end loop;
        result(15):=X"00000030";
        return result;
    end;

    signal Bench: table := init_bench;
begin


process(CLK, RST, WE, RW, W)
begin
    if RST = '1' then
        Bench <= init_bench;
    elsif rising_edge(CLK) then
        if WE = '1' then
            Bench(to_integer(unsigned(RW))) <= W;
        end if;
    end if;
end process;

A <= Bench(to_integer(unsigned(RA)));
B <= Bench(to_integer(unsigned(RB)));


end architecture;
