// ไฟล์: ram.v
module ram (
    input wire [3:0] address, 
    input wire ce_n,       
    output wire [7:0] w_bus  
);

    reg [7:0] memory [0:15];

    initial begin
        // ใ่ส่ data ใน memory
    end

    assign w_bus = (!ce_n) ? memory[address] : 8'bz;

endmodule