library vunit_lib;
context vunit_lib.vunit_context;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_5 is
    generic (runner_cfg: string);
end entity;

architecture tb of tb_5 is
    constant Period: time := 10 us;

    signal CLK: std_logic := '0';
    signal Reset: std_logic := '1';
    signal Pol: std_logic := '1';
    signal KEY: std_logic_vector(1 downto 0) := "00";
    signal SW: std_logic_vector(9 downto 0) := "0000000000";
    signal HEX0: std_logic_vector(6 downto 0);
    signal HEX1: std_logic_vector(6 downto 0);
    signal HEX2: std_logic_vector(6 downto 0);
    signal HEX3: std_logic_vector(6 downto 0);
    signal Done: boolean := false;
begin
    -- System Inputs
    CLK <= '0' when Done else not CLK after (Period / 2);
    Reset <= '1', '0' after Period;
    KEY <= (not Reset) & (not Reset);
    SW <= Pol & "000000000";

    top_level: entity work.top_level
        port map (
            CLK => CLK,
            KEY => KEY,
            SW => SW,
            HEX0 => HEX0,
            HEX1 => HEX1,
            HEX2 => HEX2,
            HEX3 => HEX3
        );

    main: process
    begin
        test_runner_setup(runner, runner_cfg); -- Simulation starts here
        wait for Period; -- Wait for reset to finish
        check(Reset = '0', "Reset not finished");

        check_equal(to_string(HEX0), "1111110", "HEX0 not correct");
        check_equal(to_string(HEX1), "1111110", "HEX1 not correct");
        check_equal(to_string(HEX2), "1111110", "HEX2 not correct");
        check_equal(to_string(HEX3), "1111110", "HEX3 not correct");

        -- Test 1
        for i in 0 to 53 loop
            wait until rising_edge(CLK);
            wait for 1 ns;
        end loop;
        check_equal(to_string(HEX0), "1110000", "HEX0 not correct");
        check_equal(to_string(HEX1), "1111111", "HEX1 not correct");
        check_equal(to_string(HEX2), "1101101", "HEX2 not correct");
        check_equal(to_string(HEX3), "0110000", "HEX3 not correct");

        wait until falling_edge(CLK);

        Done <= true;
        test_runner_cleanup(runner); -- Simulation ends here
    end process;
end architecture;
