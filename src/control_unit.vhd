library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control_unit is
    port(
        CLK: in std_logic;
        Reset: in std_logic;
        instruction: in std_logic_vector(31 downto 0);
        N, Z, C, V: in std_logic;
        nPCSel: out std_logic;
        RegWr: out std_logic;
        ALUSrc: out std_logic;
        ALUCtr: out std_logic_vector(2 downto 0);
        MemWr: out std_logic;
        WrSrc: out std_logic;
        RegSel: out std_logic;
        RegAff: out std_logic
    );
end entity;

architecture RTL of control_unit is
    signal psr: std_logic_vector(31 downto 0);
    signal PSREn: std_logic;
begin
    instruction_decoder: entity work.instruction_decoder
        port map (
            instruction => instruction,
            psr => psr,
            nPCSel => nPCSel,
            RegWr => RegWr,
            ALUSrc => ALUSrc,
            ALUCtr => ALUCtr,
            PSREn => PSREn,
            MemWr => MemWr,
            WrSrc => WrSrc,
            RegSel => RegSel,
            RegAff => RegAff
        );

    state_register: entity work.state_register
        port map (
            CLK => CLK,
            RST => Reset,
            N => N,
            Z => Z,
            C => C,
            V => V,
            DataOut => psr,
            WE => PSREn
        );
end architecture;
