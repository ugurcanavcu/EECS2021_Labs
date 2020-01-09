module yDM(memOut, exeOut, rd2, clk, MemRead, MemWrite);
output [31:0] memOut;
input [31:0] exeOut, rd2;
input clk, MemRead, MemWrite;
// instantiate the circuit (only one line)
mem DM(memOut, exeOut, rd2, clk, MemRead, MemWrite);
endmodule 
