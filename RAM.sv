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

interface RAM_IF(clk);
    input bit clk;

    logic [64]data_in;
    logic [64]data_out;
    logic [12]rd_address;
    logic [12]wr_address;
    logic read, write;

    // Write BFM clocking block
    clocking wr_cb @(posedge clk)
        default input#1 output #1;
        output wr_address, data_in, write;
    endclocking: wr_cb

    // Read BFM clocking block
    clocking rd_cb @(posedge clk)
        default input#1 output #1;
        output rd_address, read;
    endclocking: rd_cb

    // Write monitor clocking block
    clocking wr_mon_cb @(posedge clk)
        default input#1 output #1;
        input wr_address, data_in, write;
    endclocking: wr_mon_cb

    // Read monitor clocking block
    clocking rd_mon_cb @(posedge clk)
        default input#1 output #1;
        input rd_address, data_out,read;
    endclocking: rd_mon_cb

    // Write BFM Modport
    modport WR_BFM(clocking wr_cb);
    // Read BFM Modport
    modport RD_BFM(clocking rd_cb);

    // Write Monitor Modport
    modport WR_MON(clocking wr_mon_cb);
    // Read Monitor Modport
    modport RD_MON(clocking rd_mon_cb);
endinterface: RAM_IF
