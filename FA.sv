module HA(A, B, Sum, Cout);
    input A, B;
    output Sum, Cout;

    assign Sum = A ^ B;
    assign Cout = A & B;
endmodule

module FA(A, B, Cin, Sum, Cout);
    input A, B, Cin;
    output Sum, Cout;
    
    wire tempCout1,tempCout2, tempSum;

    HA ha [1:0](.A({Cin, A}), .B({tempSum, B}), .Sum({Sum, tempSum}), .Cout({tempCout2, tempCout1}));
    or (Cout, tempCout1, tempCout2);
endmodule
