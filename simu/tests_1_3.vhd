library vunit_lib;
context vunit_lib.vunit_context;

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_1_3 is
    generic (runner_cfg: string);
end entity;

architecture tb of tb_1_3 is
    constant Period: time := 10 us;

    signal CLK: std_logic := '0';
    signal Reset: std_logic := '1';
    signal Ra, Rb, Rw: std_logic_vector(3 downto 0) := (others => '0');
    signal RegWr, WrEn: std_logic := '0';
    signal mux_0_com, mux_1_com: std_logic := '0';
    signal OP: std_logic_vector(2 downto 0) := (others => '0');
    signal busA, busB, busW, ALUout, mux_0_out, ExtOut, DataOut: std_logic_vector(31 downto 0) := (
        others => '0');
    signal Imm: std_logic_vector(7 downto 0) := (others => '0');
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
            W => busW,
            RA => Ra,
            RB => Rb,
            RW => Rw,
            WE => RegWr,
            A => busA,
            B => busB
        );

    alu: entity work.alu
        port map(
            OP => OP,
            A => busA,
            B => mux_0_out,
            S => ALUout,
            N => N,
            Z => Z,
            C => C,
            V => V
        );

    mux_0: entity work.mux_21
        generic map(
            N => 32
        )
        port map(
            A => busB,
            B => ExtOut,
            COM => mux_0_com,
            S => mux_0_out
        );

    mux_1: entity work.mux_21
        generic map(
            N => 32
        )
        port map(
            A => ALUout,
            B => DataOut,
            COM => mux_1_com,
            S => busW
        );

    sign_extender: entity work.sign_extender
        generic map(
            N => 8
        )
        port map(
            E => Imm,
            S => ExtOut
        );

    data_memory: entity work.data_memory
        port map(
            CLK => CLK,
            Reset => Reset,
            DataIn => busB,
            DataOut => DataOut,
            Addr => ALUout(5 downto 0),
            WrEn => WrEn
        );

    main: process
    begin
        test_runner_setup(runner, runner_cfg); -- Simulation starts here
        wait for Period; -- Wait for reset to finish
        check(Reset = '0', "Reset not finished");

        -- Test 1 - Add R(1) and R(15)
        report "Test 1 - Add R(1) and R(15)";
        RA <= "0001";
        RB <= "1111";

        wait for 1 ns;
        check_equal(to_hstring(busA), "00000000", "R(1) not equal to 0");
        check_equal(to_hstring(busB), "00000030", "R(15) not equal to 48");

        -- File Register
        RA <= "0001"; -- Select R(1) as A output
        RB <= "1111"; -- Select R(15) as B output

        -- First Multiplexer
        mux_0_com <= '0'; -- Select B as output

        -- ALU
        OP <= "000"; -- Add operation

        -- Check ALU output
        wait for 1 ns;
        check_equal(N, '0', "N not equal to 0");
        check_equal(Z, '0', "Z not equal to 0");
        check_equal(C, '0', "C not equal to 0");
        check_equal(V, '0', "V not equal to 0");

        -- Second Multiplexer
        mux_1_com <= '0'; -- Select ALU output as output
        wait for 1 ns;

        -- Check output
        wait until rising_edge(CLK);
        check_equal(to_hstring(busW), "00000030", "Output not equal to 48");


        -- Test 2 - Add R(1) and 69
        report "Test 2 - Add R(15) and 69";
        RA <= "1111";

        wait for 1 ns;
        check_equal(to_hstring(busA), "00000030", "R(15) not equal to 48");

        -- File Register
        RA <= "1111"; -- Select R(15) as A output

        -- Immediate Value
        Imm <= x"45"; -- 69

        -- First Multiplexer
        mux_0_com <= '1'; -- Select Imm as output

        -- ALU
        OP <= "000"; -- Add operation

        -- Check ALU output
        wait for 1 ns;
        check_equal(N, '0', "N not equal to 0");
        check_equal(Z, '0', "Z not equal to 0");
        check_equal(C, '0', "C not equal to 0");
        check_equal(V, '0', "V not equal to 0");

        -- Second Multiplexer
        mux_1_com <= '0'; -- Select ALU output as output
        wait for 1 ns;

        -- Check output
        wait until rising_edge(CLK);
        check_equal(to_hstring(busW), "00000075", "Output not equal to 117");


        -- Test 3 - Subtract R(4) and R(15)
        report "Test 3 - Subtract R(4) and R(15)";
        RA <= "0100";
        RB <= "1111";

        wait for 1 ns;
        check_equal(to_hstring(busA), "00000000", "R(4) not equal to 0");
        check_equal(to_hstring(busB), "00000030", "R(15) not equal to 48");

        -- File Register
        RA <= "0100"; -- Select R(4) as A output
        RB <= "1111"; -- Select R(15) as B output

        -- First Multiplexer
        mux_0_com <= '0'; -- Select B as output

        -- ALU
        OP <= "010"; -- Subtract operation

        -- Check ALU output
        wait for 1 ns;
        check_equal(N, '1', "N not equal to 1");
        check_equal(Z, '0', "Z not equal to 0");
        check_equal(C, '1', "C not equal to 1");
        check_equal(V, '0', "V not equal to 0");

        -- Second Multiplexer
        mux_1_com <= '0'; -- Select ALU output as output
        wait for 1 ns;

        -- Check output
        wait until rising_edge(CLK);
        check_equal(to_hstring(busW), "FFFFFFD0", "Output not equal to 4294967248");


        -- Test 4 - Subtract R(15) and 17
        report "Test 4 - Subtract R(15) and 17";
        RA <= "1111";

        wait for 1 ns;
        check_equal(to_hstring(busA), "00000030", "R(15) not equal to 48");

        -- File Register
        RA <= "1111"; -- Select R(15) as A output

        -- Immediate Value
        Imm <= x"11"; -- 17

        -- First Multiplexer
        mux_0_com <= '1'; -- Select Imm as output

        -- ALU
        OP <= "010"; -- Subtract operation

        -- Check ALU output
        wait for 1 ns;
        check_equal(N, '0', "N not equal to 0");
        check_equal(Z, '0', "Z not equal to 0");
        check_equal(C, '0', "C not equal to 0");
        check_equal(V, '0', "V not equal to 0");

        -- Second Multiplexer
        mux_1_com <= '0'; -- Select ALU output as output
        wait for 1 ns;

        -- Check output
        wait until rising_edge(CLK);
        check_equal(to_hstring(busW), "0000001F", "Output not equal to 31");


        -- Test 5 - Copy R(15) into R(12)
        report "Test 5 - Copy R(15) into R(12)";
        RA <= "1111";

        wait for 1 ns;
        check_equal(to_hstring(busA), "00000030", "R(15) not equal to 48");

        -- File Register
        RA <= "1111"; -- Select R(15) as A output
        RW <= "1100"; -- Write to R(12)

        -- ALU
        OP <= "011"; -- Out A operation

        -- Check ALU output
        wait for 1 ns;
        check_equal(N, '0', "N not equal to 0");
        check_equal(Z, '0', "Z not equal to 0");
        check_equal(C, '0', "C not equal to 0");
        check_equal(V, '0', "V not equal to 0");

        -- Second Multiplexer
        mux_1_com <= '0'; -- Select ALU output as output
        RegWr <= '1'; -- Enable write
        wait until rising_edge(CLK);
        RegWr <= '0'; -- Disable write

        -- Check output
        RA <= "1100"; -- Select R(15) as A output
        wait for 1 ns;
        check_equal(to_hstring(busA), "00000030", "Output not equal to 48");


        -- Test 6 - Copy R(15) to M(42)
        report "Test 6 - Copy R(15) to M(42)";
        RA <= "1111";

        wait for 1 ns;
        check_equal(to_hstring(busA), "00000030", "R(15) not equal to 48");

        -- File Register
        RB <= "1111"; -- Select R(15) as B output

        -- First Multiplexer
        mux_0_com <= '1'; -- Select Imm as output

        -- Immediate Value
        Imm <= x"2A"; -- 42

        -- ALU
        OP <= "001"; -- Out B operation

        -- Data Memory
        WrEn <= '1'; -- Enable write
        wait until rising_edge(CLK);
        wait for 1 ns;
        WrEn <= '0'; -- Disable write

        -- Check output
        check_equal(to_hstring(DataOut), "00000030", "M(42) not equal to 48");


        -- Test 7 - Read M(42) to R(9)
        report "Test 7 - Read M(42) to R(9)";
        RA <= "1001";

        wait for 1 ns;
        check_equal(to_hstring(busA), "00000000", "R(9) not equal to 0");

        -- File Register
        RW <= "1001"; -- Select R(9) as Write destination

        -- First Multiplexer
        mux_0_com <= '1'; -- Select Imm as output

        -- Immediate Value
        Imm <= x"2A"; -- 42

        -- ALU
        OP <= "001"; -- Out B operation

        -- Second Multiplexer
        mux_1_com <= '1'; -- Select DataOut as output

        -- File Register
        RegWr <= '1'; -- Enable write
        wait until rising_edge(CLK);
        wait for 1 ns;
        RegWr <= '0'; -- Disable write

        -- Check output
        RA <= "1001"; -- Select R(9) as A output
        wait for 1 ns;
        check_equal(to_hstring(busA), "00000030", "R(9) not equal to 48");

        Done <= true;
        test_runner_cleanup(runner); -- Simulation ends here
    end process;
end architecture;
