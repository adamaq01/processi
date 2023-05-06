library vunit_lib;
context vunit_lib.vunit_context;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_1_1 is
    generic (runner_cfg: string);
end entity;

architecture tb of tb_1_1 is
    constant Period: time := 10 us;

    signal CLK: std_logic := '0';
    signal Reset: std_logic := '1';
    signal RA, RB, RW: std_logic_vector(3 downto 0) := (others => '0');
    signal WE: std_logic := '0';
    signal OP: std_logic_vector(2 downto 0) := (others => '0');
    signal A, B, S: std_logic_vector(31 downto 0) := (others => '0');
    signal N, Z, C, V: std_logic := '0';
    signal Done: boolean := false;
begin
    -- System Inputs
    CLK <= '0' when Done else not CLK after (Period / 2);
    Reset <= '1', '0' after Period;

    file_register: entity work.file_register
        port map(
            CLK => CLK,
            Reset => Reset,
            W => S,
            RA => RA,
            RB => RB,
            RW => RW,
            WE => WE,
            A => A,
            B => B
        );

    alu: entity work.alu
        port map(
            OP => OP,
            A => A,
            B => B,
            S => S,
            N => N,
            Z => Z,
            C => C,
            V => V
        );

    main: process
    begin
        test_runner_setup(runner, runner_cfg); -- Simulation starts here
        wait for Period; -- Wait for reset to finish
        check(Reset = '0', "Reset not finished");

        -- Test 1 - R(1) = R(15)
        report "Test 1 - R(1) = R(15)";
        RA <= "0001";
        RB <= "1111";

        wait for 1 ns;
        check_equal(to_hstring(A), "00000000", "R(1) not equal to 0");
        check_equal(to_hstring(B), "00000030", "R(15) not equal to 48");

        RA <= "0001"; -- Select R(1) as A output
        RB <= "1111"; -- Select R(15) as B output
        RW <= "0001"; -- Write to R(1)
        WE <= '1'; -- Enable write
        OP <= "001"; -- Select B as ALU output
        wait until rising_edge(CLK); -- Wait for File Register to write
        WE <= '0'; -- Disable write

        wait for 1 ns;
        check_equal(to_hstring(A), "00000030", "R(1) not equal to 48");


        -- Test 2 - R(1) = R(1) + R(15)
        report "Test 2 - R(1) = R(1) + R(15)";
        RA <= std_logic_vector(to_unsigned(1, 4));
        RB <= std_logic_vector(to_unsigned(15, 4));

        wait for 1 ns;
        check_equal(to_hstring(A), "00000030", "R(1) not equal to 48");
        check_equal(to_hstring(B), "00000030", "R(15) not equal to 48");

        RA <= "0001"; -- Select R(1) as A output
        RB <= "1111"; -- Select R(15) as B output
        RW <= "0001"; -- Write to R(1)
        OP <= "000"; -- Add A and B into ALU output

        wait for 1 ns;
        check_equal(N, '0', "N not equal to 0");
        check_equal(Z, '0', "Z not equal to 0");
        check_equal(C, '0', "C not equal to 0");
        check_equal(V, '0', "V not equal to 0");

        WE <= '1'; -- Enable write
        wait until rising_edge(CLK); -- Wait for File Register to write
        WE <= '0'; -- Disable write
        wait for 1 ns;
        check_equal(to_hstring(A), "00000060", "R(1) not equal to 96");


        -- Test 3 - R(2) = R(1) + R(15)
        report "Test 3 - R(2) = R(1) + R(15)";
        RA <= std_logic_vector(to_unsigned(1, 4));
        RB <= std_logic_vector(to_unsigned(15, 4));

        wait for 1 ns;
        check_equal(to_hstring(A), "00000060", "R(1) not equal to 96");
        check_equal(to_hstring(B), "00000030", "R(15) not equal to 48");

        RA <= "0001"; -- Select R(1) as A output
        RB <= "1111"; -- Select R(15) as B output
        RW <= "0010"; -- Write to R(2)
        OP <= "000"; -- Add A and B into ALU output

        wait for 1 ns;
        check_equal(N, '0', "N not equal to 0");
        check_equal(Z, '0', "Z not equal to 0");
        check_equal(C, '0', "C not equal to 0");
        check_equal(V, '0', "V not equal to 0");

        WE <= '1'; -- Enable write
        wait until rising_edge(CLK); -- Wait for File Register to write
        WE <= '0'; -- Disable write
        RA <= "0010"; -- Select R(2) as A output
        wait for 1 ns;
        check_equal(to_hstring(A), to_hstring(to_unsigned(144, 32)), "R(2) not equal to 144");


        -- Test 4 - R(3) = R(1) - R(15)
        report "Test 4 - R(3) = R(1) - R(15)";
        RA <= std_logic_vector(to_unsigned(1, 4));
        RB <= std_logic_vector(to_unsigned(15, 4));

        wait for 1 ns;
        check_equal(to_hstring(A), "00000060", "R(1) not equal to 96");
        check_equal(to_hstring(B), "00000030", "R(15) not equal to 48");

        RA <= "0001"; -- Select R(1) as A output
        RB <= "1111"; -- Select R(15) as B output
        RW <= "0011"; -- Write to R(3)
        OP <= "010"; -- Substract A and B into ALU output

        wait for 1 ns;
        check_equal(N, '0', "N not equal to 0");
        check_equal(Z, '0', "Z not equal to 0");
        check_equal(C, '0', "C not equal to 0");
        check_equal(V, '0', "V not equal to 0");

        WE <= '1'; -- Enable write
        wait until rising_edge(CLK); -- Wait for File Register to write
        WE <= '0'; -- Disable write
        RA <= "0011"; -- Select R(3) as A output
        wait for 1 ns;
        check_equal(to_hstring(A), "00000030", "R(3) not equal to 48");


        -- Test 5 - R(5) = R(7) - R(15)
        report "Test 5 - R(5) = R(7) - R(15)";
        RA <= std_logic_vector(to_unsigned(7, 4));
        RB <= std_logic_vector(to_unsigned(15, 4));

        wait for 1 ns;
        check_equal(to_hstring(A), "00000000", "R(7) not equal to 0");
        check_equal(to_hstring(B), "00000030", "R(15) not equal to 48");

        RA <= "0111"; -- Select R(7) as A output
        RB <= "1111"; -- Select R(15) as B output
        RW <= "0101"; -- Write to R(5)
        OP <= "010"; -- Substract A and B into ALU output

        wait for 1 ns;
        check_equal(N, '1', "N not equal to 1");
        check_equal(Z, '0', "Z not equal to 0");
        check_equal(C, '1', "C not equal to 1");
        check_equal(V, '0', "V not equal to 0");

        WE <= '1'; -- Enable write
        wait until rising_edge(CLK); -- Wait for File Register to write
        WE <= '0'; -- Disable write
        RA <= "0101"; -- Select R(5) as A output
        wait for 1 ns;
        check_equal(to_hstring(A), "FFFFFFD0", "R(5) not equal to 4294967248");

        Done <= true;
        test_runner_cleanup(runner); -- Simulation ends here
    end process;
end architecture;
