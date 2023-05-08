library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity instruction_decoder is
    port(
        instruction: in std_logic_vector(31 downto 0);
        psr: in std_logic_vector(31 downto 0);
        nPCSel: out std_logic;
        RegWr: out std_logic;
        ALUSrc: out std_logic;
        ALUCtr: out std_logic_vector(2 downto 0);
        PSREn: out std_logic;
        MemWr: out std_logic;
        WrSrc: out std_logic;
        RegSel: out std_logic;
        RegAff: out std_logic
    );
end entity;

architecture RTL of instruction_decoder is
    type enum_instruction is (MOV, ADDi, ADDr, CMP, LDR, STR, BAL, BLT);
    signal instr_courante: enum_instruction;
begin
    process(instruction) is
    begin
        if instruction(27 downto 26) = "00" then -- Instructions de traitement
            case instruction(24 downto 21) is
                when "1101" => instr_courante <= MOV;
                when "0100" =>
                    if instruction(25) = '0' then -- # literal/register (1 literal, 0 register)
                        instr_courante <= ADDr;
                    else
                        instr_courante <= ADDi;
                    end if;
                when "1010" => instr_courante <= CMP;
                when others =>
                    report "Unknown instruction";
            end case;
        elsif instruction(27 downto 26) = "01" then -- Instructions de transfert
            if instruction(20) = '0' then -- L load/store (1 load, 0 store)
                instr_courante <= STR;
            else
                instr_courante <= LDR;
            end if;
        elsif instruction(27 downto 25) = "101" then -- Instructions de branchement
            if instruction(31 downto 28) = "1110" then -- BAL
                instr_courante <= BAL;
            elsif instruction(31 downto 28) = "1011" then -- BLT
                instr_courante <= BLT;
            end if;
        else -- Unknown instruction
            report "Unknown instruction";
        end if;
    end process;

    process(instruction, instr_courante) is
    begin
        case instr_courante is
            when MOV =>
                nPCSel <= '0';
                RegWr <= '1';
                ALUSrc <= '1';
                ALUCtr <= "001";
                PSREn <= '0';
                MemWr <= '0';
                WrSrc <= '0';
                RegAff <= '0';
            when ADDi =>
                nPCSel <= '0';
                RegWr <= '1';
                ALUSrc <= '1';
                ALUCtr <= "000";
                PSREn <= '1';
                MemWr <= '0';
                WrSrc <= '0';
                RegAff <= '0';
            when ADDr =>
                nPCSel <= '0';
                RegWr <= '1';
                ALUSrc <= '0';
                ALUCtr <= "000";
                PSREn <= '1';
                MemWr <= '0';
                WrSrc <= '0';
                RegSel <= '0';
                RegAff <= '0';
            when CMP =>
                nPCSel <= '0';
                RegWr <= '0';
                ALUSrc <= '1';
                ALUCtr <= "010";
                PSREn <= '1';
                MemWr <= '0';
                RegAff <= '0';
            when LDR =>
                nPCSel <= '0';
                RegWr <= '1';
                ALUSrc <= '1';
                ALUCtr <= "000";
                PSREn <= '0';
                MemWr <= '0';
                WrSrc <= '1';
                RegAff <= '0';
            when STR =>
                nPCSel <= '0';
                RegWr <= '0';
                ALUSrc <= '1';
                ALUCtr <= "000";
                PSREn <= '0';
                MemWr <= '1';
                RegSel <= '1';
                RegAff <= '1';
            when BAL =>
                nPCSel <= '1';
                RegWr <= '0';
                MemWr <= '0';
                RegAff <= '0';
            when BLT =>
                nPCSel <= psr(31);
                RegWr <= '0';
                MemWr <= '0';
                RegAff <= '0';
        end case;
    end process;
end architecture;
