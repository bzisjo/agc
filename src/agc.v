module agc(
	input clk, RESETn,

	//Output of ADC, after being amplified by the VGAs
	input [15:0] amplified_signal,

	//One bit signaling if input is saturated
	input overload,

	//Controls if the overload signal is generated internally (0) or externally (1)
	input ext_or_int,

	output wire [4:0] vga1_control,
	output wire [3:0] vga2_control,
	output wire [3:0] vga3_control,

	//Outputs for debugging
	output wire [5:0] gain_array_out,
	output wire done_out

	);


reg indicator;
reg [3:0] counter1;
reg [3:0] counter2;
reg [10:0] preamble_counter;
reg last_adjust;

wire [5:0] gain_array;
wire counter1_mode;			//0: resest, 1: count up
wire counter2_mode;
wire preamble_counter_mode;
wire detect_mode;			//0: clear indicator, 1: "envelope" detection
wire adjust_pos_edge;
wire adjust;
wire up_dn;
wire bs_done;
wire done;
wire internal_overload;

assign adjust_pos_edge = adjust && !last_adjust;
assign done = bs_done || (&preamble_counter);
assign internal_overload = (ext_or_int ? overload : (&amplified_signal));

//Debugging outputs
assign gain_array_out = gain_array;
assign done_out = done;

gain_binary_search gbs(
	.clk       (clk),
	.RESETn    (RESETn),
	.adjust    (adjust_pos_edge),
	.up_dn     (up_dn),
	.gain_array(gain_array),
	.done      (bs_done)
	);

agc_controller agcc(
	.clk                  (clk),
	.RESETn               (RESETn),
	.counter1             (counter1),
	.counter2             (counter2),
	.indicator            (indicator),
	.done                 (bs_done),
	.counter1_mode        (counter1_mode),
	.counter2_mode        (counter2_mode),
	.preamble_counter_mode(preamble_counter_mode),
	.detect_mode          (detect_mode),
	.adjust               (adjust),
	.up_dn                (up_dn)
	);

mapping_function mf(
	.gain_array  (gain_array),
	.vga1_control(vga1_control),
	.vga2_control(vga2_control),
	.vga3_control(vga3_control)
	);

always @(posedge clk) begin : proc_counters
	if(~RESETn) begin
		counter1 <= 4'b0;
		counter2 <= 4'b0;
		preamble_counter <= 11'b0;
		indicator <= 0;
		last_adjust <= 0;
	end else begin
		counter1 <= (counter1_mode ? counter1 + 1 : 4'b0);
		counter2 <= (counter2_mode ? counter2 + 1 : 4'b0);
		preamble_counter <= (preamble_counter_mode ? preamble_counter + 1 : 11'b0);	
		indicator <= (detect_mode ? (indicator || internal_overload) : 0);
		last_adjust <= adjust;
	end
end
endmodule // agc