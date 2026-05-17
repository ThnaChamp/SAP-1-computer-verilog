`timescale 1ns / 1ps

module mar (
    input wire clk,             // clock
    input wire clr,             // clear
    input wire lm,              // laod mar
    input wire [3:0] w_bus,     // recieve value from W-Bus
    output reg [3:0] mar_out    // send address to RAM
);

    always @(posedge clk or negedge clr) begin
        if (!clr) begin
            mar_out <= 4'b0000;

        // lm == 0: copy value from W-Bus
        end else if (!lm) begin 
            mar_out <= w_bus;
        end
    end

endmodule