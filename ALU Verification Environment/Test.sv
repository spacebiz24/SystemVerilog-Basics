`include "Environment.sv"

program test(DUT_interface vintrf);
    initial
    begin
        environment env = new(vintrf);
        env.gen.total_packets = 10;
        env.run;
    end
endprogram
