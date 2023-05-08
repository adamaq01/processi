library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity register32 is
    port(
        CLK: in std_logic; -- Clock
        RST: in std_logic; -- Async Reset
        DataIn: in std_logic_vector(31 downto 0);
        DataOut: out std_logic_vector(31 downto 0);
        WE: in std_logic -- Write Enable
    );
end entity;

architecture RTL of register32 is
    signal Registre: std_logic_vector(31 downto 0);
begin
    process(CLK, RST)
    begin
        if RST = '1' then
            Registre <= (others => '0');
        elsif rising_edge(CLK) then
            if WE = '1' then
                Registre <= DataIn;
            end if;
        end if;
    end process;

    DataOut <= Registre;
end architecture;
