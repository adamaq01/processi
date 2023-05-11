library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level is
    port(
        CLK: in std_logic;
        KEY: in std_logic_vector(1 DOWNTO 0);
        SW: in std_logic_vector(9 DOWNTO 0);
        HEX0: out std_logic_vector(6 downto 0);
        HEX1: out std_logic_vector(6 downto 0);
        HEX2: out std_logic_vector(6 downto 0);
        HEX3: out std_logic_vector(6 downto 0)
    );
end entity;

architecture RTL of top_level is
    signal Aff: std_logic_vector(31 downto 0);
    signal Reset, Pol: std_logic;
begin
    Reset <= not KEY(0);
    Pol <= SW(9);

    cpu: entity work.cpu
        port map (
            CLK => CLK,
            Reset => Reset,
            Aff => Aff
        );

    digit_0: entity work.seven_seg_decoder
        port map (
            Data => Aff(3 downto 0),
            Pol => Pol,
            Segout => HEX0
        );

    digit_1: entity work.seven_seg_decoder
        port map (
            Data => Aff(7 downto 4),
            Pol => Pol,
            Segout => HEX1
        );

    digit_2: entity work.seven_seg_decoder
        port map (
            Data => Aff(11 downto 8),
            Pol => Pol,
            Segout => HEX2
        );

    digit_3: entity work.seven_seg_decoder
        port map (
            Data => Aff(15 downto 12),
            Pol => Pol,
            Segout => HEX3
        );
end architecture;
