module gain_binary_search(
	input clk,
	input RESETn,
	input adjust,
	input up_dn,				//When adjust = 1, increase gain array if up_dn = 1; decrease if up_dn = 0
	output reg [5:0] gain_array,
	output wire done			//Signals binary search through gain array has completed
);

reg [2:0] ptr;

assign done = (&ptr);			//When ptr = 000, and one more adjustment is made, ptr - 1 = 111, and it's the only time &ptr == 1


always @(posedge clk) begin
	if(!RESETn) begin
		gain_array <= 6'b111111;
		ptr <= 3'b101;
	end
	else begin
		if(adjust) begin
			//Turn up gain, as long as gain is not maxed
			if(up_dn && (gain_array != 6'b111111)) begin
				gain_array[ptr] <= 0;
				gain_array[ptr+1] <= 1;
				ptr <= ptr - 1;
			end
			//Turn down gain
			else if(!up_dn) begin 
				gain_array[ptr] <= 0;
				ptr <= ptr - 1;
			end
		end
	end
end

/*always @(posedge clk) begin
	if(!RESETn) begin
		gain_array <= 6'b100110;
		ptr <= 3'b101;
	end
	else begin
		if(adjust) begin
			//Turn up gain, as long as gain is not maxed
			if(up_dn && (gain_array != 6'b100110)) begin
				if(gain_array == 6'b011111) begin
					gain_array <= 6'b100011;
					ptr <= 3'b001;
				end
				else begin
					gain_array[ptr] <= 0;
					gain_array[ptr+1] <= 1;
					ptr <= ptr - 1;
				end
			end
			//Turn down gain
			else if(!up_dn) begin 
				if(gain_array == 6'b100110) begin 
					gain_array <= 6'b011111;
				end
				else begin 
					gain_array[ptr] <= 0;
				end
				ptr <= ptr - 1;
			end
		end
	end
end*/

endmodule // gain_binary_search