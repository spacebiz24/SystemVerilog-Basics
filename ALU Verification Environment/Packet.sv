class packet;
    randc bit [16]Operand1, Operand2;
    randc bit [4]OpCode;
    bit [32]Result;
  	constraint OpCon{OpCode < 9;}
endclass
