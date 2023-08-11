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
            packet pkt_to_scoreboard = new();
          
            #7;
            pkt_to_scoreboard.Operand1 = monitor_interface.Operand1; // write monitor
            pkt_to_scoreboard.Operand2 = monitor_interface.Operand2;
            pkt_to_scoreboard.OpCode = monitor_interface.OpCode; 
            pkt_to_scoreboard.Result = monitor_interface.Result; // read monitor
            monitor_mailbox.put(pkt_to_scoreboard);
            
            $display("Monitor Received");
          	$display("%t: Operand1 = %d, Operand2 = %d, OpCode = %d, Result = %d, signals received = %d", $time, pkt_to_scoreboard.Operand1, pkt_to_scoreboard.Operand2, pkt_to_scoreboard.OpCode, pkt_to_scoreboard.Result, signals_received);
            signals_received++;
        end
    endtask
endclass
