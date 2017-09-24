module agc_controller(
	input clk,
	input RESETn,
	input [3:0] counter1,
	input [3:0] counter2,
	input [7:0] preamble_counter,
	input indicator,
	input done,
	output wire counter1_mode,
	output wire counter2_mode,
	output wire preamble_counter_mode,
	output wire detect_mode,
	output wire adjust,
	output wire up_dn
	);

//State Encoding
localparam s_reset = 2'b00,
		   s_detect = 2'b01;
		   s_adjust = 2'b10;
		   s_done = 2'b11;

reg [1:0] state;
reg [1:0] next_state;

always @(*) begin: next_state_logic
	next_state = state;
	case(state)
		s_reset: begin
			next_state = s_detect;
		end

		s_detect: begin
			if((preamble_counter == 8'd127) || done)
				next_state = s_done;
			else if(counter1 == 4'b1111)
				next_state = s_adjust;
		end

		s_adjust: begin
			if(preamble_counter == 8'd127 || done)
				next_state = s_done;
			else if(counter2 == 4'b1111)
				next_state = s_detect;
		end

		s_done: begin 
			//Do nothing.
		end

		default: begin
			next_state = s_reset;
		end
	endcase // state
end // next_state_logic

always @(*) begin : state_actions
	counter1_mode = 0;
	counter2_mode = 0;
	preamble_counter_mode = 1;
	detect_mode = 0;
	adjust = 0;
	up_dn = 1;
	case(state)
		s_reset: begin
			preamble_counter_mode = 0;
		end

		s_detect: begin 
			counter1_mode = 1;
			detect_mode = 1;
		end

		s_adjust: begin 
			counter2_mode = 1;
			adjust = 1;
			up_dn = !indicator;
		end

		s_done: begin 

		end
	endcase // state
end // state_actions

always @(posedge clk) begin : next_state_assignment
	if(!RESETn) begin
		state <= s_reset;
	end else begin
		state <= next_state;
	end
end // next_state_assignment
endmodule // agc_controller