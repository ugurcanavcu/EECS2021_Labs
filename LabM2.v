module labM;
reg signed[31:0] d;
reg clk, enable;
wire signed[31:0] z;
register #(32) mine(z, d, clk, enable);
initial
begin
	enable =1;
	clk = 1;
	repeat(20)
	begin
		#2 d = $random%100;
	end
	$finish;
end
///////////////////
always
begin
 		#5 clk = ~clk;
end
///////////////////
////////////
initial
begin
 		$monitor("%5d: clk=%b,d=%d,z=%d,enable=%d", $time,clk,d,z,enable);
end
//////////////////
endmodule 
