library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_level is
    port(
        CLK: in std_logic;
        KEY: in std_logic_vector(1 DOWNTO 0);
        SW: in std_logic_vector(9 DOWNTO 0);
        HEX0: out std_logic_vector(0 to 6);
        HEX1: out std_logic_vector(0 to 6);
        HEX2: out std_logic_vector(0 to 6);
        HEX3: out std_logic_vector(0 to 6)
    );
end entity;

architecture RTL of top_level is
    signal Aff: std_logic_vector(31 downto 0) := (others => '0');
    signal Reset, Pol: std_logic := '0';
    signal unities, tens, hundreds, thousands: std_logic_vector(3 downto 0) := (others => '0');
begin
    Reset <= not KEY(0);
    Pol <= SW(9);
    unities <= std_logic_vector(to_unsigned((to_integer(unsigned(Aff(15 downto 0)))) rem 10, 4));
    tens <= std_logic_vector(to_unsigned((to_integer(unsigned(Aff(15 downto 0))) / 10) rem 10, 4));
    hundreds <= std_logic_vector(to_unsigned((to_integer(unsigned(Aff(15 downto 0))) / 100) rem 10, 4));
    thousands <= std_logic_vector(to_unsigned((to_integer(unsigned(Aff(15 downto 0))) / 1000) rem 10, 4));

    cpu: entity work.cpu
        port map (
            CLK => CLK,
            Reset => Reset,
            Aff => Aff
        );

    digit_0: entity work.seven_seg_decoder
        port map (
            Data => unities,
            Pol => Pol,
            Segout => HEX0
        );

    digit_1: entity work.seven_seg_decoder
        port map (
            Data => tens,
            Pol => Pol,
            Segout => HEX1
        );

    digit_2: entity work.seven_seg_decoder
        port map (
            Data => hundreds,
            Pol => Pol,
            Segout => HEX2
        );

    digit_3: entity work.seven_seg_decoder
        port map (
            Data => thousands,
            Pol => Pol,
            Segout => HEX3
        );
end architecture;
