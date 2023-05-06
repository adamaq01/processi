library vunit_lib;
context vunit_lib.vunit_context;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_2 is
    generic (runner_cfg: string);
end entity;

architecture tb of tb_2 is
    constant Period: time := 10 us;

    signal CLK: std_logic := '0';
    signal Reset: std_logic := '1';
    signal nPCsel: std_logic := '0';
    signal offset: std_logic_vector(23 downto 0) := (others => '0');
    signal instruction: std_logic_vector(31 downto 0);
    signal Done: boolean := false;
begin
    -- System Inputs
    CLK <= '0' when Done else not CLK after (Period / 2);
    Reset <= '1', '0' after Period;

    operation_unit: entity work.operation_unit
        port map (
            CLK => CLK,
            Reset => Reset,
            nPCsel => nPCsel,
            offset => offset,
            instruction => instruction
        );

    main: process
    begin
        test_runner_setup(runner, runner_cfg); -- Simulation starts here
        wait for Period; -- Wait for reset to finish
        check(Reset = '0', "Reset not finished");

        check_equal(to_hstring(instruction), "E3A01020", "Instruction not correct");

        -- Test 1
        nPCsel <= '0';
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_equal(to_hstring(instruction), "E3A02000", "Instruction not correct");

        -- Test 2
        nPCsel <= '1';
        offset <= std_logic_vector(to_unsigned(4, 24));
        wait until rising_edge(CLK);
        wait for 1 ns;
        check_equal(to_hstring(instruction), "BAFFFFFB", "Instruction not correct");

        Done <= true;
        test_runner_cleanup(runner); -- Simulation ends here
    end process;
end architecture;
