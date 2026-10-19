`timescale 1ns/1ps

module tb_roundrobinarbiter;

reg clk;
reg rst;
reg [3:0]req;
wire [3:0]gnt;


roundrobinarbiter uut ( //instantiation
    .clk(clk), .rst(rst), .req(req), .gnt(gnt)
);

always #5 clk = ~clk;
initial begin
    clk = 0;
    rst = 1; //initially resetting for req[0] for 10ns
    req = 4'b0000;
        #10; rst = 0;

			req = 4'b1111; //a case where all requesters are requesting access


        repeat (4) begin
            @(posedge clk);
            #1; //obseriving all four arbitration cycles
            $display("Time=%0t req=%b gnt=%b priority=%d",
                     $time, req, gnt, uut.priority);
        end

        @(posedge clk);
        #1; //checking if the arbiter starts another round
        $display("Time=%0t req=%b gnt=%b priority=%d",
                 $time, req, gnt, uut.priority);

        
        req = 4'b0100;
        @(posedge clk);
        #1; //testing a single requester
        $display("Single request: req=%b gnt=%b", req, gnt);

        
        req = 4'b0000;
        #10; //testing with no requests
        $display("No requests: req=%b gnt=%b", req, gnt);

        $finish;
    end

endmodule