class scoreboard;
    mailbox scoreboard_mailbox;
    
    function new(mailbox glue_mailbox);
        scoreboard_mailbox = glue_mailbox;
    endfunction
    
    int unsigned expected_Result;
    int packets_evaluated;
  enum {ADD, SUB, MUL, LSR, LSL, NOT, AND, ORR, XOR} OpCodes;
    task evaluate;
        forever
        begin
            packet pkt_from_monitor;
            scoreboard_mailbox.get(pkt_from_monitor);
          	case(pkt_from_monitor.OpCode)
          		OpCodes[ADD]: expected_Result = pkt_from_monitor.Operand1 + pkt_from_monitor.Operand2;
         		  OpCodes[SUB]: expected_Result = pkt_from_monitor.Operand1 - pkt_from_monitor.Operand2;
          		OpCodes[MUL]: expected_Result = pkt_from_monitor.Operand1 * pkt_from_monitor.Operand2;
          		OpCodes[LSR]: expected_Result = pkt_from_monitor.Operand1 >> pkt_from_monitor.Operand2;
	          	OpCodes[LSL]: expected_Result = pkt_from_monitor.Operand1 << pkt_from_monitor.Operand2;
          		OpCodes[NOT]: expected_Result = ~ pkt_from_monitor.Operand1;
          		OpCodes[AND]: expected_Result = pkt_from_monitor.Operand1 & pkt_from_monitor.Operand2;
          		OpCodes[ORR]: expected_Result = pkt_from_monitor.Operand1 | pkt_from_monitor.Operand2;
          		OpCodes[XOR]: expected_Result = pkt_from_monitor.Operand1 ^ pkt_from_monitor.Operand2;
			      endcase
          	if(expected_Result == pkt_from_monitor.Result)
            	$display("DUT Working as expected");
          	else
            	$display("DUT NOT Working as expected");
            $display("Scoreboard Evaluated, packet no. %d\n", packets_evaluated);
            packets_evaluated++;
        end
    endtask
endclass
