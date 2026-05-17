`timescale 1ns / 1ps

module ram (
    input wire [3:0] address,   // recieve address from mar
    input wire ce,              // chip enable 
    output wire [7:0] w_bus     // send the value from memory to W-Bus
);

    // variable 8-bit, 16 rows (Array)
    reg [7:0] memory [0:15];

    // read file .mem
    initial begin
        $readmemb("program.mem", memory);
    end

    // ce == 0: send value from memory[address] to W-Bus
    assign w_bus = (!ce) ? memory[address] : 8'bz;

endmodule