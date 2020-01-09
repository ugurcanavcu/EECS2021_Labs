
module labM;
reg clk, read, write;
reg [31:0] address, memIn;
wire [31:0] memOut;
mem data(memOut, address, memIn, clk, read, write);
initial
begin
  		 address = 128; write = 0; read = 0;
		 clk = 0;
   		repeat   (11)
		begin
			#4 read = 1;
			if (memOut[31:26] == 0)
   				#4 $display("%0d %0d %0d %0d  %0d", memOut[31:26], memOut[25:21], memOut[20:16], memOut[15:11], memOut[5:0]);
			if (memOut[31:26] == 2)
				#4 $display("%0d %0d", memOut[31:26], memOut[25:0]);
			else
				#4 $display("%0d %0d %0d %0d  %0d", memOut[31:26], memOut[25:21], memOut[20:16], memOut[15:11], memOut[5:0]);

			address = address + 4;

   		end
		$finish;
end
always
begin
		#4 clk = ~clk;
end
endmodule 
