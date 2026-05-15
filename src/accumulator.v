// ไฟล์: accumulator.v
module accumulator (
    input wire clk,
    input wire clr,
    input wire la,          // สัญญาณ Load A (Active-low)
    input wire ea,            // สัญญาณ Enable A (สังเกตว่าตัวนี้เป็น Active-high)
    input wire [7:0] w_bus,   // รับข้อมูลจาก W-Bus
    output reg [7:0] a_data,  // สายตรงส่งข้อมูลไปให้ ALU ตลอดเวลา
    output wire [7:0] a_out   // สายส่งข้อมูลกลับลง W-Bus
);

    always @(posedge clk or negedge clr) begin
        if (!clr) begin
            a_data <= 8'b0000_0000;
        end else if (!la) begin
            a_data <= w_bus;
        end
    end 

    assign a_out = (ea) ? a_data : 8'bz;

endmodule