module ricsv(clk1,clk2);
  parameter data_size = 32, mem_size = 1024;
  parameter ADD=000000, SUB=000001, AND=000010, OR=000011, SLT=000100, MUL=000101, HLT=111111,
            LW=001000, SW=001001,
  
  input clk1, clk2;
  reg [data_size-1:0] reg_bank[data_size-1:0];
  reg [data_size-1:0] mem[mem_size-1:0];
  
endmodule 
