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

// Add a 2:1 mux to the DUV
interface D_TB (clk);
    input clk;
    logic D, rst;
    logic Q;

    modport DFF_ports(input D, rst, clk, output Q);


    parameter tsetup = 2, thold = 3;
    clocking TBForce @(posedge clk);
        default input #(tsetup) output #(thold);
        output D, rst;
        input Q;
    endclocking: TBForce

    task TestRst;
        TBForce.rst <= 1;
        repeat (2) @(TBForce);
        $write("%t: Reset", $time);
        Checkif(TBForce.Q);
        TBForce.rst <= 0; 
    endtask: TestRst

    task TestValues;
        input D;
        static reg PrevQ = TBForce.Q;
        TBForce.D <= D;
        repeat (2) @(TBForce);
        $write("%t: D = %b --> PrevQ = %b, Q = %b", $time, D, PrevQ, TBForce.Q);
        Checkif(TBForce.Q != D);
    endtask: TestValues

    task Checkif;
        input ErrCondition;
        if(ErrCondition)
            $display(" is not working");
        else
            $display(" is working");
    endtask: Checkif

    modport TB_ports(clocking TBForce, task TestRst, task TestValues);
endinterface: D_TB

module DFF(D_TB.DFF_ports D_IF);
    always_ff @(posedge D_IF.clk)
    begin
        if (D_IF.rst)
            D_IF.Q <= 0;
        else
            D_IF.Q <= D_IF.D;
    end
endmodule: DFF

module DTestCases(D_TB.TB_ports TB_IF);
    initial 
    begin
        @(TB_IF.TBForce);
        TB_IF.TestRst;
        for (int D=0; D<2; D++)
            TB_IF.TestValues(D);
    end
endmodule: DTestCases

module Top();
    bit clk;
    always #10 clk = ~clk;
    D_TB  bus (clk);
    DFF DUV (bus);
    DTestCases TB (bus);
endmodule: Top
