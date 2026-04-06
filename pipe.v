module mypipe (
    A,B,C,D,F,clk
);
  parameter N = 8;
  output [N-1:0] F;
  input [N-1:0] A,B,C,D;
  input clk;
  reg [N-1:0] l23_x1, l23_x2, l23_D, l34_x3, l34_D, l45_F;

  assign F = l45_F;

  always @(posedge clk ) begin
    l23_x1 <= A+B;
    l23_x2 <= C-D;
    l23_D <= D;
  end

  always @(posedge clk ) begin
    l34_x3 <= l23_x1 + l23_x2;
    l34_D <= l23_D;
  end

  always @(posedge clk ) begin
    l45_F <= l34_x3*l34_D;
  end


endmodule
