library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity seven_seg_decoder is
    port(
        Data: in std_logic_vector(3 downto 0);
        Pol: in std_logic;
        Segout: out std_logic_vector(1 to 7)
    );
end entity;

architecture RTL of seven_seg_decoder is
begin
    process(Data, Pol) is
    begin
        if Pol = '1' then
            case Data is
                when "0000" => Segout <= "1111110";
                when "0001" => Segout <= "0110000";
                when "0010" => Segout <= "1101101";
                when "0011" => Segout <= "1111001";
                when "0100" => Segout <= "0110011";
                when "0101" => Segout <= "1011011";
                when "0110" => Segout <= "1011111";
                when "0111" => Segout <= "1110000";
                when "1000" => Segout <= "1111111";
                when "1001" => Segout <= "1111011";
                when others => Segout <= "-------";
            end case;
        else
            case Data is
                when "0000" => Segout <= "0000001";
                when "0001" => Segout <= "1001111";
                when "0010" => Segout <= "0010010";
                when "0011" => Segout <= "0000110";
                when "0100" => Segout <= "1001100";
                when "0101" => Segout <= "0100100";
                when "0110" => Segout <= "0100000";
                when "0111" => Segout <= "0001111";
                when "1000" => Segout <= "0000000";
                when "1001" => Segout <= "0000100";
                when others => Segout <= "-------";
            end case;
        end if;
    end process;
end architecture;

