module L;
reg [31:0] a, b, expect;
reg cin;
reg ok;
wire [31:0] z;
wire cout;

yAdder mine(z, cout, a, b, cin);

initial
begin
    repeat (10)
	begin
	a = $random;
	b = $random;
	cin = 0;
	#1;
	expect = a + b + cin;
	ok = 0;
	if (expect === z)
	      ok = 1;
              #2 $display("PASS: time=%1d ok=%d a=%b b=%b cin=%b z=%b cout=%b", $time, ok, a, b, cin, z, cout);
	end
$finish;

end

endmodule
