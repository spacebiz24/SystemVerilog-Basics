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
interface T_TB (clk);
    input clk;
    logic T, rst;
    logic Q;

    modport TFF_ports(input T, rst, clk, output Q);


    parameter tsetup = 2, thold = 3;
    clocking TBForce @(posedge clk);
        default input #(tsetup) output #(thold);
        output T, rst;
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
        input T;
        static reg PrevQ = TBForce.Q;
        TBForce.T <= T;
        repeat (2) @(TBForce);
        $write("%1t: T = %b --> PrevQ = %b, Q = %b", $time, T, PrevQ, TBForce.Q); 
        case (T)
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
    endtask: Message

    modport TB_ports(clocking TBForce, task TestRst, task TestValues);
endinterface: T_TB

module TFF(T_TB.TFF_ports T_IF);
    always_ff @(posedge T_IF.clk)
    begin
        if (T_IF.rst)
            T_IF.Q <= 0;
        else
            case(T_IF.T)
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
        for (int T=0; T<2; T++)
            TB_IF.TestValues(T);
    end
endmodule: TTestCases

module Top();
    bit clk;
    always #10 clk = ~clk;
    T_TB  bus (clk);
    TFF DUV (bus);
    TTestCases TB (bus);
endmodule: Top
