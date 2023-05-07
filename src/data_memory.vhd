library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity data_memory is
    port(
        CLK: in std_logic; -- Clock
        Reset: in std_logic; -- Async Reset
        DataIn: in std_logic_vector(31 downto 0); -- Data In
        DataOut: out std_logic_vector(31 downto 0); -- Data Out
        Addr: in std_logic_vector(5 downto 0); -- Address
        WrEn: in std_logic -- Write Enable
    );
end entity;

architecture RTL of data_memory is
    type table is array(63 downto 0) of std_logic_vector(31 downto 0);
    signal Banc: table;
begin
    process(CLK, Reset)
    begin
        if Reset = '1' then
            for i in 63 downto 0 loop
                Banc(i) <= (others => '0');
            end loop;
        elsif rising_edge(CLK) then
            if WrEn = '1' then
                Banc(to_integer(unsigned(Addr))) <= DataIn;
            end if;
        end if;
    end process;

    DataOut <= Banc(to_integer(unsigned(Addr)));
end architecture;
