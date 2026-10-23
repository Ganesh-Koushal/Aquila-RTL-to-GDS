`timescale 1ns/1ps

module water_pump_controller #(
    parameter FLOW_TIMEOUT_CYCLES  = 50000000,
    parameter RESTART_DELAY_CYCLES = 100000000
)(
    input  wire clk,
    input  wire reset,

    input  wire level_low,
    input  wire level_full,
    input  wire flow_ok,
    input  wire power_ok,
    input  wire emergency,

    output wire pump_on,
    output wire alarm,
    output wire fault
);

    // ------------------------------------------------------------
    // Internal signals
    // ------------------------------------------------------------

    wire flow_timeout;
    wire restart_done;

    wire [2:0] state;

    // ------------------------------------------------------------
    // Flow timeout timer
    // ------------------------------------------------------------

    flow_timer #(
        .TIMEOUT_CYCLES(FLOW_TIMEOUT_CYCLES)
    ) u_flow_timer (
        .clk       (clk),
        .reset     (reset),
        .enable    (state == 3'd1),
        .flow_ok   (flow_ok),
        .timeout   (flow_timeout)
    );

    // ------------------------------------------------------------
    // Restart delay timer
    // ------------------------------------------------------------

    restart_timer #(
        .DELAY_CYCLES(RESTART_DELAY_CYCLES)
    ) u_restart_timer (
        .clk       (clk),
        .reset     (reset),
        .enable    (state == 3'd5),
        .done       (restart_done)
    );

    // ------------------------------------------------------------
    // Main FSM
    // ------------------------------------------------------------

    pump_fsm u_pump_fsm (
        .clk             (clk),
        .reset           (reset),
        .level_low       (level_low),
        .level_full      (level_full),
        .flow_ok         (flow_ok),
        .power_ok        (power_ok),
        .emergency       (emergency),
        .flow_timeout    (flow_timeout),
        .restart_done    (restart_done),
        .state           (state)
    );

    // ------------------------------------------------------------
    // Output decoding
    // ------------------------------------------------------------

    assign pump_on = (state == 3'd1) || (state == 3'd2);

    assign alarm   = (state == 3'd3);

    assign fault   = (state == 3'd3);

endmodule
