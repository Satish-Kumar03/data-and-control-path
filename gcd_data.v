module GCDdata (
    gt, lt, eq, ldA, ldB, sel_in, clk, data_in, sel1, sel2      // data path gives output gt, lt and eq to controller.
);
    output gt, lt, eq;
    input ldA, ldB, sel_in, clk, sel1, sel2;
    input [15:0] data_in;
    wire [15:0] bus, Aout,Bout, subout, x, y;

    PIPO A(Aout, bus, ldA, clk);
    PIPO B(Bout, bus, ldB, clk);
    MUX MA(x, sel1, Aout, Bout);
    MUX MB(y, sel2, Aout, Bout);
    MUX LD(bus, sel_in, data_in, subout);
    COMP C(lt,gt,eq, Aout, Bout);
    SUB S(subout, x,y);

endmodule

module PIPO(data_out, data_in, load, clk);
   input [15:0]data_in;
   input clk, load;
   output reg [15:0] data_out;

   always @(posedge clk)
      begin 
          if(load) data_out <= data_in;
      end
endmodule

module MUX(out, sel, in0, in1);     // always use mux in0 -> 0 and in1 -> 1
    input [15:0] in0, in1;
    input sel;
    output [15:0] out;

    assign out = sel ? in1 : in0;
endmodule

module COMP(lt, gt, eq, in0, in1);
    input [15:0] in0, in1;
    output lt, gt, eq;

    assign lt = in0 < in1;
    assign gt = in0 > in1;
    assign eq = in0 == in1;
endmodule

module SUB(subout, in0, in1);
    input [15:0] in0, in1;
    output reg [15:0] subout;  // do not use assign statement, as it requires to store the result. hence used reg. 

    always @(*) begin
        subout = in0-in1;
    end

endmodule
