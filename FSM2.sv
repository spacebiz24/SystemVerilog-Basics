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


module FSM(w, z, rst, clk);
    input logic w, rst, clk;
    output logic z;

    typedef enum {S0, S1, S2, S3} states;

    states state, next_state;

    always_ff @(posedge clk)
    begin
        if(rst) state <= S0;
        else state <= next_state;
    end

    assign z = (state == S0);

    always_comb
        case(state)
            S0: next_state = w?(S1):(S3);
            S1: next_state = w?(S2):(S0);
            S2: next_state = w?(S3):(S1);
            S3: next_state = w?(S0):(S2);
        endcase
endmodule
