module labL;
reg [31:0] a, b;
reg [31:0] expect;
reg [2:0] op;
wire ex;
wire [31:0] z;
reg ok, flag;

yAlu mine(z, ex, a, b, op);

initial
begin
  repeat (10)
  begin
    a = $random;
    b = $random;
    ok = 0;
    flag = $value$plusargs("op=%d", op);

    if(op[0] === 0 && op[1] === 0 && op[2] === 0)
      expect = a & b;
    else if(op[0] === 1 && op[1] === 0 && op[2] === 0)
      expect = a | b;
    else if(op[0] === 0 && op[1] === 1 && op[2] === 0)
      expect = a + b;
    else if(op[0] === 0 && op[1] === 1 && op[2] === 1)
      expect = a - b;
    #1;
    if(expect === z)
      ok = 1;
      #2 $display("time=%1d ok=%d a=%b b=%b op=%b z=%b", $time, ok, a, b, op, z);
  end
$finish;
end
endmodule
