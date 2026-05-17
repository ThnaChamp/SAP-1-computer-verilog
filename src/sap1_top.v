`timescale 1ns / 1ps

module sap1_top (
    input wire clk,             // clock
    input wire clr,             // clear
    output wire [7:0] display,  // output 8 bit
    output wire hlt_flag        // Signal for end program
);

    wire [7:0] w_bus;          // W-Bus 8 bit
    wire [3:0] mar_to_ram;     // connect MAR to RAM
    wire [3:0] ir_to_ctrl;     // send opcode 4 bit to Control Unit
    wire [7:0] a_to_alu;       // connect A to ALU
    wire [7:0] b_to_alu;       // connect B to ALU
    wire div_error;            // if divide 0

    wire cp, ep;
    wire lm;
    wire ce;
    wire li, ei;
    wire la, ea;
    wire lb;
    wire [1:0] alu_ctrl;
    wire eu;
    wire lo;

    // Control Unit
    controller u_controller (
        .clk(clk), .clr(clr), .opcode(ir_to_ctrl),
        .div_err(div_error),
        .cp(cp), .ep(ep), .lm(lm), .ce(ce),
        .li(li), .ei(ei), .la(la), .ea(ea),
        .lb(lb), .alu_ctrl(alu_ctrl), .eu(eu),
        .lo(lo), .hlt(hlt_flag)
    );

    wire [3:0] pc_count_out;

    // Program Counter
    pc u_pc (
        .clk(clk), .clr(clr), .cp(cp), .ep(ep),
        .pc_count(pc_count_out), 
        .w_bus(w_bus[3:0])
    );

    // 
    assign w_bus[7:4] = (ep) ? 4'b0000 : 4'bz;

    // MAR (Memory Address Register)
    mar u_mar (
        .clk(clk), .clr(clr), .lm(lm),
        .w_bus(w_bus[3:0]),
        .mar_out(mar_to_ram)
    );

    // RAM (16x8)
    ram u_ram (
        .address(mar_to_ram), .ce(ce),
        .w_bus(w_bus)
    );

    // IR (Instruction Register)
    ir u_ir (
        .clk(clk), .clr(clr), .li(li), .ei(ei),
        .w_bus(w_bus),
        .opcode(ir_to_ctrl), 
        .ir_out(w_bus)
    );

    // Accumulator (A)
    accumulator u_acc (
        .clk(clk), .clr(clr), .la(la), .ea(ea),
        .w_bus(w_bus),
        .a_data(a_to_alu), 
        .a_out(w_bus)
    );

    // B Register
    b_register u_b_reg (
        .clk(clk), .clr(clr), .lb(lb),
        .w_bus(w_bus),
        .b_data(b_to_alu)
    );

    // ALU (ADD, SUB, MUL and DIV)
    alu u_alu (
        .alu_ctrl(alu_ctrl), .eu(eu),
        .a_data(a_to_alu), .b_data(b_to_alu),
        .w_bus(w_bus),
        .div_err(div_error)
    );

    // Output Register
    out_register u_out_reg (
        .clk(clk), .clr(clr), .lo(lo),
        .w_bus(w_bus),
        .out_data(display)
    );

endmodule