module labM;
reg [31:0] PCin;
reg RegDst, RegWrite, clk, ALUSrc, Mem2Reg, MemWrite, MemRead;
reg [2:0] op;
wire [31:0] wd, rd1, rd2, imm, ins, PCp4, z;
wire [25:0] jTarget;
wire zero;
yIF myIF(ins, PCp4, PCin, clk);
yID myID(rd1, rd2, imm, jTarget, ins, wd, RegDst, RegWrite, clk);
yEX myEx(z, zero, rd1, rd2, imm, op, ALUSrc);
yDM myDM(memOut, z, rd2, clk, MemRead, MemWrite);
yWB myWB(wb, z, memOut, Mem2Reg);
assign wd = wb;
initial
begin
   //------------------------------------Entry   point
   PCin = 128;
   //------------------------------------Run   program
   repeat   (11)
   begin
      //---------------------------------Fetch   an   ins
	clk = 1; #1;
      //---------------------------------Set   control   signals
	op = 3'b010;
	if(ins[31:26] ==0)
	begin
 		RegDst = 1;
		RegWrite = 1;
		ALUSrc = 0;
		Mem2Reg = 0;
		MemRead = 0;
		MemWrite = 0;
		if (ins[5:0] == 6'h24) op = 3'b000;			//and
		else if (ins[5:0] == 6'h25) op = 3'b001;	//or
		else if (ins[5:0] == 6'h20) op = 3'b010;	//add
		else if (ins[5:0] == 6'h22) op = 3'b110;	//sub
		else if (ins[5:0] == 6'h2a) op = 3'b111;	//slt
      	end
	else if(ins[31:26] == 2)
	begin
		RegDst = 0;
		RegWrite = 0;
		ALUSrc = 1;
		Mem2Reg = 0;
		MemRead = 0;
		MemWrite = 0;
	end
	else if (ins[31:26] == 6'h4)	//beq
	begin
		RegDst = 0;
		RegWrite = 0;
		ALUSrc = 0;
		Mem2Reg = 0;
		MemRead = 0;
		MemWrite = 0;
	end
	else
	begin
			if (ins[31:26] == 6'h8)			//addi
			begin
				RegDst = 0;
				RegWrite = 1;
				ALUSrc = 1;
				MemRead = 0;
				MemWrite = 0;
				Mem2Reg = 0;
			end
			else if (ins[31:26] == 6'h23)	//lw
			begin
				RegDst = 0;
				RegWrite = 1;
				ALUSrc = 1;
				MemRead = 1;
				MemWrite = 0;
				Mem2Reg = 1;
			end
			else if (ins[31:26] == 6'h2b)	//sw
			begin
				RegDst = 0;
				RegWrite = 0;
				ALUSrc = 1;
				MemRead = 0;
				MemWrite = 1;
				Mem2Reg = 0;
			end
			else if (ins[31:26] == 6'h4)	//beq
			begin
				RegDst = 0;
				RegWrite = 0;
				ALUSrc = 0;
				MemRead = 0;
				MemWrite = 0;
				Mem2Reg = 0;
			end
	end

      //---------------------------------Execute   the   ins
	clk = 0; #1;
      //---------------------------------View   results
	#2;
  	$display("%h: rd1=%2d rd2=%2d z=%3d zero=%b wb=%2d",  ins, rd1, rd2, z, zero, wb);

      //---------------------------------Prepare for the next ins
	#1;
	PCin   =   PCp4;
   end
   $finish;
end
endmodule 
