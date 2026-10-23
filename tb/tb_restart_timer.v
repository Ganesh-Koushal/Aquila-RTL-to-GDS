`timescale 1ns/1ps

module tb_restart_timer;

    // ------------------------------------------------------------
    // Testbench signals
    // ------------------------------------------------------------

    reg clk;
    reg reset;
    reg enable;

    wire done;

    // ------------------------------------------------------------
    // Device Under Test
    // ------------------------------------------------------------

    restart_timer #(
        .DELAY_CYCLES(5)
    ) dut (
        .clk    (clk),
        .reset  (reset),
        .enable (enable),
        .done   (done)
    );

    // ------------------------------------------------------------
    // Clock generation
    // 10 ns period = 100 MHz
    // ------------------------------------------------------------

    always #5 clk = ~clk;

    // ------------------------------------------------------------
    // Test sequence
    // ------------------------------------------------------------

    initial begin

        $dumpfile("tb_restart_timer.vcd");
        $dumpvars(0, tb_restart_timer);

        // Initial conditions
        clk    = 1'b0;
        reset  = 1'b1;
        enable = 1'b0;

        // --------------------------------------------------------
        // Reset
        // --------------------------------------------------------

        #20;

        reset = 1'b0;

        // --------------------------------------------------------
        // Test 1: Timer disabled
        // --------------------------------------------------------

        #20;

        if (done !== 1'b0)
            $display("ERROR: Restart timer completed while disabled");
        else
            $display("PASS: Restart timer disabled");

        // --------------------------------------------------------
        // Test 2: Enable restart timer
        // --------------------------------------------------------

        enable = 1'b1;

        #60;

        if (done !== 1'b1)
            $display("ERROR: Restart delay did not complete");
        else
            $display("PASS: Restart delay completed");

        // --------------------------------------------------------
        // Test 3: Disable timer
        // --------------------------------------------------------

        enable = 1'b0;

        #20;

        if (done !== 1'b0)
            $display("ERROR: Done did not clear after disabling timer");
        else
            $display("PASS: Done cleared after disabling timer");

        // --------------------------------------------------------
        // Test 4: Start timer again
        // --------------------------------------------------------

        enable = 1'b1;

        #60;

        if (done !== 1'b1)
            $display("ERROR: Second restart delay did not complete");
        else
            $display("PASS: Second restart delay completed");

        // --------------------------------------------------------
        // Finish
        // --------------------------------------------------------

        #20;

        $display("----------------------------------------");
        $display("RESTART TIMER TEST COMPLETE");
        $display("----------------------------------------");

        $finish;

    end

endmodule
