interface JK_TB (clk);
    input clk;
    logic J, K, rst;
    logic Q;

    modport JKFF_ports(input J, K, rst, clk, output Q);


    parameter tsetup = 2, thold = 3;
    clocking TBForce @(posedge clk);
        default input #(tsetup) output #(thold);
        output J, K, rst;
        input Q;
    endclocking: TBForce

    task TestRst;
        TBForce.rst <= 1;
        repeat (2) @(TBForce);
            if (TBForce.Q)
            begin
                $display("Reset is not working");
                $stop;
            end
            else
                $display("Reset is working");
        TBForce.rst <= 0; 
    endtask: TestRst

    task TestValues;
        input J, K;
        reg PrevQ = TBForce.Q;
        TBForce.J <= J;
        TBForce.K <= K;
        repeat (2) @(TBForce);
        case ({J,K})
            2'd0: if (TBForce.Q != PrevQ) Message(J, K, 1); else Message(J, K, 0);
            2'd1: if (TBForce.Q != 0) Message(J, K, 1); else Message(J, K, 0);
            2'd2: if (TBForce.Q != 1) Message(J, K, 1); else Message(J, K, 0);
            2'd3: if (TBForce.Q == PrevQ) Message(J, K, 1); else Message(J, K, 0);
        endcase
    endtask: TestValues

    task Message;
        input J, K;
        input errcode;
        $write("J = %b, K = %b is ", J, K);
        if(errcode)
            $display("Not working");
        else
            $display("Working");
    endtask: Message

    modport TB_ports(clocking TBForce, task TestRst, task TestValues);
endinterface: JK_TB

module JKFF(JK_TB.JKFF_ports JK_IF);
    always_ff @(posedge JK_IF.clk)
    begin
        if (JK_IF.rst)
            JK_IF.Q <= 0;
        else
            case({JK_IF.J, JK_IF.K})
                2'd0: JK_IF.Q <= JK_IF.Q;
                2'd1: JK_IF.Q <= 1'b0;
                2'd2: JK_IF.Q <= 1'b1;
                2'd3: JK_IF.Q <= ~JK_IF.Q;
            endcase
    end
endmodule: JKFF

module JKTestCases(JK_TB.TB_ports TB_IF);
    initial 
    begin
        @(TB_IF.TBForce);
        TB_IF.TestRst;
        for (int J=0; J<2; J++)
            for (int K=0; K<2; K++)
                TB_IF.TestValues(J, K);
    end
endmodule: JKTestCases

module Top();
    bit clk;
    always #10 clk = ~clk;
    JK_TB  bus (clk);
    JKFF DUV (bus);
    JKTestCases TB (bus);
endmodule: Top
