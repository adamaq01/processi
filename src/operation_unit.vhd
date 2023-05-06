library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity operation_unit is
    port(
        CLK: in std_logic;
        Reset: in std_logic;
        nPCsel: in std_logic;
        offset: in std_logic_vector(23 downto 0);
        instruction: out std_logic_vector(31 downto 0)
    );
end entity;

architecture RTL of operation_unit is
    signal PC: std_logic_vector(31 downto 0);
begin
    instruction_memory: entity work.instruction_memory
        port map(
            PC => PC,
            Instruction => instruction
        );

    process(CLK, Reset) is
    begin
        if Reset = '1' then
            PC <= (others => '0');
        elsif rising_edge(CLK) then
            if nPCsel = '1' then
                PC <= std_logic_vector(resize(signed(offset), PC'length) + signed(PC) + 1);
            else
                PC <= std_logic_vector(signed(PC) + 1);
            end if;
        end if;
    end process;
end architecture;
