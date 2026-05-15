// ไฟล์: alu.v
module alu (
    input wire [1:0] alu_ctrl,       
    input wire eu,            
    input wire [7:0] a_data,  
    input wire [7:0] b_data,  
    output wire [7:0] w_bus  
);

    wire [7:0] add_sub_out;
    wire [7:0] mul_out;
    wire [7:0] div_out;
    reg  [7:0] final_result;

    wire su = alu_ctrl[0];
    wire [7:0] b_com = b_data ^ {8{su}}; 
    assign add_sub_out = a_data + b_com + su;


    always @(*) begin
        case (alu_ctrl)
            2'b00: final_result = add_sub_out;
            2'b01: final_result = add_sub_out; 
            2'b10: final_result = mul_out;     
            2'b11: final_result = div_out;    
            default: final_result = 8'b0000_0000;
        endcase
    end

    assign w_bus = (eu) ? final_result : 8'bz;

endmodule