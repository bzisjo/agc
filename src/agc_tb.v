`timescale 1 ns /  1 ps
module agc_tb();

	reg clk;
	reg RESETn;
	wire overload;
	wire [5:0] gain_array_out;
	wire done;

	reg [5:0] target_gain;

	// Don't care about these for now
	reg [3:0] amplified_signal;
	wire [63:0] vga_control;

	//DUT Instantiation
	agc dut(
		.clk             (clk),
		.RESETn          (RESETn),
		.amplified_signal(amplified_signal),
		.overload        (overload),
		.ext_or_int		 (1'b1),
		.vga_control	 (vga_control),
		.gain_array_out  (gain_array_out),
		.done_out        (done)
		);

	//assign target_gain = 6'd39;
	assign overload = (gain_array_out > target_gain);

	initial begin 
		clk = 0;
		RESETn = 1;
		amplified_signal = 16'd0;
		target_gain = 6'd63;			//Tiny signal; gain is maxed
		#10 RESETn = 0;
		#20 RESETn = 1;
		#1000 target_gain = 6'd56;		//Some signal, lower gain
	end
	always
		#5 clk = ~clk;

  //--------------------------------------------------------------------
  // Timeout
  //--------------------------------------------------------------------
  // If something goes wrong, kill the simulation...
/*  reg [  63:0] cycle_count = 0;
  always @(posedge clk) begin
    cycle_count = cycle_count + 1;
    if (cycle_count >= 3000) begin
      $display("TIMEOUT");
      $finish;
    end
  end*/


endmodule // agc_tb