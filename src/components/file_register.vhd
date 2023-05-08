library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity file_register is
    port(
        CLK: in std_logic; -- Clock
        Reset: in std_logic; -- Async Reset
        W: in std_logic_vector(31 downto 0); -- Write Data
        RA: in std_logic_vector(3 downto 0); -- Output A register index
        RB: in std_logic_vector(3 downto 0); -- Output B register index
        RW: in std_logic_vector(3 downto 0); -- Input register index
        WE: in std_logic; -- Write Enable
        A: out std_logic_vector(31 downto 0); -- Output A register data
        B: out std_logic_vector(31 downto 0)    -- Output B register data
    );
end entity;

architecture RTL of file_register is
    type table is array(15 downto 0) of std_logic_vector(31 downto 0);
    signal Banc: table;

    function init_banc return table is
        variable result: table;
    begin
        for i in 14 downto 0 loop
            result(i) := (others => '0');
        end loop;
        result(15) := X"00000030";
        return result;
    end init_banc;
begin
    process(CLK, Reset)
    begin
        if Reset = '1' then
            Banc <= init_banc;
        elsif rising_edge(CLK) then
            if WE = '1' then
                Banc(to_integer(unsigned(RW))) <= W;
            end if;
        end if;
    end process;

    A <= Banc(to_integer(unsigned(RA)));
    B <= Banc(to_integer(unsigned(RB)));
end architecture;
