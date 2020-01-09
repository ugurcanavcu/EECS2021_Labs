// Student: Ugur Can Avcu
// Course: EECS2021 LabL

//ALU4
//This module implements a 4-bit ALU
// ctr:0 :ADD, 1: AND, 2:OR, 4: SUB, 7:XNOR
// a and b are 4-bit inputs

module ALU4(z, a, b, c, ctl);
input signed [3:0] a, b;
input [2:0] ctl;
output[3:0] z;
wire [3:0] andOut, orOut, xnorOut,arithOut;
wire cout, one;
assign one =1;

xnor xnorGate[3:0](xnorOut,a,b);
nand andGate[3:0](andOut,a,b);
or orGate[3:0](andOut,a,b);
yArith arith(arithOut, cout,a,b,ctl[2:2]);
yMux4to1 #(.SIZE(4)) mux(z, arithOut,andOut,orOut,xnorOut,ctl[1:0]);

endmodule

//t_ALU
// This module tests a 4-bit ALU.
// Random numbers are generated for inputs a and b.
// Every possible function of the ALU is tested
// Time, inputs and outputs are displayed for verification/

module t_ALU
reg [3:0] a,b ,expected;
reg [2:0] ctl;
wire [3:0] z;
ALU4 alu4(z,a,b,ctl);

initial
begin
  repeat(3)
  begin
  a=$random;
  b=$random;
  ctl =0;
   
   #5;

   expected  = a+b
   if(expected == z)
   $display("Time:%5d PASS %b + %b=%b", $time,a, b, z); // addition pass
   else
   $display("Time:%5d FAIL %b + %b=%b", $time,a, b, z) // addition fail

   ctl =1;
   #5;
   expected = ~(a&b);

   if(expected == z)

    $display("Time:%5d PASS %b NAND %b=%b", $time,a, b, z); // NAND pass
    
    else
    $display("Time:%5d FAIL %b NAND %b=%b", $time,a, b, z); // NAND fail

    ctl = 2;
    #5;
    expected = a|b;
    if(expected == z)
     $display("Time:%5d PASS %b OR %b=%b", $time,a, b, z); // OR pass
     else
     $display("Time:%5d FAIL %b OR %b=%b", $time,a, b, z); // OR fail

    ctl = 4;
    #5;
    expected = a-b;
    if(expected == z)
     $display("Time:%5d PASS %b - %b=%b", $time,a, b, z); // Substraction pass
     else
     $display("Time:%5d FAIL %b - %b=%b", $time,a, b, z); // Substraction fail

    ctl = 7;
    #5;
    expected = ~(a ^ b);
    if(expected == z)
     $display("Time:%5d PASS %b XNOR %b=%b", $time,a, b, z); // OR pass
     else
     $display("Time:%5d FAIL %b XNOR %b=%b", $time,a, b, z); // OR fail
     $display("");

        end

    end
endmodule

//yMux1
//This module implements a 1-bit multiplexor

module yMux1(z,a,b,c);
output z;
input a,b,c;
wire notC, upper, lower;
not my_not(notC, c);
and upperAnd(upper, a, notC);
and lowerAnd(lower, c, b);
or my_or(z, upper, lower);
endmodule

//yMux
//this module implements a SIZE-bit multiplexor
//Width of multiplexor can be adjusted by passing in the SIZE parameter
// Default value of the SIZE parameter is 2

module yMux(z,a,b,c);
parameter SIZE =2;
output[SIZE-1:0] z;
input [SIZE-1:0] a, b;
input c;
yMux1 mine[SIZE-1:0](z,a,b,c);

endmodule


//yMux4to1
// This module implements a 4 to 1 SIZE-bit multiplexor
//Width of multiplexor can be adjusted by passing in the SIZE parameter
// Default value of the SIZE parameter is 2

module yMux4to1(z,a0,a1,a2,a3,c);
parameter SIZE =2;
output[SIZE-1:0] z;
input [SIZE-1:0] a0, a1, a2, a3;
input [1:0] c;
wire [SIZE-1:0] zLo, zHi;
yMux #(SIZE) lo(zLo, a0, a1, c[0]);
yMux #(SIZE) hi(zHi, a2, a3, c[0]);
yMux #(SIZE) final(z, zLo, zHi, c[1]);

endmodule


// yAdder1
// This module implements a full adder

module yAdder1(z, cout, a, b, cin);
output z, cout;
input a, b, cin;
xor left_xor(tmp, a, b);
xor right_xor(z, cin, tmp);
and left_and(outL, a, b);
and right_and(outR, tmp,cin);
or my_or(cout, outR, outL);

endmodule


//yAdder
//This module implements a 4-bit adder
module yAdder(z,cout, a, b, cin);

output [3:0] z;
output cout;
input [3:0] a,b;
input cin;
wire [3:0] in, out;
yAdder1 mine[3:0](z,out,a,b,in);

assign in[0]= cin;

genvar i;
generate

for(i=1; i<4; i = i+1)
begin
assign in[i] = out[i-1];]
end
endgenerate

endmodule


//yArith
//This module implements an adder and subtractor

module yArith(z, cout, a, b, ctrl);
output[3:0] z;
output cout;
input [3:0] a, b;
input ctrl;
wire[3:0] notB, tmp;
wire cin;
not not1 [3:0](notB, b);
yMux #(.SIZE(4)) mux(tmp, b, notB, ctrl);
yAdder adder(z, cout, a, tmp, ctrl);

endmodule

