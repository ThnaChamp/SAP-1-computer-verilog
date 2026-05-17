`timescale 1ns / 1ps

module b_register (
    input wire clk,             // clock
    input wire clr,             // clear
    input wire lb,              // laod B
    input wire [7:0] w_bus,     // recieve value from W-Bus
    output reg [7:0] b_data     // send value to ALU 
);

    always @(posedge clk or negedge clr) begin
        if (!clr) begin
            b_data <= 8'b0000_0000;

        // lb == 0: copy value from W-Bus to ALU
        end else if (!lb) begin 
            b_data <= w_bus;
        end
    end

endmodule