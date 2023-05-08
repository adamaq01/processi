library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity processing_unit is
    port(
        CLK: in std_logic;
        Reset: in std_logic;
        Rw, Ra, RmuxA, RmuxB: in std_logic_vector(3 downto 0);
        Imm: in std_logic_vector(7 downto 0);
        RegWr: in std_logic;
        RegSel: in std_logic;
        ALUSrc: in std_logic;
        MemWr: in std_logic;
        ALUCtr: in std_logic_vector(2 downto 0);
        WrEn: in std_logic;
        WrSrc: in std_logic;
        DataAff: out std_logic_vector(31 downto 0);
        N, Z, C, V: out std_logic
    );
end entity;

architecture RTL of processing_unit is
    signal Rb: std_logic_vector(3 downto 0);
    signal BusW, BusA, BusB, ExtOut, ALUInB, ALUOut, DataOut: std_logic_vector(31 downto 0);
begin
    mux_0: entity work.mux_21
        generic map(
            N => 4
        )
        port map(
            A => RmuxA,
            B => RmuxB,
            COM => RegSel,
            S => Rb
        );

    file_register: entity work.file_register
        port map(
            CLK => CLK,
            Reset => Reset,
            W => BusW,
            RA => Ra,
            RB => Rb,
            RW => Rw,
            WE => RegWr,
            A => BusA,
            B => BusB
        );

    sign_extender: entity work.sign_extender
        generic map(
            N => 8
        )
        port map(
            E => Imm,
            S => ExtOut
        );

    mux_1: entity work.mux_21
        generic map(
            N => 32
        )
        port map(
            A => BusB,
            B => ExtOut,
            COM => ALUSrc,
            S => ALUInB
        );

    alu: entity work.alu
        port map(
            OP => ALUCtr,
            A => BusA,
            B => ALUInB,
            S => ALUOut,
            N => N,
            Z => Z,
            C => C,
            V => V
        );

    data_memory: entity work.data_memory
        port map(
            CLK => CLK,
            Reset => Reset,
            DataIn => BusB,
            DataOut => DataOut,
            Addr => ALUout(5 downto 0),
            WrEn => MemWr
        );

    mux_2: entity work.mux_21
        generic map(
            N => 32
        )
        port map(
            A => ALUOut,
            B => DataOut,
            COM => WrSrc,
            S => BusW
        );

    DataAff <= BusB;
end architecture;
