module pipetest;
  parameter N=8;
  reg clk;
  reg [N-1:0] A,B,C,D;
  wire [N-1:0] F;

  mypipe MYPIPE(A,B,C,D,F,clk);

  initial clk=0;
  always #5 clk = ~clk;

  initial begin
    $monitor($time, "a=%d, b=%d, c=%d, d=%d, f=%d", A,B,C,D,F);
   #3 A=2;B=3;C=4;D=2;
   #10 A=20;B=3;C=7;D=2;
   #10 A=2;B=3;C=42;D=6;
   #10 A=2;B=4;C=5;D=2;
   #10 A=9;B=6;C=4;D=2;
   #10 A=2;B=3;C=11;D=0;
   #10 A=0;B=10;C=0;D=2;
   #10 A=2;B=0;C=23;D=34;
   #100 $finish ;
  end
  endmodule



