`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.03.2023 01:27:10
// Design Name: 
// Module Name: JK_FlipFlop
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

interface JK_TB (clk);
    input clk;
    logic [1:0]J, K, sel; 
    logic rst;
    logic Q;

    modport JKFF_ports(input J, K, sel, rst, clk, output Q);


    parameter tsetup = 2, thold = 3;
    clocking TBForce @(posedge clk);
        default input #(tsetup) output #(thold);
        output J, K, sel, rst;
        input Q;
    endclocking: TBForce

    task TestRst;
        TBForce.rst <= 1;
        repeat (2) @(TBForce);
            if (TBForce.Q)
            begin
                $display("Reset is not working");
                $stop;
            end
            else
                $display("Reset is working");
        TBForce.rst <= 0; 
    endtask: TestRst

    task TestValues;
        input [1:0]J, K, sel;
        logic j,k;
        reg PrevQ = TBForce.Q;
        TBForce.J <= J;
        TBForce.K <= K;
        TBForce.sel <= sel;
        repeat (2) @(TBForce);
        assign {j,k} = {sel[0]?(J[1]):(J[0]), sel[1]?(K[1]):(K[0])};
        case ({j,k})
            2'd0: if (TBForce.Q != PrevQ) Message(j, k, sel, 1); else Message(j, k, sel, 0);
            2'd1: if (TBForce.Q != 0) Message(j, k, sel, 1); else Message(j, k, sel, 0);
            2'd2: if (TBForce.Q != 1) Message(j, k, sel, 1); else Message(j, k, sel, 0);
            2'd3: if (TBForce.Q == PrevQ) Message(j, k, sel, 1); else Message(j, k, sel, 0);
        endcase
    endtask: TestValues

    task Message; // write a better error message
        input J, K;
        input [1:0]sel;
        input errcode;
        $write("J[%d]=%b, K[%d]=%b is ", sel[0], J, sel[1], K);
        if(errcode)
            $display("Not working");
        else
            $display("Working");
    endtask: Message

    modport TB_ports(clocking TBForce, task TestRst, task TestValues);
endinterface: JK_TB

module JKFF(JK_TB.JKFF_ports JK_IF);
    logic j,k;
    always_comb
    begin
        j = JK_IF.sel[0]?(JK_IF.J[1]):(JK_IF.J[0]);
        k = JK_IF.sel[1]?(JK_IF.K[1]):(JK_IF.K[0]);
    end
    always_ff @(posedge JK_IF.clk or negedge JK_IF.rst)
    begin
        if (JK_IF.rst)
            JK_IF.Q <= 0;
        else
            case({j,k})
                2'd0: JK_IF.Q <= JK_IF.Q;
                2'd1: JK_IF.Q <= 1'b0;
                2'd2: JK_IF.Q <= 1'b1;
                2'd3: JK_IF.Q <= ~JK_IF.Q;
            endcase
    end
endmodule: JKFF

module JKTestCases(JK_TB.TB_ports TB_IF);
    initial 
    begin
        @(TB_IF.TBForce);
        TB_IF.TestRst;
        for (int J=0; J<4; J++)
            for (int K=0; K<4; K++)
                for(int sel=0; sel<4; sel++)
                    TB_IF.TestValues(J, K, sel);
    end
endmodule: JKTestCases

module Top();
    bit clk;
    always #10 clk = ~clk;
    JK_TB  bus (clk);
    JKFF DUV (bus);
    JKTestCases TB (bus);
endmodule: Top
