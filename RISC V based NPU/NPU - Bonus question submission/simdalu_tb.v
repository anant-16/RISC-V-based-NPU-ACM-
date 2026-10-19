`timescale 1ns/1ps

module simdalu_tb;

    reg  [127:0] A, B;
    reg  [1:0]   mode;
    reg          op;
    wire [127:0] Y;

    simdalu uut ( //instantiation
        .A(A),
        .B(B),
        .mode(mode),
        .op(op),
        .Y(Y)
    );

    initial begin

        //8-bit addition with saturation
        mode = 2'b00;
        op   = 1'b0;
        A = 128'h000000000000000000000000000000FA;
        B = 128'h00000000000000000000000000000014;
        #10;
        $display("8-bit ADD: Y = %h", Y);

        //8-bit subtraction with underflow
        op = 1'b1;
        A = 128'h00000000000000000000000000000032;
        B = 128'h00000000000000000000000000000050;
        #10;
        $display("8-bit SUB: Y = %h", Y);

        //16-bit addition with saturation
        mode = 2'b01;
        op   = 1'b0;
        A = 128'h0000000000000000000000000000FDE8;
        B = 128'h000000000000000000000000000003E8;
        #10;
        $display("16-bit ADD: Y = %h", Y);

        //16-bit subtraction
        op = 1'b1;
        A = 128'h00000000000000000000000000000064;
        B = 128'h00000000000000000000000000000032;
        #10;
        $display("16-bit SUB: Y = %h", Y);

        //32-bit addition with saturation
        mode = 2'b10;
        op   = 1'b0;
        A = 128'h000000000000000000000000FFFFFFF0;
        B = 128'h00000000000000000000000000000020;
        #10;
        $display("32-bit ADD: Y = %h", Y);

        //32-bit subtraction with underflow
        op = 1'b1;
        A = 128'h00000000000000000000000000000064;
        B = 128'h000000000000000000000000000001F4;
        #10;
        $display("32-bit SUB: Y = %h", Y);

        $finish;
    end

endmodule