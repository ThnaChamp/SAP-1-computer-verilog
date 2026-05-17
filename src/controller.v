`timescale 1ns / 1ps

`include "sap1_defines.v" 

module controller (
    input wire clk,
    input wire clr,
    input wire [3:0] opcode,
    input wire div_err,         // Error signal from ALU
    
    output reg cp, ep,          // PC
    output reg lm,              // MAR
    output reg ce,              // RAM
    output reg li, ei,          // IR
    output reg la, ea,          // Accumulator A
    output reg lb,              // Register B
    output reg [1:0] alu_ctrl,  // ALU (00=ADD, 01=SUB, 10=MUL, 11=DIV)
    output reg eu,              // ALU Enable
    output reg lo,              // Output Register
    output reg hlt              // Signal for end program
);

    reg [2:0] t_state;          // State Register T1 -> T6

    always @(posedge clk or negedge clr) begin
        if (!clr) begin
            t_state <= 3'd1;
        end 
        else if (hlt == 1'b0) begin
            if (t_state == 3'd6)
                t_state <= 3'd1;
            else
                t_state <= t_state + 1;
        end
    end

    always @(*) begin
        cp=0; ep=0; lm=1; ce=1; li=1; ei=1; 
        la=1; ea=0; lb=1; lo=1; 
        alu_ctrl=2'b00; eu=0; hlt=0;

        // Halt on Division by Zero
        if (opcode == `DIV && div_err == 1'b1) begin
            hlt = 1'b1;
        end

        case (t_state)
        
            // T1: Fetch (MAR <- PC)
            3'd1: begin
                ep = 1'b1;     
                lm = 1'b0;      
            end

            // T2: Increment (PC <- PC + 1)
            3'd2: begin
                cp = 1'b1;      
            end
            
            // T3: Memory (IR <- RAM)
            3'd3: begin         
                ce = 1'b0;     
                li = 1'b0;     
            end
            
            // T4: Execute Phase 1
            3'd4: begin        
                case (opcode)
                    `LDA, `ADD, `SUB, `MUL, `DIV: begin
                        ei = 1'b0;  
                        lm = 1'b0;  
                    end
                    `OUT: begin
                        ea = 1'b1;    
                        lo = 1'b0;  
                    end
                    `HLT: begin
                        hlt = 1'b1;  
                    end
                    default: ;
                endcase
            end
            
            // T5: Execute Phase 2
            3'd5: begin        
                case (opcode)
                    `LDA: begin
                        ce = 1'b0;  
                        la = 1'b0;  
                    end
                    `ADD, `SUB, `MUL, `DIV: begin
                        ce = 1'b0; 
                        lb = 1'b0;  
                    end
                    default: ;
                endcase
            end
            
            // T6: Execute Phase 3
            3'd6: begin 
                case (opcode)
                    `ADD: begin
                        eu = 1'b1;       
                        alu_ctrl = 2'b00;    
                        la = 1'b0;        
                    end
                    `SUB: begin
                        eu = 1'b1;           
                        alu_ctrl = 2'b01;   
                        la = 1'b0;         
                    end
                    `MUL: begin
                        eu = 1'b1;           
                        alu_ctrl = 2'b10;   
                        la = 1'b0;         
                    end
                    `DIV: begin
                        eu = 1'b1;           
                        alu_ctrl = 2'b11;    
                        la = 1'b0;         
                    end
                    default: ;
                endcase
            end
            default: ;
        endcase
    end

endmodule