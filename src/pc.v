module pc (
    input wire clk,    
    input wire clr,  
    input wire cp,      
    input wire ep,      
    output reg [3:0] pc_count, 
    output wire [3:0] w_bus 
);

    always @(posedge clk or negedge clr) begin
        if (!clr_n) begin
            pc_count <= 4'b0000;
        end else if (cp) begin
            pc_count <= pc_count + 1;
        end
    end

    assign w_bus = (ep) ? pc_count : 4'bz; // ep = 1 -> w_bus = ค่าใน pc
                                           // ep = 0 -> w_bus = สายเปล่า 

endmodule