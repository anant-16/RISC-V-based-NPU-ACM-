module optimizedmultiplier(
input clk, rst, srt,
input [3:0]M, Qin,
output reg [7:0]prod,
output reg done);

reg [3:0] A, Q, Mreg; //A = partial result of sum of M + A, Q = stores multiplieer, Mreg to store the M
reg C; //stores carry (single bit)
reg [2:0] count; // counts cycles, three bits (7 stages) counts 4 addition stagesa nd 4 shift stages
reg busy; //to prevent new operation form iteratiion when a multiplication is already goin'on
reg [4:0] sum; 
reg [8:0] temp;


always @(posedge clk or posedge rst) begin
    if (rst) begin //reseting everything
        A <= 0; Q <= 0; Mreg<= 0; C <= 0; count <= 0; prod <= 0; done <= 0; busy <= 0;
    end
    else begin
            done <= 0; //should stay low while multiplication is running, high only when completed

        if (srt && !busy) begin //process begins when multiplication has been requested and the system aint busy
                A <= 0; //initial state
                Q <= Qin; 
                Mreg <= M; //register has been valued with M
                C <= 0; //carry is resetetd
                count <= 0; //the count starts from now
                busy <= 1; //system is activated
        end

        else if (busy) begin //now when ths system is busy, i.e when active

            if (Q[0]) //checking the multipliers(Q's) rightmost bit (Q0)
                sum = {1'b0, A} + {1'b0, Mreg}; // here the M which was already assigned is being used to add with current A
            else
                sum = {1'b0, A}; // if not then A stays as A/ no addition of M
					 
            temp = {sum, Q} >> 1; /* concatinating the sum and Q to right shift thenm together by a, note that we are
				operating in an uunsigned system, the gap of leftmost bit is filled by 0, when the right shoting is 
				completed, its then stored in C, A and Q respectively to give them new values*/

				//we concatinated sum and Q as our product will also be in that form/ and its just easier to deal with
            C <= temp[8]; A <= temp[7:4]; Q <= temp[3:0];

            if (count == 3) begin /*iteration 0 is stage one so when count is 3, i.e stage is four, the process comes
				to an halt. the values are assigned to the final outcomes and its done*/ 
                prod <= temp[7:0];
                busy    <= 0;
                done    <= 1;
            end

            count <= count + 1'b1; //system doesnt proceed/ gives output after 3rd count.
        end
    end
end

endmodule