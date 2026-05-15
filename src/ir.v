// ไฟล์: ir.v
module ir (
    input wire clk,
    input wire clr,
    input wire li,          // สัญญาณ Load IR (Active-low)
    input wire ei,          // สัญญาณ Enable IR (Active-low)
    input wire [7:0] w_bus,   // รับข้อมูล 8 บิตจาก W-Bus
    output wire [3:0] opcode, // สายตรงส่ง Opcode ไปให้ Control Unit เสมอ
    output wire [7:0] ir_out  // สายส่ง Address กลับลง W-Bus (ใช้ Tri-state)
);

    reg [7:0] ir_data;

    always @(posedge clk or negedge clr) begin
        if (!clr) begin
            ir_data <= 8'b0000_0000;
        end else if (!li) begin
            ir_data <= w_bus;
        end
    end

    // แยก 4 บิตบน (บิตที่ 7 ถึง 4) ส่งไปให้ Control Unit ตลอดเวลา
    assign opcode = ir_data[7:4];

    // Tri-state buffer: ถ้า Ei_n เป็น 0 ให้ส่ง 4 บิตล่างลง W-Bus
    // ข้อควรระวัง: เราดึงบัสลงแค่ 4 บิตล่าง ส่วน 4 บิตบนเราต้องปล่อยลอย ('z') เอาไว้
    assign ir_out = (!ei) ? {4'bz, ir_data[3:0]} : 8'bz;

endmodule