module ricsv(clk1,clk2);
  parameter data_size = 32, mem_size = 1024, addr_size=5;
  parameter ADD=000000, SUB=000001, AND=000010, OR=000011, SLT=000100, MUL=000101, HLT=111111,
            LW=001000, SW=001001, ADDI=001010, SUBI=001011, SLTI=001100, BNEQZ=001101, BEQZ=001110;
  
  input clk1, clk2;
  reg pc;
  reg [data_size-1:0] reg_bank[data_size-1:0];
  reg [data_size-1:0] mem[mem_size-1:0];
  reg [addr_size-1:0] rs,rt,rd;
  
  reg [data_size-1:0] IF_ID_IR;             // for instruction fetch and instruction decode stage
  reg IF_ID_NPC;
  
  reg [data_size-1:0] ID_EX_A,ID_EX_B,ID_EX_IR, ID_EX_IMM;       // for exceution stage
  reg ID_EX_NPC;
  
  reg [data_size-1:0] EX_MEM_ALUout, EX_MEM_B, EX_MEM_IR;            //  for memory stage
  reg EX_MEM_COND;
  
  reg [data_size-1:0] MEM_WB_LMD, MEM_WB_IR, MEM_WB_B, MEM_WB_ALUout;     // forwrite back stage 


  
  
endmodule 
