module LabM;
reg [31:0]wd;
reg [4:0] rn1, rn2, wn;
wire [31:0] rd1, rd2;
reg clk, w;
integer flag, i;
rf myRF(rd1, rd2, rn1, rn2, wn, wd, clk, w);
initial
begin
	flag = $value$plusargs("w=%b", w);
	for(i =0; i<32; i = i+1)
	begin
		clk = 0;
		wd  = i*i;
		wn = i;
		clk = 1;
		#1;
	end

end
initial
repeat(10)
begin
	rn1 = $random%32;
	rn2 = $random%32;
	#5 $display(" rn1 ==> %0d\n rn2 ==> %0d\n rd1 ==> %0d\n rd2 ==> %0d\n", rn1, rn2, rd1, rd2);
end
endmodule
