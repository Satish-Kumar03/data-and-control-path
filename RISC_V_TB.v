module riscv_tb;
  reg clk1, clk2;
  integer i;
  riscv DUT(clk1, clk2);

  initial begin
    clk1=0; clk2=0;
    repeat(20) 
      begin
        #5 clk1=1; #5 clk1=0;
        #5 clk2=1; #5 clk2=0;
      end
  end 

  initial
    begin 
      for (i=0; i<31: i= i+1)
        riscv.reg_bank[i] = i;
    end

  initial
    begin
      riscv.mem[0] = 32'h
    
endmodule 
