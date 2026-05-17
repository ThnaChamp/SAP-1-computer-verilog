`timescale 1ns / 1ps

module accumulator (
    input wire clk,             // clock
    input wire clr,             // clear
    input wire la,              // laod A
    input wire ea,              // enable A
    input wire [7:0] w_bus,     // recieve value from W-Bus
    output reg [7:0] a_data,    // send value to ALU 
    output wire [7:0] a_out     // send value back to W-Bus
);

    always @(posedge clk or negedge clr) begin
        if (!clr) begin
            a_data <= 8'b0000_0000;
        
        // la == 0: copy value from W-Bus to ALU
        end else if (!la) begin
            a_data <= w_bus;
        end
    end 

    // ea == 1: sent data to W-Bus
    assign a_out = (ea) ? a_data : 8'bz;

endmodule