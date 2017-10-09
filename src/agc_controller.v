module agc_controller(
	input clk,
	input RESETn,
	input [3:0] counter1,
	input [7:0] counter2,
	input [7:0] target_counter2,
	input indicator,
	input done,
	output reg counter1_mode,
	output reg counter2_mode,
	//output reg preamble_counter_mode,
	output reg detect_mode,
	output reg adjust,
	output reg up_dn
	);

//State Encoding
localparam s_reset = 2'b00,
		   s_detect = 2'b01,
		   s_adjust = 2'b10,
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
			if(done)
				next_state = s_done;
			else if(counter1 == 4'b1111)
				next_state = s_adjust;
		end

		s_adjust: begin
			if(done)
				next_state = s_done;
			else if(counter2 == target_counter2)
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
	//preamble_counter_mode = 1;
	detect_mode = 0;
	adjust = 0;
	up_dn = 1;
	case(state)
		s_reset: begin
			//preamble_counter_mode = 0;
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