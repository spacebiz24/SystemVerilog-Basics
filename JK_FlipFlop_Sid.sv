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

interface JK_FlipFlop_Interface(input clk);
    logic [1:0]J, K, Sel;
    logic rst, Q;
    modport DUT (input J, K, Sel, rst, clk, output Q);
    parameter tHold = 2, tSetup = 4;
    clocking cb @ (posedge clk);
        default input #(tSetup) output #(tHold);
        output J, K, Sel;
        output rst;
        input Q;
    endclocking

    task errorMessage;
        input Condition, Type;
        $display("%d for %d condition failed\n", Condition, Type);
        $stop;
    endtask

    task successMessage;
        input string message;
        $display("%s working\n", message);
    endtask

    task testReset;
        cb.rst <= 1;
        cb.Sel <= $random;
        cb.J <= 'd2;
        cb.K <= 'd3;
        repeat(2) @(cb);
        if(cb.Q != 0)
        begin
            $display("Reset Not Working\n");
            $stop;
        end
        else
            successMessage("Reset");
    endtask

    task test0_JK;
        input J0, K0;
        parameter Type = 0;
        cb.J[Type] <= J0;
        cb.K[Type] <= K0;
        cb.Sel <= Type;
        repeat(2) @ (cb);
        case({J0, K0})
            00: if(cb.Q != cb.Q) errorMessage(0, Type);
            01: if(cb.Q != 0) errorMessage(1, Type);
            10: if(cb.Q != 1) errorMessage(2, Type);
            11: if(cb.Q == cb.Q) errorMessage(3, Type);
            default: successMessage("Load 0");
        endcase
    endtask
    
    task test1_JK;
        input J1, K1;
        parameter Type = 1;
        cb.J[Type] <= J1;
        cb.K[Type] <= K1;
        cb.Sel <= Type;
        repeat(2) @ (cb);
        case({J1, K1})
            00: if(cb.Q != cb.Q) errorMessage(0, Type);
            01: if(cb.Q != 0) errorMessage(1, Type);
            10: if(cb.Q != 1) errorMessage(2, Type);
            11: if(cb.Q == cb.Q) errorMessage(3, Type);
            default: successMessage("Load 1");
        endcase
    endtask
    modport Test_IF (clocking cb, task testReset(), task test0_JK(), task test1_JK());
endinterface

module JK_FlipFlop(JK_FlipFlop_Interface.DUT dutIF);
    logic J, K;
    always @ (*)
    begin
        case(dutIF.Sel[0])
            0: J = dutIF.J[0];
            1: J = dutIF.J[1];
            default: J = dutIF.J[0];
        endcase
        case(dutIF.Sel[1])
            0: K = dutIF.K[1];
            1: K = dutIF.K[1];
            default: K = dutIF.K[0];
        endcase
    end
    always_ff @(dutIF.clk)
    begin
        if(dutIF.rst)
            dutIF.Q <= 0;
        else
        begin
            case({J, K})
                00: dutIF.Q <= dutIF.Q;
                01: dutIF.Q <= 0;
                10: dutIF.Q <= 1;
                11: dutIF.Q <= ~dutIF.Q;
            endcase
        end
    end
endmodule

module JK_FlipFlop_Testcase(JK_FlipFlop_Interface.Test_IF testIF);
    initial
    begin
        @(testIF.cb);
        testIF.testReset;
        testIF.test0_JK(0, 0);
        testIF.test0_JK(0, 1);
        testIF.test0_JK(1, 0);
        testIF.test0_JK(1, 1);
        testIF.test1_JK(0, 0);
        testIF.test1_JK(0, 1);
        testIF.test1_JK(1, 0);
        testIF.test1_JK(1, 1);
        #20 $finish;
    end
endmodule

module JK_FlipFlop_Top_Level();
    bit clk;
    always #10 clk = ~clk;
    JK_FlipFlop_Interface bus(clk);
    JK_FlipFlop DUV(bus);
    JK_FlipFlop_Testcase TB(bus);
endmodule
