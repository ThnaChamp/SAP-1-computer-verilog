`timescale 1ns / 1ps

module div (
    input wire [7:0] dividend,   // Dividend (from Accumulator A)
    input wire [7:0] divisor,    // Divisor (from Register B)
    output reg [7:0] quotient,   // Final result
    output reg div_zero_err      // Divide by zero error flag
);

    reg [7:0] A_reg;             // Temporary accumulator (Remainder)
    reg [7:0] Q_reg;             // Temporary dividend (Quotient)
    reg [7:0] M_reg;             // Temporary divisor
    integer i;

    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;
    reg sign_q;                  // Result sign bit

    always @(*) begin
        // Handle Division by Zero
        if (divisor == 8'b0000_0000) begin
            quotient = 8'b0000_0000;
            div_zero_err = 1'b1;
        end 
        else begin
            div_zero_err = 1'b0;

            // Convert to absolute values
            abs_dividend = (dividend[7]) ? (~dividend + 1) : dividend;
            abs_divisor  = (divisor[7])  ? (~divisor + 1)  : divisor;
            
            // Determine sign of the result
            sign_q = dividend[7] ^ divisor[7];

            // Initialize registers for long division
            A_reg = 8'b0000_0000;
            Q_reg = abs_dividend;
            M_reg = abs_divisor;

            // Restoring division algorithm (8 iterations)
            for (i = 0; i < 8; i = i + 1) begin
                
                // Shift {A, Q} left by 1 bit
                A_reg = {A_reg[6:0], Q_reg[7]};
                Q_reg = {Q_reg[6:0], 1'b0};

                // Subtract divisor from A
                A_reg = A_reg - M_reg;

                // Check if result is negative (MSB of A)
                if (A_reg[7] == 1'b1) begin
                    A_reg = A_reg + M_reg; // Restore A
                    Q_reg[0] = 1'b0;       // Quotient bit is 0
                end else begin
                    Q_reg[0] = 1'b1;       // Quotient bit is 1
                end
            end

            // Apply sign to the final quotient
            if (sign_q) begin
                quotient = ~Q_reg + 1;
            end else begin
                quotient = Q_reg;
            end
        end
    end

endmodule
