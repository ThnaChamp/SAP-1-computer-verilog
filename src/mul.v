`timescale 1ns / 1ps

module mul (
    input wire [7:0] M,      
    input wire [7:0] Q,     
    output reg [7:0] result  
);

    reg [7:0] A;          
    reg [7:0] Q_temp;      
    reg Q_minus_1;         
    integer i;             

    always @(*) begin
        A = 8'b0000_0000;
        Q_temp = Q;
        Q_minus_1 = 1'b0;

        for (i = 0; i < 8; i = i + 1) begin
            
            case ({Q_temp[0], Q_minus_1})
                2'b01: A = A + M;             
                2'b10: A = A + (~M + 1);      
                default: ;                     
            endcase

            Q_minus_1 = Q_temp[0];              
            Q_temp = {A[0], Q_temp[7:1]};     
            A = {A[7], A[7:1]}; 
        end

        result = Q_temp;
    end

endmodule