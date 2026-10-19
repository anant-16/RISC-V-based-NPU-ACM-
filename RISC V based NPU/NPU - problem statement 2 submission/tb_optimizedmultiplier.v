`timescale 1ns/1ps

module tb_optimizedmultiplier;
reg clk;
reg rst;
reg srt;
reg [3:0] M;
reg [3:0] Qin;

wire [7:0] prod;
wire done;

optimizedmultiplier uut (//instantiation
        .clk(clk), .rst(rst), .srt(srt), .M(M), .Qin(Qin), .prod(prod), .done(done)
    );

always #5 clk = ~clk;
initial begin
        
clk = 0; rst = 1; srt = 0; M = 0; Qin  = 0;
#10; rst = 0;

//11*7=77 case
@(negedge clk);
M = 4'b1011;
Qin = 4'b0111;
srt = 1;

@(negedge clk);
srt = 0;
wait(done == 1); //multiplication completed
repeat(2) @(negedge clk);

//6*9=54 case
M = 4'b0110;
Qin = 4'b1001;
srt = 1;

@(negedge clk);
srt = 0;
wait(done == 1);
repeat(3) @(negedge clk);

$stop;
end

endmodule