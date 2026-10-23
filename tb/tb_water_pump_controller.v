`timescale 1ns/1ps

module tb_water_pump_controller;

    // ------------------------------------------------------------
    // Testbench signals
    // ------------------------------------------------------------

    reg clk;
    reg reset;

    reg level_low;
    reg level_full;
    reg flow_ok;
    reg power_ok;
    reg emergency;

    wire pump_on;
    wire alarm;
    wire fault;

    // ------------------------------------------------------------
    // Device Under Test
    // ------------------------------------------------------------

    water_pump_controller #(
        .FLOW_TIMEOUT_CYCLES(5),
        .RESTART_DELAY_CYCLES(5)
    ) dut (
        .clk        (clk),
        .reset      (reset),
        .level_low  (level_low),
        .level_full (level_full),
        .flow_ok    (flow_ok),
        .power_ok   (power_ok),
        .emergency  (emergency),
        .pump_on    (pump_on),
        .alarm      (alarm),
        .fault      (fault)
    );

    // ------------------------------------------------------------
    // 100 MHz simulation clock
    // 10 ns period
    // ------------------------------------------------------------

    always #5 clk = ~clk;

    // ------------------------------------------------------------
    // Test sequence
    // ------------------------------------------------------------

    initial begin

        $dumpfile("tb_water_pump_controller.vcd");
        $dumpvars(0, tb_water_pump_controller);

        // --------------------------------------------------------
        // Initial conditions
        // --------------------------------------------------------

        clk        = 1'b0;
        reset      = 1'b1;

        level_low  = 1'b0;
        level_full = 1'b0;
        flow_ok    = 1'b0;
        power_ok   = 1'b1;
        emergency  = 1'b0;

        #20;

        reset = 1'b0;

        // --------------------------------------------------------
        // TEST 1: Normal pump startup
        // Low tank -> pump should turn ON
        // --------------------------------------------------------

        level_low = 1'b1;

        @(posedge clk);
        #1;

        if (pump_on !== 1'b1)
            $display("ERROR: Pump did not start for low tank");
        else
            $display("PASS: Low tank -> Pump ON");

        // --------------------------------------------------------
        // TEST 2: Flow detected
        // Pump should continue running
        // --------------------------------------------------------

        flow_ok = 1'b1;

        @(posedge clk);
        #1;

        if (pump_on !== 1'b1)
            $display("ERROR: Pump stopped despite valid flow");
        else
            $display("PASS: Flow detected -> Pump continues");

        // --------------------------------------------------------
        // TEST 3: Full tank
        // Pump should stop
        // --------------------------------------------------------

        level_full = 1'b1;

        @(posedge clk);
        #1;

        if (pump_on !== 1'b0)
            $display("ERROR: Pump did not stop at full tank");
        else
            $display("PASS: Full tank -> Pump OFF");

        // Clear conditions
        level_low  = 1'b0;
        level_full = 1'b0;
        flow_ok    = 1'b0;

        // --------------------------------------------------------
        // TEST 4: No-flow protection
        // --------------------------------------------------------

        level_low = 1'b1;

        @(posedge clk);
        #1;

        if (pump_on !== 1'b1)
            $display("ERROR: Pump did not start second time");
        else
            $display("PASS: Second startup -> Pump ON");

        // Wait long enough for the real flow timer
        repeat (6) @(posedge clk);

        #1;

        if ((pump_on !== 1'b0) ||
            (alarm !== 1'b1) ||
            (fault !== 1'b1))
            $display("ERROR: No-flow protection failed");
        else
            $display("PASS: No flow -> Pump OFF + Alarm + Fault");

        // --------------------------------------------------------
        // TEST 5: Fault latch
        // --------------------------------------------------------

        level_low = 1'b0;

        repeat (2) @(posedge clk);

        if ((pump_on !== 1'b0) ||
            (alarm !== 1'b1) ||
            (fault !== 1'b1))
            $display("ERROR: Fault did not remain latched");
        else
            $display("PASS: Fault remains latched");

        // --------------------------------------------------------
        // TEST 6: Reset clears fault
        // --------------------------------------------------------

        reset = 1'b1;

        #10;

        reset = 1'b0;

        #1;

        if ((pump_on !== 1'b0) ||
            (alarm !== 1'b0) ||
            (fault !== 1'b0))
            $display("ERROR: Reset did not clear fault");
        else
            $display("PASS: Reset clears fault");

        // --------------------------------------------------------
        // TEST 7: Power failure while pump is running
        // --------------------------------------------------------

        level_low = 1'b1;
        flow_ok   = 1'b1;

        @(posedge clk);
        #1;

        if (pump_on !== 1'b1)
            $display("ERROR: Pump did not restart");
        else
            $display("PASS: Pump restarted");

        power_ok = 1'b0;

        @(posedge clk);
        #1;

        if (pump_on !== 1'b0)
            $display("ERROR: Pump remained ON during power failure");
        else
            $display("PASS: Power failure -> Pump OFF");

        // --------------------------------------------------------
        // TEST 8: Power recovery + restart delay
        // --------------------------------------------------------

        power_ok = 1'b1;

        @(posedge clk);
        #1;

        // Pump must NOT immediately restart
        if (pump_on !== 1'b0)
            $display("ERROR: Pump restarted immediately after power recovery");
        else
            $display("PASS: Power recovery -> Restart delay active");

        // Wait for restart timer
        repeat (6) @(posedge clk);

        #1;

        if (pump_on !== 1'b1)
            $display("ERROR: Pump did not restart after delay");
        else
            $display("PASS: Restart delay complete -> Pump ON");

        // --------------------------------------------------------
        // TEST 9: Emergency shutdown
        // --------------------------------------------------------

        emergency = 1'b1;

        @(posedge clk);
        #1;

        if ((pump_on !== 1'b0) ||
            (alarm !== 1'b1) ||
            (fault !== 1'b1))
            $display("ERROR: Emergency shutdown failed");
        else
            $display("PASS: Emergency -> Pump OFF + Alarm + Fault");

        // --------------------------------------------------------
        // Finish
        // --------------------------------------------------------

        #20;

        $display("========================================");
        $display("TOP-LEVEL CONTROLLER TEST COMPLETE");
        $display("========================================");

        $finish;

    end

endmodule
