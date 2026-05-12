module riscv_tb;
  reg clk1, clk2;
  riscv DUT(clk1, clk2);

  initial begin
    clk1=0; clk2=0;
  end 
    
endmodule 
