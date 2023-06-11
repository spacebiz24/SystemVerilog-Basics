`timescale 1ns / 1ps // change to 10n

module DFF(DUT_interface.DUT DFF_interface);
    logic D;
    
    assign D = DFF_interface.sel?(DFF_interface.D[1]):(DFF_interface.D[0]);
    
    always_ff @(posedge DFF_interface.clk)
    begin
        if(DFF_interface.rst)
            DFF_interface.Q <= 'b0;
        else
            DFF_interface.Q <= D;
    end
endmodule
