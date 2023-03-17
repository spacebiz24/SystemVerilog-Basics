interface JK_TB(clk);
    input clk;
    logic J, K;
    logic rst, Q;
    
    modport JKFF_ports(input J, K, rst, clk, output Q);
    
    
    parameter tsetup = 4, thold = 2;
    
    clocking TBForce @(posedge clk);
        default input #(tsetup) output #(thold);
        input Q;
        output J, K, rst;
    endclocking
    
    task TestRst;
        TBForce.rst <= 1;
        
        repeat (2) @ (TBForce); // Delay of 2 clock cycles
        if (TBForce.Q)
        begin
            $display("Reset is not Working\n");
            $stop;
        end
        else
            $display("Reset is working\n");
        
        TBForce.rst <= 0;
    endtask
    
    task TestValues;
        input J, K;
        TBForce.J <= J;
        TBForce.K <= K;
        repeat(2) @(TBForce);
        case ({J,K})
            2'd0: if(TBForce.Q != TBForce.Q) Message(J, K, 1); else Message(J, K, 0);
            2'd1: if(TBForce.Q != 0) Message(J, K, 1); else Message(J, K, 0);
            2'd2: if(TBForce.Q != 1) Message(J, K, 1); else Message(J, K, 0);
            2'd3: if(TBForce.Q == TBForce.Q) Message(J, K, 1); else Message(J, K, 0);
        endcase
    endtask
    
    task Message;
        input j,k;
        input errcode;
        if (errcode)
        begin
            $display("J = %d, K = %d is Not working\n", j, k);
        end
        else
            $display("J = %d, K = %d is working\n", j, k);
    endtask

modport TB_ports(clocking TBForce, task TestRst, task TestValues);
endinterface

module JKFF(JK_TB.JKFF_ports JK_IF);
    logic J,K;
    always @*
    begin
        J = JK_IF.J;
        K = JK_IF.K;
    end
    always_ff @(JK_IF.clk)
    begin
        if (JK_IF.rst)
            JK_IF.Q <= 0;
        else
            case ({J,K})
                00: JK_IF.Q <= JK_IF.Q;
                01: JK_IF.Q <= 'b0;
                10: JK_IF.Q <= 'b1;
                11: JK_IF.Q <= ~JK_IF.Q;
            endcase
    end
endmodule

module JKTestCases(JK_TB.TB_ports TB_IF);
int j,k;
initial
    begin
        @(TB_IF.TBForce);
        TB_IF.TestRst;
        TB_IF.TestValues(1,0);
    end
endmodule

module Top();
    bit clk;
    always #10 clk = ~clk;
    JK_TB bus(clk);
    JKFF DUV (bus);
    JKTestCases TB(bus);
endmodule
