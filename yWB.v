module yWB(wb, exeOut, memOut, Mem2Reg);
output [31:0] wb;
input [31:0] exeOut, memOut;
input Mem2Reg;
// instantiate the circuit (only one line)
yMux #(32) WB(wb, exeOut, memOut, Mem2Reg);
endmodule 
