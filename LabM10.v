module labM;
reg [31:0] PCin;
reg RegDst, RegWrite, clk, ALUSrc, MemRead, MemWrite, Mem2Reg;
reg [2:0] op;

wire [31:0] wd, rd1, rd2, imm, ins, PCp4, z, memOut, wb;
wire [25:0] jTarget;
wire zero;

//Get pointer
yIF myIF(ins, PCp4, PCin, clk);

//Get instruction
//{
//	RegDst: write to a location, 0-IJ, 1-R;
//	RegWrite: 0-disable register, 1-will be able to store date in register
//}
yID myID(rd1, rd2, imm, jTarget, ins, wd, RegDst, RegWrite, clk);

//Execute instruction
//{
//	ALUSrc:	0-not imm, 1-imm;
//	op:		do the calculation
//}
yEX myEX(z, zero, rd1, rd2, imm, op, ALUSrc);

//Data Memory
//{MemRead, MemWrite}
yDM myDM(memOut, z, rd2, clk, MemRead, MemWrite);

//Write Back: from Memory to Register
//{Mem2Reg}
yWB myWB(wb, z, memOut, Mem2Reg);
assign wd = wb;

initial
begin
	PCin = 32'h80;
	repeat(43)
	begin
		//Fetch an instruction
		#1;
		clk = 1'b1;

		//Set Control Signals
		#1;
		op = 3'b010;

		/*
			R:
				and, or, add, sub, slt
			J:
				j
			I:
				addi, lw, sw, beq
		*/

		if (ins[31:26] == 0)
		begin
			//R-type
			RegDst = 1; 	//has rd field
			RegWrite = 1;	//need to write to a register
			ALUSrc = 0;		//0 - do calculation; 1 - add immediate
			MemRead = 0;	//read from memory
			MemWrite = 0;	//write to memory
			Mem2Reg = 0;	//from memory to register
			if (ins[5:0] == 6'h24) op = 3'b000;			//and
			else if (ins[5:0] == 6'h25) op = 3'b001;	//or
			else if (ins[5:0] == 6'h20) op = 3'b010;	//add
			else if (ins[5:0] == 6'h22) op = 3'b110;	//sub
			else if (ins[5:0] == 6'h2a) op = 3'b111;	//slt
		end
		else if(ins[31:26] == 2)
		begin
			//J-type
			RegDst = 0;
			RegWrite = 0;
			ALUSrc = 1;
			MemRead = 0;
			MemWrite = 0;
			Mem2Reg = 0;
		end
		else
		begin
			//I-type
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


		//Execute this insturction
		#1;
		clk = 1'b0;

		//View Results
		#1;
		$display("[0x%h-0x%h]rd1=%d rd2=%d imm=%h jTarget=%h z=%d zero=%h, wb=", PCin, ins, rd1, rd2, imm, jTarget, z, zero, wb);

		//Next
		#1;
		//PCin = PCp4;
		if ((ins[31:26] == 6'h4) && (zero == 1))	//if equal
		begin
			PCin = PCp4 + imm * 4;
		end
		else if (ins[31:26] == 2)					//if "j"
		begin
			PCin = jTarget * 4;
		end
		else										//else normal
		begin
			PCin = PCp4;
		end
	end
end
endmodule
