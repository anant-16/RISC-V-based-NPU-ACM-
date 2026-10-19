module simdalu (
    input  wire [127:0] A,
    input  wire [127:0] B,
    input  wire [1:0]   mode,
    input  wire         op,
    output reg  [127:0] Y
);

    integer i;
    reg [32:0] temp;

    always @(*) begin
        Y = 128'b0;
        temp = 33'b0;

        case (mode)

            //16 lanes, 8 bits wide
            2'b00: begin
                for (i = 0; i < 16; i = i + 1) begin
                    if (op == 1'b0) begin //for op=0,its addition with overflow detection
                        temp = {1'b0, A[i*8 +: 8]}
                             + {1'b0, B[i*8 +: 8]}; /*selecting individuals A and B, 8 bits 
									  of A and B starting from position i*8*/

                        if (temp[8])
                            Y[i*8 +: 8] = 8'hFF; /*if the extra carry bit it set, we would't be able to
									 store it as we are working in bits upto 255, so we would just output it*/
                        else
                            Y[i*8 +: 8] = temp[7:0];
                    end
                    else begin
                        if (A[i*8 +: 8] < B[i*8 +: 8])
                            Y[i*8 +: 8] = 8'h00; /*to avoid unsigned subtraction when the predecing 
									 operand is smalled, we just put zero*/
                        else
                            Y[i*8 +: 8] =
                                A[i*8 +: 8] - B[i*8 +: 8];
                    end
                end
            end
				
				// same logic is applied to 8 and 4 lanes as well
            //8 lanes, 16 bits wide
            2'b01: begin
                for (i = 0; i < 8; i = i + 1) begin
                    if (op == 1'b0) begin
                        temp = {1'b0, A[i*16 +: 16]}
                             + {1'b0, B[i*16 +: 16]};

                        if (temp[16])
                            Y[i*16 +: 16] = 16'hFFFF;
                        else
                            Y[i*16 +: 16] = temp[15:0];
                    end
                    else begin
                        if (A[i*16 +: 16] < B[i*16 +: 16])
                            Y[i*16 +: 16] = 16'h0000;
                        else
                            Y[i*16 +: 16] =
                                A[i*16 +: 16] - B[i*16 +: 16];
                    end
                end
            end

            //4 lanes, 32 bits wide
            2'b10: begin
                for (i = 0; i < 4; i = i + 1) begin
                    if (op == 1'b0) begin
                        temp = {1'b0, A[i*32 +: 32]}
                             + {1'b0, B[i*32 +: 32]};

                        if (temp[32])
                            Y[i*32 +: 32] = 32'hFFFFFFFF;
                        else
                            Y[i*32 +: 32] = temp[31:0];
                    end
                    else begin
                        if (A[i*32 +: 32] < B[i*32 +: 32])
                            Y[i*32 +: 32] = 32'h00000000;
                        else
                            Y[i*32 +: 32] =
                                A[i*32 +: 32] - B[i*32 +: 32];
                    end
                end
            end

            default: Y = 128'b0;

        endcase
    end

endmodule