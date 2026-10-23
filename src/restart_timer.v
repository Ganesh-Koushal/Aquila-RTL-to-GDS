`timescale 1ns/1ps

module restart_timer #(
    parameter DELAY_CYCLES = 100000000
)(
    input  wire clk,
    input  wire reset,
    input  wire enable,

    output reg done
);

    localparam COUNTER_WIDTH =
        (DELAY_CYCLES <= 1) ? 1 :
        $clog2(DELAY_CYCLES + 1);

    reg [COUNTER_WIDTH-1:0] counter;

    always @(posedge clk or posedge reset) begin

        if (reset) begin
            counter <= 0;
            done    <= 1'b0;
        end

        else if (!enable) begin
            counter <= 0;
            done    <= 1'b0;
        end

        else if (counter >= DELAY_CYCLES - 1) begin
            counter <= counter;
            done    <= 1'b1;
        end

        else begin
            counter <= counter + 1'b1;
            done    <= 1'b0;
        end

    end

endmodule
