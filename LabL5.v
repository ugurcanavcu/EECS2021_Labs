module labL;
reg a, b, cin;
reg [1:0] sum;
wire z, cout;
integer i, j, k;

yAdder1 myAdder(z, cout, a, b, cin);


initial
begin
for (i = 0; i < 2; i = i + 1)
begin
    for (j = 0; j < 2; j = j + 1)
    begin
        for(k = 0; k < 2; k = k + 1)
        begin
        a = i; b = j; cin = k;
        sum = a + b + cin;
        #1; // wait for z
        if (sum[0] === z || sum[1] === cout)
          $display("a=%b b=%b cin=%b z=%b cout=%b", a, b, cin, z, cout);
        end
    end
end
$finish;
end

endmodule
