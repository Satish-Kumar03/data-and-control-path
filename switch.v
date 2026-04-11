module switch(out, in, sel);
  parameter data_size = 16, sel_size = 4;
  output [data_size-1:0] out;
  input [data_size-1:0] in;
  input [sel_size-1:0] sel;

  nmos(out,in,sel);
  pmos(out,in,~sel);
endmodule 
  
