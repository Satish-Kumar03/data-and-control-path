module riscv(clk1,clk2);
  parameter data_size = 32, mem_size = 1024;
  parameter ADD=6'b000000, SUB=6'b000001, AND=6'b000010, OR=6'b000011, 
            SLT=6'b000100, MUL=6'b000101, XOR=6'b000110, SLL=6'b000111, 
            SRL=6'b001000, HLT=6'b111111;
  parameter LW=6'b001000, SW=6'b001001, ADDI=6'b001010, SUBI=6'b001011, 
            SLTI=6'b001100, BNEQZ=6'b001101, BEQZ=6'b001110, XORI=6'b001111,
            SLLI=6'b010000, SRLI=6'b010001; 
            
  parameter RR_ALU=3'b000, RM_ALU=3'b001, LOAD=3'b010, STORE=3'b011, BRANCH=3'b100, HALT=3'b101;
  input clk1, clk2;
  reg HALTED, BR_TAKEN;
  reg [data_size-1:0] reg_bank[0: data_size-1];
  reg [data_size-1:0] mem[0:mem_size-1];
  reg [2:0] ID_EX_type, EX_MEM_type, MEM_WB_type;
  
  reg [data_size-1:0] IF_ID_IR, IF_ID_NPC, PC;                               // for instruction fetch and instruction decode stage
  
  reg [data_size-1:0] ID_EX_A,ID_EX_B,ID_EX_IR, ID_EX_IMM, ID_EX_NPC;                  // for exceution stage
  //reg ID_EX_NPC;
  
  reg [data_size-1:0] EX_MEM_ALUout, EX_MEM_B, EX_MEM_IR, EX_MEM_NPC;                   //  for memory stage
  reg EX_MEM_COND;
  
  reg [data_size-1:0] MEM_WB_LMD, MEM_WB_IR, MEM_WB_B, MEM_WB_ALUout;                   // forwrite back stage 

  always @(posedge clk1)   
  begin                                                                  // IF stage 
    if(HALTED == 0)
      begin 
        if((EX_MEM_COND == 1 && EX_MEM_IR[31:26] == BEQZ) || (EX_MEM_COND == 0 && EX_MEM_IR[31:26] == BNEQZ))
        begin
            IF_ID_IR <= #2 mem[EX_MEM_ALUout];
            IF_ID_NPC <= #2 EX_MEM_ALUout + 1;
            PC <=  #2 EX_MEM_ALUout + 1;
            BR_TAKEN <= #2 1'b1;
        end
        else begin
          IF_ID_IR <= #2 mem[PC];
            IF_ID_NPC <= #2 PC+1;  
            PC <= #2 PC+1;  
        end   
      end
  end 

  always @(posedge clk2)
  begin                                                                   // ID stage
    if (HALTED == 0) 
      begin
        ID_EX_IR <= #2 IF_ID_IR;
        ID_EX_NPC <= #2 IF_ID_NPC;
        ID_EX_A <= #2 reg_bank[IF_ID_IR[25:21]];
        ID_EX_B <= #2 reg_bank[IF_ID_IR[20:16]];
        ID_EX_IMM <= #2 {{16{IF_ID_IR[15]}},IF_ID_IR[15:0]};                              // sign extension pending 
      end
  end

  always @(posedge clk1)
    begin                                                                 // EX stage 
    if(HALTED ==0)
      begin
       begin
        case(EX_MEM_IR[31:26])
          ADD,SUB,OR,AND,SLT,XOR,SLL,SRL,HLT : ID_EX_type <= #2 RR_ALU;
          ADDI,SUBI,SLTI,XORI,SLLI,SRLI : ID_EX_type <= #2 RM_ALU;
          LW : ID_EX_type <= #2 LOAD;
          SW : ID_EX_type <= #2 STORE;
          BEQZ, BNEQZ : ID_EX_type <= #2 BRANCH;
          HLT : ID_EX_type <= #2 HALT;
          default : ID_EX_type <= #2 HALT; 
        endcase 
       end 
     
    
    begin 
      case(ID_EX_type)
          RR_ALU : begin 
            case(ID_EX_IR[31:26])
              ADD : EX_MEM_ALUout <= #2 ID_EX_A + ID_EX_B;
              SUB : EX_MEM_ALUout <= #2 ID_EX_A - ID_EX_B;                    // adding comments 
              AND : EX_MEM_ALUout <= #2 ID_EX_A & ID_EX_B;
              OR : EX_MEM_ALUout <= #2 ID_EX_A | ID_EX_B;
              SLT : EX_MEM_ALUout <= #2 ID_EX_A < ID_EX_B ? 1 : 0;
              MUL : EX_MEM_ALUout <= #2 ID_EX_A * ID_EX_B;
              XOR : EX_MEM_ALUout <= #2 ID_EX_A ^ ID_EX_B;
              SLL : EX_MEM_ALUout <= #2 ID_EX_A << ID_EX_B;
              SRL : EX_MEM_ALUout <= #2 ID_EX_A >> ID_EX_B;
              default EX_MEM_ALUout <= #2 32'hxxxxxxxx;
            endcase
          end
          RM_ALU : begin 
            case(ID_EX_IR[31:26])
              ADDI : EX_MEM_ALUout <= #2 ID_EX_A + ID_EX_IMM;
              SUBI : EX_MEM_ALUout <= #2 ID_EX_A - ID_EX_IMM;
              SLTI : EX_MEM_ALUout <= #2 ID_EX_A < ID_EX_IMM ? 1 : 0;
              XORI : EX_MEM_ALUout <= #2 ID_EX_A ^ ID_EX_IMM;
              SLLI : EX_MEM_ALUout <= #2 ID_EX_A << ID_EX_IMM;
              SRLI : EX_MEM_ALUout <= #2 ID_EX_A >> ID_EX_IMM;              
              default : EX_MEM_ALUout <= #2 32'hxxxxxxxx;
            endcase
          end 
          LOAD, STORE : begin
            EX_MEM_B <= #2 ID_EX_A + ID_EX_IMM;
          end
          BRANCH : begin
            EX_MEM_ALUout <= #2 ID_EX_NPC + ID_EX_IMM;
            EX_MEM_COND <= #2 (ID_EX_A == 0);
          end 
      endcase
    end

        EX_MEM_IR <= #2 ID_EX_IR;
        EX_MEM_type <= #2 ID_EX_type;
  end
    end
  always @(posedge clk2)                                                                  // MEM stage 
    begin 
      MEM_WB_IR <= EX_MEM_IR;
      MEM_WB_type <= EX_MEM_type;
      case(EX_MEM_type)
         RR_ALU, RM_ALU : begin 
           MEM_WB_ALUout <= EX_MEM_ALUout;
         end
        LOAD : begin
          MEM_WB_LMD <= mem[EX_MEM_ALUout];
        end
        STORE : begin
          if(BR_TAKEN ==0)
            mem[EX_MEM_ALUout] <= EX_MEM_B;
        end
      endcase
    end

  always @(posedge clk1)                                                                  // WB stage 
    if(BR_TAKEN == 0)
      begin
        case (MEM_WB_type)
          RR_ALU : reg_bank[MEM_WB_IR[15:11]] <= MEM_WB_ALUout;
          RM_ALU : reg_bank[MEM_WB_IR[20:16]] <= MEM_WB_ALUout;
          LOAD : reg_bank[MEM_WB_IR[20:16]] <= MEM_WB_LMD;
          HALT : HALTED <= 1'b1;
        endcase
      end
        
endmodule 
