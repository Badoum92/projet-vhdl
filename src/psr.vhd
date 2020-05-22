library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_signed.all;


entity PSR is
port
(
    CLK : in std_logic;
    RST : in std_logic;
    WE : in std_logic;
    DATAIN : in std_logic_vector(31 downto 0);
    DATAOUT : out std_logic_vector(31 downto 0)
);
end entity;

architecture ARCH of PSR is
    signal reg : std_logic_vector(31 downto 0) := (others => '0');
begin
    process(RST, CLK)
    begin
        if RST = '1' then
            reg <= (others => '0');
        elsif rising_edge(CLK) then
            if WE = '1' then
                reg <= DATAIN;
            end if;
        end if;
    end process;

    DATAOUT <= reg;

end architecture;
