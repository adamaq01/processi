library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
    port(
        OP: in std_logic_vector(2 downto 0); -- Operation
        A, B: in std_logic_vector(31 downto 0); -- Operands
        S: out std_logic_vector(31 downto 0); -- Result
        N, Z, C, V: out std_logic -- Flags
    );
end entity;

architecture RTL of alu is
    signal TS: std_logic_vector(32 downto 0);
begin
    process(OP, A, B, TS) is
    begin
        case OP is
            when "000" => TS <= std_logic_vector(unsigned('0' & A) + unsigned('0' & B));
            when "001" => TS <= '0' & B;
            when "010" => TS <= std_logic_vector(unsigned('0' & A) - unsigned('0' & B));
            when "011" => TS <= '0' & A;
            when "100" => TS <= ('0' & A) or ('0' & B);
            when "101" => TS <= ('0' & A) and ('0' & B);
            when "110" => TS <= ('0' & A) xor ('0' & B);
            when "111" => TS <= ('0' & not A);
            when others => TS <= (others => 'X');
        end case;

        S <= TS(31 downto 0);

        N <= TS(31);

        if TS(31 downto 0) = X"00000000" then
            Z <= '1';
        else
            Z <= '0';
        end if;

        C <= TS(32);

        if (OP = "000" and A(31) = B(31) and A(31) /= TS(31)) or
            (OP = "010" and A(31) /= B(31) and A(31) /= TS(31)) then
            V <= '1';
        else
            V <= '0';
        end if;
    end process;
end architecture;
