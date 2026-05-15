// ไฟล์: b_register.v
module b_register (
    input wire clk,
    input wire clr,
    input wire lb,          // สัญญาณ Load B (Active-low)
    input wire [7:0] w_bus,   // รับข้อมูลจาก W-Bus
    output reg [7:0] b_data   // สายตรงส่งข้อมูลไปให้ ALU ตลอดเวลา (ไม่ต้องลง W-Bus)
);

    always @(posedge clk or negedge clr_n) begin
        if (!clr) begin
            b_data <= 8'b0000_0000;
        end else if (!lb) begin 
            b_data <= w_bus;
        end
    end

endmodule