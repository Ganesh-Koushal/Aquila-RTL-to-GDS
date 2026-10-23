`timescale 1ns/1ps

module pump_fsm (
    input  wire clk,
    input  wire reset,

    input  wire level_low,
    input  wire level_full,
    input  wire flow_ok,
    input  wire power_ok,
    input  wire emergency,

    input  wire flow_timeout,
    input  wire restart_done,

    output reg [2:0] state
);

    // ------------------------------------------------------------
    // State definitions
    // ------------------------------------------------------------

    localparam STATE_IDLE       = 3'd0;
    localparam STATE_FLOW_WAIT  = 3'd1;
    localparam STATE_RUNNING    = 3'd2;
    localparam STATE_FAULT      = 3'd3;
    localparam STATE_POWER_FAIL = 3'd4;
    localparam STATE_RESTART    = 3'd5;

    reg [2:0] next_state;

    // ------------------------------------------------------------
    // State register
    // ------------------------------------------------------------

    always @(posedge clk or posedge reset) begin

        if (reset)
            state <= STATE_IDLE;

        else
            state <= next_state;

    end

    // ------------------------------------------------------------
    // Next-state logic
    // ------------------------------------------------------------

    always @(*) begin

        next_state = state;

        case (state)

            // ----------------------------------------------------
            // IDLE
            // ----------------------------------------------------

            STATE_IDLE: begin

                if (emergency)
                    next_state = STATE_FAULT;

                else if (!power_ok)
                    next_state = STATE_POWER_FAIL;

                else if (level_full)
                    next_state = STATE_IDLE;

                else if (level_low)
                    next_state = STATE_FLOW_WAIT;

            end

            // ----------------------------------------------------
            // FLOW WAIT
            // ----------------------------------------------------

            STATE_FLOW_WAIT: begin

                if (emergency)
                    next_state = STATE_FAULT;

                else if (!power_ok)
                    next_state = STATE_POWER_FAIL;

                else if (level_full)
                    next_state = STATE_IDLE;

                else if (flow_ok)
                    next_state = STATE_RUNNING;

                else if (flow_timeout)
                    next_state = STATE_FAULT;

            end

            // ----------------------------------------------------
            // RUNNING
            // ----------------------------------------------------

            STATE_RUNNING: begin

                if (emergency)
                    next_state = STATE_FAULT;

                else if (!power_ok)
                    next_state = STATE_POWER_FAIL;

                else if (level_full)
                    next_state = STATE_IDLE;

            end

            // ----------------------------------------------------
            // FAULT
            // ----------------------------------------------------

            STATE_FAULT: begin

                // Fault remains latched.
                // Reset is required for recovery.

                next_state = STATE_FAULT;

            end

            // ----------------------------------------------------
            // POWER FAILURE
            // ----------------------------------------------------

            STATE_POWER_FAIL: begin

                if (!power_ok)
                    next_state = STATE_POWER_FAIL;

                else
                    next_state = STATE_RESTART;

            end

            // ----------------------------------------------------
            // RESTART DELAY
            // ----------------------------------------------------

            STATE_RESTART: begin

                if (emergency)
                    next_state = STATE_FAULT;

                else if (!power_ok)
                    next_state = STATE_POWER_FAIL;

                else if (restart_done) begin

                    if (level_full)
                        next_state = STATE_IDLE;

                    else if (level_low)
                        next_state = STATE_FLOW_WAIT;

                    else
                        next_state = STATE_IDLE;

                end

            end

            // ----------------------------------------------------
            // Safety fallback
            // ----------------------------------------------------

            default:
                next_state = STATE_IDLE;

        endcase

    end

endmodule
