`timescale 1ns / 1ps

// ไฟล์: ir.v
module ir (
    input wire clk,             // clock
    input wire clr,             // clear
    input wire li,              // load IR
    input wire ei,              // enable IR
    input wire [7:0] w_bus,     // recieve value from W-Bus
    output wire [3:0] opcode,   // send value to Controll Unit
    output wire [7:0] ir_out    // send address back to W-Bus
);

    reg [7:0] ir_data;          // variable 8 bit

    always @(posedge clk or negedge clr) begin
        if (!clr) begin
            ir_data <= 8'b0000_0000;
        
        // li == 0: copy value from W-Bus
        end else if (!li) begin
            ir_data <= w_bus;
        end
    end

    // seperate the 4 upper bit (bits 7 -> 4) and sent to Control Unit
    assign opcode = ir_data[7:4];

    // ei == 0: 'z' + 4 lower bit (bits 4 -> 0) sent to W-Bus
    assign ir_out = (!ei) ? {4'bz, ir_data[3:0]} : 8'bz;
endmodule