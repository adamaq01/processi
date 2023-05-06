library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity sign_extender is
    generic (N: integer); -- N is the number of bits
    port(
        E: in std_logic_vector((N - 1) downto 0); -- Input
        S: out std_logic_vector(31 downto 0) -- Output
    );
end entity;

architecture RTL of sign_extender is
begin
    S <= std_logic_vector(resize(signed(E), S'length));
end architecture;
