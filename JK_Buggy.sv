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
        $write("%t: Reset", $time); // How to represent the time in terms of ps or ns?
        Checkif(TBForce.Q);
        TBForce.rst <= 0; 
    endtask: TestRst

    task TestValues;
        input [1:0]J, K, sel;
        logic j,k;
        static reg PrevQ = TBForce.Q;
        TBForce.J <= J;
        TBForce.K <= K;
        TBForce.sel <= sel;
        assign {j,k} = {sel[0]?(J[1]):(J[0]), sel[1]?(K[1]):(K[0])};
        repeat (2) @(TBForce);
        $write("%t: J = %b, sel[J] = %d, K = %b, sel[K] = %d --> PrevQ = %b, Q = %b", $time, J, sel[0], K, sel[1], PrevQ, TBForce.Q);
        case ({j,k})
            2'd0: Checkif(TBForce.Q != PrevQ);
            2'd1: Checkif(TBForce.Q != 0);
            2'd2: Checkif(TBForce.Q != 1);
            2'd3: Checkif(TBForce.Q == PrevQ);
            default: $display("No Values forced");
        endcase
    endtask: TestValues

    task Checkif;
        input ErrCondition;
        if(ErrCondition)
            $display(" is Not working");
        else
            $display(" is Working");
    endtask: Checkif

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
