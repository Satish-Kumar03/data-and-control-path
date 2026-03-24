module gcdtest;
    reg [15:0] A,B;
    reg start, clk;
    wire done;

    reg [15:0] data_in;
    GCDdata DP (gt, lt, eq, ldA, ldB, sel_in, clk, data_in, sel1, sel2);
    GCDcont CON (ldA, ldB, sel1, sel2, sel_in, done, lt, gt, eq, data_in, clk, start);

    initial begin
        clk =1'b0;
        #3 start=1'b1;
    end

    always #5 clk = ~clk;

    initial begin
        #12 data_in = 143;      // put your data here 
        #10 data_in = 78;       // put here data
    end

    initial begin
        $monitor($time, "%d, %b", DP.Aout, done);
        #1000 $finish;
    end

endmodule
