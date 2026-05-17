`timescale 1ns / 1ps

module out_register (
    input wire clk,
    input wire clr,
    input wire lo,        
    input wire [7:0] w_bus,   
    output reg [7:0] out_data 
);

    always @(posedge clk or negedge clr) begin
        if (!clr) begin
            out_data <= 8'b0000_0000;
        
        // lo == 0: send data to display
        end else if (!lo) begin
            out_data <= w_bus;
        end
    end

endmodule