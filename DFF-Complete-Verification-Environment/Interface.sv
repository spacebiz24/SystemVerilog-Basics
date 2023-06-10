`timescale 1ns / 1ps

interface DUT_interface(input clk);
    logic [1:0]D;
    logic sel;
    logic Q;
    logic rst;
    
    modport DUT(input D, sel, rst, clk, output Q);
    
    clocking driver_clocking @(posedge clk);
        output D, sel;
        output rst;
    endclocking
    
    clocking monitor_clocking @(posedge clk);
        input Q;
        input D, sel;
        input rst;
    endclocking
endinterface
