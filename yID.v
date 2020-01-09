module yID(rd1, rd2, imm, jTarget, ins, wd, RegDst, RegWrite, clk);
output [31:0] rd1, rd2, imm;         // rs and rt and immediate
output [25:0] jTarget; 		     // jump
input [31:0] ins, wd; 		     // wd = value need to be written on rd and ins is instruction where rd id ins[20:16] or ins[15:11]
input RegDst, RegWrite, clk; 	     // regDst decide type of ins and regWrite allow to write and clk is clock
wire [4:0] rn1, rn2, rn3, wn;
assign rn1 = ins[25:21];
assign rn2 = ins[20:16];
assign rn3 = ins[15:11];
assign jTarget = ins[25:0];
assign imm[15:0] = ins[15:0];
yMux #(32) myMux(wn, rn2, rn3, RegDst);
rf 	   myRf(rd1, rd2, rn1, rn2, wn, wd, clk, RegWrite);
yMux #(16) se(imm[31:16], 16'b0, 16'hffff, ins[15]);
endmodule 
