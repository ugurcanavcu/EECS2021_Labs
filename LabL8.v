module LabL;

reg signed [31:0] a, b, expect;
reg ctrl;
wire signed [31:0] z;
wire cout;

yArith myArith(z, cout, a, b, ctrl);

initial
begin
    repeat(5)
    begin
        a = $random;
        b = $random;
        ctrl = $random%2;
        expect = ctrl ? (a - b) : (a + b);
        #1; // wait for z result

        if (expect === z)
            $display("PASS: time=%1d a=%1d b=%1d z=%1d ctrl=%b", $time, a, b, z, ctrl);
        else
            $display("FAIL: time=%1d a=%1d b=%1d z=%1d ctrl=%b", $time, a, b, z, ctrl);
    end
    $finish;
end

endmodule
