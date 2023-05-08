library IEEE;
use IEEE.std_logic_1164.all;

entity mux_21 is
    generic (N: integer); -- N is the number of bits
    port(
        A, B: in std_logic_vector((N - 1) downto 0); -- Inputs
        COM: in std_logic; -- Control input
        S: out std_logic_vector((N - 1) downto 0) -- Output
    );
end entity;

architecture RTL of mux_21 is
begin
    process(COM, A, B) is
    begin
        if COM = '0' then
            S <= A;
        else
            S <= B;
        end if;
    end process;
end architecture;
