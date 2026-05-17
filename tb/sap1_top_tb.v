`timescale 1ns / 1ps

module sap1_top_tb;

    reg clk;
    reg clr;
    wire [7:0] display;
    wire hlt_flag;

    sap1_top uut (
        .clk(clk),
        .clr(clr),
        .display(display),
        .hlt_flag(hlt_flag)
    );

    always #5 clk = ~clk;

    always @(posedge clk) begin
        if (clr == 1'b1 && uut.u_controller.hlt == 1'b0) begin
            $display("[CONTROLLER] Time: %0t ns | State: T%0d | Opcode: %b", $time, uut.u_controller.t_state, uut.u_controller.opcode);
            $display("             Control Word -> CP:%b EP:%b LM:%b CE:%b LI:%b EI:%b LA:%b EA:%b LB:%b ALU_CTRL:%b EU:%b LO:%b",
                uut.u_controller.cp,
                uut.u_controller.ep,
                uut.u_controller.lm,
                uut.u_controller.ce,
                uut.u_controller.li,
                uut.u_controller.ei,
                uut.u_controller.la,
                uut.u_controller.ea,
                uut.u_controller.lb,
                uut.u_controller.alu_ctrl,
                uut.u_controller.eu,
                uut.u_controller.lo
            );
            $display("--------------------------------------------------------------------------------");
        end
    end

    always @(display) begin
        if (display !== 8'hxx && display !== 8'hzz && clr == 1'b1) begin
            $display("🌟 [OUTPUT DISPLAY] Time: %0t ns | Value -> Decimal: %d | Hex: %h", $time, display, display);
            $display("================================================================================");
        end
    end

    initial begin
        $display("================================================================================");
        $display("🚀 Starting SAP-1 Advanced Controller Tracking Test");
        $display("================================================================================");

        clk = 0;
        clr = 0;
        #20;
        
        clr = 1;

        wait (hlt_flag == 1'b1 || $time > 2000);

        if (hlt_flag == 1'b1) begin
            if (uut.div_error == 1'b1) begin
                $display("⚠️  Program HALTED due to DIVISION BY ZERO ERROR at %0t ns", $time);
            end else begin
                $display("✅ Program Halted Successfully at %0t ns", $time);
            end
            $display("Final Display Value: %d", display);
        end else begin
            $display("❌ Simulation Timeout (Error)");
        end
        $display("================================================================================");

        #20;
        $finish;
    end
endmodule