`timescale 1ns / 1ps

module pc (
    input wire clk,             // clock    
    input wire clr,             // clear
    input wire cp,              // count enable (pc increment)
    input wire ep,              // enable output to W-Bus
    output reg [3:0] pc_count,  // current count value
    output wire [3:0] w_bus     // wire connect to W-Bus
);

    always @(posedge clk or negedge clr) begin
        // clear
        if (!clr) begin
            pc_count <= 4'b0000;
        // cp == 1: pc increment
        end else if (cp) begin
            pc_count <= pc_count + 1;
        end
    end

    // Tri-state buffer:
    assign w_bus = (ep) ? pc_count : 4'bz; // ep == 1: W-Bus = pc value
                                           // ep == 0: W-Bus = z (High-Impedance)

endmodule