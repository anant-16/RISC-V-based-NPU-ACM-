module roundrobinarbiter(
	input wire clk,
	input wire rst,
	input wire [3:0]req,
	output reg [3:0]gnt);

reg [1:0] priority; /*The arbiter needs to remember which requester should get the priority next 
as there are four bit requests, we will assign four values to the priority register aswell 
two bits [1:0] can represent four values/states (0,1,2,3)*/


always @(posedge clk or posedge rst) begin 
    if (rst) //whenever reset is high, the priority rresets to zero state
        priority <= 2'd0;
    else if (|gnt) begin //|gnt checks whether any bit in gnt is 1(hihg)
								//If not then the block doesnt execute and no request is granted
        if (gnt[0])
            priority <= 2'd1;
        else if (gnt[1])
            priority <= 2'd2;
        else if (gnt[2])
            priority <= 2'd3;
        else
            priority <= 2'd0; //priority is given to whatever bit of gnt is high
    end
	 //update priority after each gnt
end

reg found; //checks if any requester has been selected or not
			  //because only one requester should recieve the grant
integer i;
integer idx; //for storing inder of currrent requester


always @(*) begin //combonational block
    gnt = 4'b0000;
    found = 1'b0;
    idx = 0;

    for (i = 0; i < 4; i = i + 1) begin
        idx = (priority + i) % 4; /*to ensure that whenever priority state is assigned
		  it should always reset to zero once the cycle is completed
		  basically 0-> 1-> 2-> 3-> 0 -> 1......*/

        if (!found && req[idx]) begin /*if found = 0, !found = 1, hence we ensure one condition is satisfied 
		  which was to maske sure no active requests are there when assigning a new request*/
		  
		  /*also, req[idx] selects that the current requester only is requesting access*/
            gnt[idx] = 1'b1; //thr request is granted to the idx'th requester
            found = 1'b1; // found is set to 1 as a requester has been selected now
        end
    end  //checks requests in roundrobin order
end

endmodule