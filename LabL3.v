module L;
reg [31:0] a, b, expect;
reg c;
output [31:0] z;
yMux #(.SIZE(32)) my_mux(z, a, b, c);

initial
begin
    repeat (10)
begin
a = $random;
b = $random;
c = $random % 2;
#1;

	if(c === 0)
		expect = a;
	else
		expect = b;
	if (expect === z)
              #5 $display("PASS: time=%1d a=%b b=%b c=%b z=%b", $time, a, b, c, z);
        else
              #10 $display("FAIL: time=%1d a=%b b=%b c=%b z=%b", $time, a, b, c, z);
end
$finish;

end

endmodule
