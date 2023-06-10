`define driver_clocking driver_interface.driver_clocking

class driver;
    mailbox driver_mailbox;
    
    virtual DUT_interface driver_interface;
    
    function new(mailbox glue_mailbox, virtual DUT_interface glue_interface);
        driver_mailbox = glue_mailbox;
        driver_interface = glue_interface;
    endfunction
    
    int signals_driven;
    task drive;
        test_reset;
        forever
        begin
            packet pkt_from_generator;
            driver_mailbox.get(pkt_from_generator);
            
            @(`driver_clocking);
            `driver_clocking.D <= pkt_from_generator.D; // write driver
            `driver_clocking.sel <= pkt_from_generator.sel; // write driver
            
            $display("Driver passed");
            $display("%0t: D = %b, sel = %b, signals driven = %d", $time, pkt_from_generator.D, pkt_from_generator.sel, signals_driven);
            signals_driven++;
            
            repeat(2) @(`driver_clocking); // DUT waits for 2 cycles to refelect
        end
    endtask
    
    task test_reset;
        @(`driver_clocking);
        `driver_clocking.D <= 2'b00;
        `driver_clocking.rst <= 1;
        
        $display("Driver asserting reset");
        signals_driven++;
        
        repeat(2) @(`driver_clocking);
        `driver_clocking.rst <= 0;
    endtask
endclass
