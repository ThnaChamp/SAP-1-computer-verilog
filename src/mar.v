module mar (
    input wire clk,         
    input wire clr_n,         
    input wire lm_n,         
    input wire [3:0] w_bus,   
    output reg [3:0] mar_out  
);

    always @(posedge clk or negedge clr_n) begin
        if (!clr_n) begin
            mar_out <= 4'b0000;
        end else if (!lm_n) begin 
            mar_out <= w_bus;
        end
    end

endmodule