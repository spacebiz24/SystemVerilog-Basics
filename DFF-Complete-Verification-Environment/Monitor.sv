`define monitor_clocking monitor_interface.monitor_clocking

class monitor;
    mailbox monitor_mailbox;
    
    virtual DUT_interface monitor_interface;
    
    function new(mailbox glue_mailbox, virtual DUT_interface glue_interface);
        monitor_mailbox = glue_mailbox;
        monitor_interface = glue_interface;
    endfunction
    
    int signals_received;
    task watch;
        forever 
        begin
            packet pkt_to_scoreboard = new;
            
            repeat(3) @(`monitor_clocking); // 1 cycle(Driver time) + 2 cycles(DUT delay)
            pkt_to_scoreboard.D = `monitor_clocking.D; // write monitor
            pkt_to_scoreboard.sel = `monitor_clocking.sel; // write monitor
            pkt_to_scoreboard.Q = `monitor_clocking.Q; // read monitor
            monitor_mailbox.put(pkt_to_scoreboard);
            
            $display("Monitor Received");
            $display("%0t: D = %b, sel = %b, Q = %d, signals received = %d", $time, pkt_to_scoreboard.D, pkt_to_scoreboard.sel, pkt_to_scoreboard.Q, signals_received);
            signals_received++;
        end
    endtask
endclass
