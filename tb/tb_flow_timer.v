`timescale 1ns/1ps

module tb_flow_timer;

    // ------------------------------------------------------------
    // Testbench signals
    // ------------------------------------------------------------

    reg clk;
    reg reset;
    reg enable;
    reg flow_ok;

    wire timeout;

    // ------------------------------------------------------------
    // Device Under Test
    // ------------------------------------------------------------

    flow_timer #(
        .TIMEOUT_CYCLES(5)
    ) dut (
        .clk     (clk),
        .reset   (reset),
        .enable  (enable),
        .flow_ok  (flow_ok),
        .timeout (timeout)
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

        $dumpfile("tb_flow_timer.vcd");
        $dumpvars(0, tb_flow_timer);

        // Initial conditions
        clk     = 1'b0;
        reset   = 1'b1;
        enable  = 1'b0;
        flow_ok = 1'b0;

        // Hold reset
        #20;

        reset = 1'b0;

        // --------------------------------------------------------
        // Test 1: Timer disabled
        // --------------------------------------------------------

        #20;

        if (timeout !== 1'b0)
            $display("ERROR: Timeout asserted while timer disabled");
        else
            $display("PASS: Timer disabled");

        // --------------------------------------------------------
        // Test 2: Enable timer with no flow
        // --------------------------------------------------------

        enable = 1'b1;

        #60;

        if (timeout !== 1'b1)
            $display("ERROR: Timeout did not occur");
        else
            $display("PASS: Flow timeout detected");

        // --------------------------------------------------------
        // Test 3: Flow appears
        // --------------------------------------------------------

        flow_ok = 1'b1;

        #20;

        if (timeout !== 1'b0)
            $display("ERROR: Timeout did not clear when flow appeared");
        else
            $display("PASS: Timeout cleared when flow detected");

        // --------------------------------------------------------
        // Test 4: Flow disappears again
        // --------------------------------------------------------

        flow_ok = 1'b0;

        #60;

        if (timeout !== 1'b1)
            $display("ERROR: Second timeout did not occur");
        else
            $display("PASS: Second flow timeout detected");

        // --------------------------------------------------------
        // Finish
        // --------------------------------------------------------

        #20;

        $display("----------------------------------------");
        $display("FLOW TIMER TEST COMPLETE");
        $display("----------------------------------------");

        $finish;

    end

endmodule
