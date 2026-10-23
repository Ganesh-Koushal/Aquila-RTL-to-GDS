`timescale 1ns/1ps

module flow_timer #(
    parameter TIMEOUT_CYCLES = 50000000
)(
    input  wire clk,
    input  wire reset,
    input  wire enable,
    input  wire flow_ok,

    output reg timeout
);

    localparam COUNTER_WIDTH =
        (TIMEOUT_CYCLES <= 1) ? 1 :
        $clog2(TIMEOUT_CYCLES + 1);

    reg [COUNTER_WIDTH-1:0] counter;

    always @(posedge clk or posedge reset) begin

        if (reset) begin
            counter <= 0;
            timeout <= 1'b0;
        end

        else if (!enable) begin
            counter <= 0;
            timeout <= 1'b0;
        end

        else if (flow_ok) begin
            counter <= 0;
            timeout <= 1'b0;
        end

        else if (counter >= TIMEOUT_CYCLES - 1) begin
            counter <= counter;
            timeout <= 1'b1;
        end

        else begin
            counter <= counter + 1'b1;
            timeout <= 1'b0;
        end

    end

endmodule
