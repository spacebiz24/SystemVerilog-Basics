`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.06.2023 14:28:50
// Design Name: 
// Module Name: top
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


// `include "interface.sv"
// `include "test.sv"

module TestBench_Top;
    bit clk = 1;
    
    initial
    begin
        $monitor("%0t: clk = %b", $time, clk);
        forever #20 clk = ~clk;
    end
    
    DUT_interface intrf(clk);
    test tst(intrf);
    DFF DUT(intrf.DUT);
endmodule
