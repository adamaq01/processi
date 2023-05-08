library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity state_register is
    port(
        CLK: in std_logic; -- Clock
        RST: in std_logic; -- Async Reset
        N, Z, C, V: in std_logic; -- Flags
        DataOut: out std_logic_vector(31 downto 0);
        WE: in std_logic -- Write Enable
    );
end entity;

architecture RTL of state_register is
begin
    registre: entity work.register32 port map(
        CLK => CLK,
        RST => RST,
        DataIn => (N & Z & C & V & X"0000000"),
        DataOut => DataOut,
        WE => WE
    );
end architecture;
