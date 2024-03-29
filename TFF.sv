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

interface T_TB (clk);
    input clk;
    logic [1:0]T;
    logic sel, rst;
    logic Q;

    modport TFF_ports(input T, sel, rst, clk, output Q);


    parameter tsetup = 2, thold = 3;
    clocking TBForce @(posedge clk);
        default input #(tsetup) output #(thold);
        output T, sel, rst;
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
        input [1:0]T;
        input sel;
        bit t;
        static reg PrevQ = TBForce.Q;
        TBForce.T <= T;
        TBForce.sel <= sel;
        assign t = sel?(T[1]):(T[0]);
        repeat (2) @(posedge TBForce);
        $write("%t: T = %b, sel = %d --> PrevQ = %b, Q = %b", $time, T, sel, PrevQ, TBForce.Q);
        case (t)
            1'd0: Checkif(TBForce.Q != PrevQ);
            1'd1: Checkif(TBForce.Q == PrevQ);
            default: $display("No Values forced");
        endcase
    endtask: TestValues

    task Checkif;
        input ErrCondition;
        if(ErrCondition)
            $display(" is not working");
        else
            $display(" is working");
    endtask: Checkif

    modport TB_ports(clocking TBForce, task TestRst, task TestValues);
endinterface: T_TB

module TFF(T_TB.TFF_ports T_IF);
    logic t;
    always_comb
        t = T_IF.sel?(T_IF.T[1]):(T_IF.T[0]);
    always_ff @(posedge T_IF.clk)
    begin
        if (T_IF.rst)
            T_IF.Q <= 0;
        else
            case(t)
                1'd0: T_IF.Q <= T_IF.Q;
                1'd1: T_IF.Q <= ~T_IF.Q;
            endcase
    end
endmodule: TFF

module TTestCases(T_TB.TB_ports TB_IF);
    initial 
    begin
        @(TB_IF.TBForce);
        TB_IF.TestRst;
        for (int T=0; T<4; T++)
            for(int sel=0; sel<2; sel++)
                TB_IF.TestValues(T, sel);
    end
endmodule: TTestCases

module Top();
    bit clk;
    always #10 clk = ~clk;
    T_TB  bus (clk);
    TFF DUV (bus);
    TTestCases TB (bus);
endmodule: Top
