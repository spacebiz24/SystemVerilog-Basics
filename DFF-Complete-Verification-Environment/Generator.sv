class generator;
    rand packet pkt_to_driver; // why rand?
    mailbox generator_mailbox; // local instance of mailbox
    
    function new(mailbox glue_mailbox);
        generator_mailbox = glue_mailbox;
    endfunction
    
    int total_packets, packet_count;
    event generation_ended;
    
    task dispatch;
        repeat(total_packets - 1) // 1 for testing reset
        begin
            pkt_to_driver = new;
            pkt_to_driver.randomize();
            generator_mailbox.put(pkt_to_driver);
            
            $display("Generator passed");
            $display("%0t: D = %b, sel = %b, packet count = %d", $time, pkt_to_driver.D, pkt_to_driver.sel, packet_count);
            packet_count++;
        end
        -> generation_ended;
    endtask
endclass
