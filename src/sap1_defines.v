`timescale 1ns / 1ps

`define LDA 4'b0000 // Load memory value into A [cite: 118]
`define ADD 4'b0001 // Add memory value to A [cite: 118]
`define SUB 4'b0010 // Subtract memory value from A [cite: 118]
`define MUL 4'b0011 // Multiply A by memory value [cite: 109, 118]
`define DIV 4'b0100 // Divide A by memory value [cite: 110, 118]
`define OUT 4'b1110 // Output value of A [cite: 118]
`define HLT 4'b1111 // Halt execution [cite: 118]