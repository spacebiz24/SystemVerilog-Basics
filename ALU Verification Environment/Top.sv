`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Qualcomm
// Engineer: Ranga Man
// Salary: 45 LPA
// 
// Create Date: 08.06.2023 14:28:50
// Design Name: 
// Module Name: Top
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

// Uncomment below if, running on EDA Playground
// `include "interface.sv"
// `include "test.sv"

module TestBench_Top;
    DUT_interface intrf();
    test tst(intrf);
  	ALU DUT(.Operand1(intrf.Operand1), .Operand2(intrf.Operand2), .OpCode(intrf.OpCode), .Result(intrf.Result));
  initial
    begin
      $dumpfile("trace.vcd");
      $dumpvars;
    end
endmodule
