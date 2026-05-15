module riscv_tb;
  reg clk1, clk2;
  integer i;
  riscv mips(clk1, clk2);

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
        mips.reg_bank[i] = i;

      mips.mem[0] = 32'h2801000A;     // ADDI R1 R0 10;
      mips.mem[1] = 32'h28020014;     // ADDI R2 R0 20;
      mips.mem[2] = 32'h28030019;     // ADDI R3 R0 25;
      mips.mem[3] = 32'h0ce77800;     // OR R7 R7 R7;
      mips.mem[4] = 32'h0ce77800;     // OR R7 R7 R7;
      mips.mem[5] = 32'h00412000;     // ADD R4 R1 R2;
      mips.mem[6] = 32'h0ce77800;     // OR R7 R7 R7;
      mips.mem[7] = 32'h00685000;     // ADD R5 R4 R3;
      mips.mem[8] = 32'hfc000000;     // halt

      mips.HALTED = 0;
      mips.BR_TAKEN =0;
      mips.PC =0;

      #300
      for(i=0; i<6; i=i+1)
        $display("R%1d = %2d", i, mips.reg_bank[i])
    end
  
endmodule 
