module GCDcont(ldA, ldB, sel1, sel2, sel_in, done, lt, gt, eq, data_in, clk, start);
    output reg ldA, ldB, sel1, sel2, sel_in, done;
    input [15:0] data_in;
    input clk, start, lt, gt, eq;
    reg [2:0] ns, ps;
    parameter s0=0, s1=1, s2=2, s3=3, s4=4, s5=5;

    always @(posedge clk) begin
        case (ps)
          s0  : if(start) ps <= s1;
          s1  : ps <= s2;
          s2  : begin 
                  if(lt) ps <= s3;
                  else if(gt) ps<= s4;
                  else if(eq) ps <= s5;
          end
          s3  : begin
                 if(lt) ps <= s3;
                 else if(gt) ps<= s4;
                 else if(eq) ps <= s5;
          end
          s4  : begin
                  if(lt) ps <= s3;
                  else if(gt) ps<= s4;
                  else if(eq) ps <= s5;
          end
          s5  : ps <= s5; 
        default:  ps <= s0;
        endcase
    end


    always @(ps) begin
        case (ps)
          s0  : begin
            sel_in =1;
            ldA=1;
            ldB=0;
          end
          s1 : begin
            sel_in=1;
            ldA=0;
            ldB=1;

          end
          s2 : begin
            if(eq) done =1; 
            else if(gt) begin sel1=0; sel2=1; sel_in =0;
                               #3 ldA=1; ldB=0;
                        end
            else if(lt) begin
                sel1=1; sel2=0; sel_in=0;
                #3 ldA=0; ldB=1;
            end            
          end
          s3 : begin
            if(eq) done=1;
            else if(gt) begin
                sel1 =0; sel2=1; sel_in=0;
                #3 ldA=1; ldB=0;
            end
            else if(lt) begin
                sel1=1; sel2=0; sel_in=1;
                #3 ldA=0; ldB=1;
            end
          end
          s4 : begin
            if(eq) done=1;
            else if(gt) begin
                sel1 =0; sel2=1; sel_in=0;
                #3 ldA=1; ldB=0;
            end
            else if(lt) begin
                sel1=1; sel2=0; sel_in=1;
                #3 ldA=0; ldB=1;
            end
          end
          s5 : begin
            done =1; sel1=0; sel2=0; ldA=0; ldB=0;
          end
            default: begin
                ldA=0; ldB=0;
            end
        endcase
    end
endmodule
