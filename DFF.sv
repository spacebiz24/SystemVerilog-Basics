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

interface D_TB (input clk);
    logic [1:0]D;
    logic sel, rst;
    logic Q;
    
    modport DFF_ports(input D, sel, rst, clk, output Q);
    
    parameter tsetup = 2, thold = 3;
    clocking TBForce @(posedge clk);
        default input #(tsetup) output #(thold);
        output D, sel, rst;
        input Q;
    endclocking: TBForce
    
    modport TB_ports(clocking TBForce);
endinterface: D_TB

module DFF(D_TB.DFF_ports D_IF);
    logic d;
    always_comb
        d = D_IF.sel?(D_IF.D[1]):(D_IF.D[0]);
    always_ff @(posedge D_IF.clk)
    begin
        if (D_IF.rst)
            D_IF.Q <= 0;
        else
            D_IF.Q <= d;
    end
endmodule: DFF


module test_bench(D_TB.TB_ports TB_IF);
    initial 
    begin
        @(TB_IF.TBForce);
        TestRst;
        for (int D=0; D<4; D++)
            for (int sel=0;sel<2;sel++)
                TestValues(D, sel);
    end
    
    task TestRst;
        TB_IF.TBForce.rst <= 1;
        repeat (2) @(TB_IF.TBForce);
        $write("%t: Reset", $time);
        Checkif(TB_IF.TBForce.Q);
        TB_IF.TBForce.rst <= 0; 
    endtask: TestRst
    
    task TestValues;
        input [1:0]D;
        input sel;
        bit d;
        static reg PrevQ = TB_IF.TBForce.Q;
        TB_IF.TBForce.D <= D;
        TB_IF.TBForce.sel <= sel;
        assign d = sel?(D[1]):(D[0]);
        repeat (2) @(TB_IF.TBForce);
        $write("%t: D = %b, sel = %d --> PrevQ = %b, Q = %b", $time, D, sel, PrevQ, TB_IF.TBForce.Q);
        Checkif(TB_IF.TBForce.Q != d);
    endtask: TestValues
    
    task Checkif;
        input ErrCondition;
        if(ErrCondition)
            $display(" is not working");
        else
            $display(" is working");
    endtask: Checkif
endmodule

module Top();
    bit clk;
    always #10 clk = ~clk;
    D_TB  bus (clk);
    DFF DUV (bus);
    test_bench TB (bus);
endmodule: Top
