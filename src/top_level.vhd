library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level is
    port(
        CLK: in std_logic;
        Reset: in std_logic;
    );
end cpu;

architecture RTL of top_level is
    signal Aff: std_logic_vector(31 downto 0)
begin
    cpu: entity work.cpu
        port map (
            CLK => CLK,
            Reset => Reset,
            Aff => Aff
        );
    
end architecture;
