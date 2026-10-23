`timescale 1ns/1ps

module tb_pump_fsm;

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

    reg flow_timeout;
    reg restart_done;

    wire [2:0] state;

    // ------------------------------------------------------------
    // State definitions
    // ------------------------------------------------------------

    localparam STATE_IDLE       = 3'd0;
    localparam STATE_FLOW_WAIT  = 3'd1;
    localparam STATE_RUNNING    = 3'd2;
    localparam STATE_FAULT      = 3'd3;
    localparam STATE_POWER_FAIL = 3'd4;
    localparam STATE_RESTART    = 3'd5;

    // ------------------------------------------------------------
    // Device Under Test
    // ------------------------------------------------------------

    pump_fsm dut (
        .clk          (clk),
        .reset        (reset),
        .level_low    (level_low),
        .level_full   (level_full),
        .flow_ok      (flow_ok),
        .power_ok     (power_ok),
        .emergency    (emergency),
        .flow_timeout (flow_timeout),
        .restart_done (restart_done),
        .state        (state)
    );

    // ------------------------------------------------------------
    // Clock
    // ------------------------------------------------------------

    always #5 clk = ~clk;

    // ------------------------------------------------------------
    // State monitor
    // ------------------------------------------------------------

    task check_state;

        input [2:0] expected_state;
        input [200*8-1:0] message;

        begin

            #1;

            if (state !== expected_state)
                $display("ERROR: %s | Expected=%d Actual=%d",
                         message, expected_state, state);
            else
                $display("PASS: %s", message);

        end

    endtask

    // ------------------------------------------------------------
    // Test sequence
    // ------------------------------------------------------------

    initial begin

        $dumpfile("tb_pump_fsm.vcd");
        $dumpvars(0, tb_pump_fsm);

        // --------------------------------------------------------
        // Initial conditions
        // --------------------------------------------------------

        clk          = 1'b0;
        reset        = 1'b1;

        level_low    = 1'b0;
        level_full   = 1'b0;
        flow_ok      = 1'b0;
        power_ok     = 1'b1;
        emergency    = 1'b0;

        flow_timeout = 1'b0;
        restart_done = 1'b0;

        #20;

        reset = 1'b0;

        check_state(STATE_IDLE, "Reset -> IDLE");

        // --------------------------------------------------------
        // TEST 1: Low tank starts pump
        // --------------------------------------------------------

        level_low = 1'b1;

        @(posedge clk);
        #1;

        check_state(STATE_FLOW_WAIT,
                    "Low tank -> FLOW_WAIT");

        // --------------------------------------------------------
        // TEST 2: Flow detected
        // --------------------------------------------------------

        flow_ok = 1'b1;

        @(posedge clk);
        #1;

        check_state(STATE_RUNNING,
                    "Flow detected -> RUNNING");

        // --------------------------------------------------------
        // TEST 3: Full tank stops pump
        // --------------------------------------------------------

        level_full = 1'b1;

        @(posedge clk);
        #1;

        check_state(STATE_IDLE,
                    "Full tank -> IDLE");

        // Clear level signals
        level_low  = 1'b0;
        level_full = 1'b0;
        flow_ok    = 1'b0;

        // --------------------------------------------------------
        // TEST 4: No-flow fault
        // --------------------------------------------------------

        level_low = 1'b1;

        @(posedge clk);
        #1;

        check_state(STATE_FLOW_WAIT,
                    "Low tank -> FLOW_WAIT again");

        flow_timeout = 1'b1;

        @(posedge clk);
        #1;

        check_state(STATE_FAULT,
                    "Flow timeout -> FAULT");

        // --------------------------------------------------------
        // TEST 5: Fault remains latched
        // --------------------------------------------------------

        flow_timeout = 1'b0;
        level_low    = 1'b0;

        repeat (2) @(posedge clk);

        check_state(STATE_FAULT,
                    "Fault remains latched");

        // --------------------------------------------------------
        // TEST 6: Reset clears fault
        // --------------------------------------------------------

        reset = 1'b1;

        #10;

        reset = 1'b0;

        check_state(STATE_IDLE,
                    "Reset clears FAULT -> IDLE");

        // --------------------------------------------------------
        // TEST 7: Power failure
        // --------------------------------------------------------

        power_ok = 1'b0;

        @(posedge clk);
        #1;

        check_state(STATE_POWER_FAIL,
                    "Power loss -> POWER_FAIL");

        // --------------------------------------------------------
        // TEST 8: Power returns
        // --------------------------------------------------------

        power_ok = 1'b1;

        @(posedge clk);
        #1;

        check_state(STATE_RESTART,
                    "Power restored -> RESTART");

        // --------------------------------------------------------
        // TEST 9: Restart delay completed with low tank
        // --------------------------------------------------------

        level_low    = 1'b1;
        restart_done = 1'b1;

        @(posedge clk);
        #1;

        check_state(STATE_FLOW_WAIT,
                    "Restart complete + low tank -> FLOW_WAIT");

        // --------------------------------------------------------
        // TEST 10: Emergency shutdown
        // --------------------------------------------------------

        emergency = 1'b1;

        @(posedge clk);
        #1;

        check_state(STATE_FAULT,
                    "Emergency -> FAULT");

        // --------------------------------------------------------
        // Finish
        // --------------------------------------------------------

        #20;

        $display("----------------------------------------");
        $display("PUMP FSM TEST COMPLETE");
        $display("----------------------------------------");

        $finish;

    end

endmodule
