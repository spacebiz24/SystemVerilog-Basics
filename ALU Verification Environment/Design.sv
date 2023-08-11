module ALU(Operand1, Operand2, OpCode, Result);
	input logic[16]Operand1, Operand2;
  	input logic[4]OpCode;
	output logic[32]Result;
  enum {ADD, SUB, MUL, LSR, LSL, NOT, AND, ORR, XOR} OpCodes;
	always_comb
		case(OpCode)
          OpCodes[ADD]: Result = Operand1 + Operand2;
          OpCodes[SUB]: Result = Operand1 - Operand2;
          OpCodes[MUL]: Result = Operand1 * Operand2;
          OpCodes[LSR]: Result = Operand1 >> Operand2;
          OpCodes[LSL]: Result = Operand1 << Operand2;
          OpCodes[NOT]: Result = ~ Operand1;
          OpCodes[AND]: Result = Operand1 & Operand2;
          OpCodes[ORR]: Result = Operand1 | Operand2;
          OpCodes[XOR]: Result = Operand1 ^ Operand2;
		endcase
endmodule
