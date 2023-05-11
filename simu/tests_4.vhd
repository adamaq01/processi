library vunit_lib;
context vunit_lib.vunit_context;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_4 is
    generic (runner_cfg: string);
end entity;

architecture tb of tb_4 is
    constant Period: time := 10 us;

    signal CLK: std_logic := '0';
    signal Reset: std_logic := '1';
    signal Aff: std_logic_vector(31 downto 0);
    signal Done: boolean := false;
begin
    -- System Inputs
    CLK <= '0' when Done else not CLK after (Period / 2);
    Reset <= '1', '0' after Period;

    cpu: entity work.cpu
        port map (
            CLK => CLK,
            Reset => Reset,
            Aff => Aff
        );

    main: process
    begin
        test_runner_setup(runner, runner_cfg); -- Simulation starts here
        wait for Period; -- Wait for reset to finish
        check(Reset = '0', "Reset not finished");

        check_equal(to_hstring(Aff), "00000000", "Aff not correct");

        -- Test 1
        for i in 0 to 53 loop
            wait until rising_edge(CLK);
            wait for 1 ns;
        end loop;
        check_equal(to_hstring(Aff), "00000507", "Aff not correct");

        wait until falling_edge(CLK);

        Done <= true;
        test_runner_cleanup(runner); -- Simulation ends here
    end process;
end architecture;
