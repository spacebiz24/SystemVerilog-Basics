class scoreboard;
    mailbox scoreboard_mailbox;
    
    function new(mailbox glue_mailbox);
        scoreboard_mailbox = glue_mailbox;
    endfunction
    
    int packets_evaluated;
    task evaluate;
        forever
        begin
            packet pkt_from_monitor;
            scoreboard_mailbox.get(pkt_from_monitor);
            
            $display("Scoreboard Received");
            $display("%0t: D = %b, sel = %b, Q = %d, packets evaluated = %d", $time, pkt_from_monitor.D, pkt_from_monitor.sel, pkt_from_monitor.Q, packets_evaluated);
            
            if((pkt_from_monitor.rst == 1) & (pkt_from_monitor.Q != 0))
                $display("Failed rst");
            else if ((pkt_from_monitor.rst == 0) & (pkt_from_monitor.Q != pkt_from_monitor.D[pkt_from_monitor.sel]))
                $display("Failed to implement");
            else
                $display("DUT performed well");
            
            packets_evaluated++;
        end
    endtask
endclass
