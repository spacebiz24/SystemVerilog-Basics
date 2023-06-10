`include "environment.sv"

program test(DUT_interface vintrf);
    environment env;
    
    initial
    begin
        env = new(vintrf);
        env.gen.total_packets = 10;
        env.run;
    end
endprogram
