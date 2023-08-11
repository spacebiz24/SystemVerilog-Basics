class driver;
    mailbox driver_mailbox;
    
    virtual DUT_interface driver_interface;
    
    function new(mailbox glue_mailbox, virtual DUT_interface glue_interface);
        driver_mailbox = glue_mailbox;
        driver_interface = glue_interface;
    endfunction
    
    int signals_driven;
    task drive;
        forever
        begin
            packet pkt_from_generator;
            driver_mailbox.get(pkt_from_generator);
          
            #5;
            driver_interface.Operand1 <= pkt_from_generator.Operand1;
            driver_interface.Operand2 <= pkt_from_generator.Operand2;
            driver_interface.OpCode <= pkt_from_generator.OpCode;
            
            $display("Driver passed");
          	$display("%t: Operand1 = %d, Operand2 = %d, OpCode = %d, signals driven = %d", $time, pkt_from_generator.Operand1, pkt_from_generator.Operand2, pkt_from_generator.OpCode, signals_driven);
            signals_driven++;
        end
    endtask
endclass
