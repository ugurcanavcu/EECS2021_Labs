module L;
reg [31:0] a0, a1, a2, a3, expect;
reg [1:0] c;
output [31:0] z;

yMux4to1 #(.SIZE(32)) my_mux(z, a0, a1, a2, a3, c);

initial
begin
    repeat (10)
begin
a0 = $random;
a1 = $random;
a2 = $random;
a3 = $random;
c = $random % 4;
#1;

	if(c === 0)
		expect = a0;
	else if(c === 1)
		expect = a1;
	else if(c === 2)
		expect = a2;
	else
		expect = a3;

	if (expect === z)
              #2 $display("PASS: time=%1d a0=%b a1=%b a2=%b a3=%b c=%b z=%b", $time, a0, a1, a2, a3, c, z);
        else
              #2 $display("FAIL: time=%1d a0=%b a1=%b a2=%b a3=%b c=%b z=%b", $time, a0, a1, a2, a3, c, z);
end
$finish;

end

endmodule
