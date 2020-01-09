module L;
reg [1:0] a, b, c, expect;
integer i, j, k;
output [1:0] z;
yMux1 mine[1:0](z, a, b, c);

initial
begin
    for (i = 0; i < 4; i = i + 1)
    begin
        for (j = 0; j < 4; j = j + 1)
        begin
            for(k = 0; k < 2; k = k + 1)
            begin
            a = i; b = j; c = k;
            expect = (a & ~c) | (b & c);
            #1; // wait for z
            if (expect === z)
              $display("PASS: a=%b b=%b c=%b z=%b", a, b, c, z);
            else
              $display("FAIL: a=%b b=%b c=%b z=%b", a, b, c, z);
            end
        end
    end
    $finish;
end

endmodule
