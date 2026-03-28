module multidata(qm1,clk,ldA,ldQ,ldM,clrA,clrQ,clrff,shftA,shftQ,addsub, data_in);
  output qm1;
  input clk, ldA, ldQ, ldM, clrA, clrQ, clrff, shftA, shftQ, addsub;
  input [7:0] data_in;
  wire [7:0] bus, Qout, Mout, Aout, z;
  reg [7:0] A=0;

  PIPO Q(Qout,bus,ldQ,clk);
  PIPO M(Mout,bus,ldM,clk);
  PIPO A(Aout,z,ldA,clk);
  MUX M1(z,Aout,Mout,clk);
  SHIFT S(
  
endmodule
