library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cpu is
    port(
        CLK: in std_logic;
        Reset: in std_logic;
        Aff: out std_logic_vector(31 downto 0)
    );
end cpu;

architecture RTL of cpu is
    signal instruction: std_logic_vector(31 downto 0);
    signal N, Z, C, V: std_logic;
    signal nPCSel: std_logic;
    signal RegWr: std_logic;
    signal ALUSrc: std_logic;
    signal ALUCtr: std_logic_vector(2 downto 0);
    signal MemWr: std_logic;
    signal WrSrc: std_logic;
    signal RegSel: std_logic;
    signal RegAff: std_logic;
    signal DataAff: std_logic_vector(31 downto 0);
begin
    control_unit: entity work.control_unit
        port map (
            CLK => CLK,
            Reset => Reset,
            instruction => instruction,
            N => N,
            Z => Z,
            C => C,
            V => V,
            nPCSel => nPCSel,
            RegWr => RegWr,
            ALUSrc => ALUSrc,
            ALUCtr => ALUCtr,
            MemWr => MemWr,
            WrSrc => WrSrc,
            RegSel => RegSel,
            RegAff => RegAff
        );

    operation_unit: entity work.operation_unit
        port map (
            CLK => CLK,
            Reset => Reset,
            nPCsel => nPCsel,
            offset => instruction(23 downto 0),
            instruction => instruction
        );

    processing_unit: entity work.processing_unit
        port map (
            CLK => CLK,
            Reset => Reset,
            Rw => instruction(15 downto 12), -- Rd
            Ra => instruction(19 downto 16), -- Rn
            RmuxA => instruction(3 downto 0), -- Rm
            RmuxB => instruction(15 downto 12), -- Rd
            Imm => instruction(7 downto 0), -- Imm
            RegWr => RegWr,
            RegSel => RegSel,
            ALUSrc => ALUSrc,
            MemWr => MemWr,
            ALUCtr => ALUCtr,
            WrSrc => WrSrc,
            DataAff => DataAff,
            N => N,
            Z => Z,
            C => C,
            V => V
        );

    registre_aff: entity work.register32
        port map (
            CLK => CLK,
            RST => Reset,
            DataIn => DataAff,
            DataOut => Aff,
            WE => RegAff
        );
end architecture;
