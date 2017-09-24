module mapping_function(
	input [5:0] gain_array,
	output reg [4:0] vga1_control,
	output reg [3:0] vga2_control,
	output reg [3:0] vga3_control
	);

always @(*) begin : proc_mapping
	vga1_control = 5'b10010;
	vga2_control = 4'b1010;
	vga3_control = 4'b1010;
	case(gain_array)
		6'd38: begin
			vga1_control = 5'd18;
			vga2_control = 4'd10;
			vga3_control = 4'd10;
		end
		6'd37: begin
			vga1_control = 5'd17;
			vga2_control = 4'd10;
			vga3_control = 4'd10;
		end
		6'd36: begin
			vga1_control = 5'd16;
			vga2_control = 4'd10;
			vga3_control = 4'd10;
		end
		6'd35: begin
			vga1_control = 5'd15;
			vga2_control = 4'd10;
			vga3_control = 4'd10;
		end
		6'd34: begin
			vga1_control = 5'd14;
			vga2_control = 4'd10;
			vga3_control = 4'd10;
		end
		6'd33: begin
			vga1_control = 5'd13;
			vga2_control = 4'd10;
			vga3_control = 4'd10;
		end
		6'd32: begin
			vga1_control = 5'd12;
			vga2_control = 4'd10;
			vga3_control = 4'd10;
		end
		6'd31: begin
			vga1_control = 5'd11;
			vga2_control = 4'd10;
			vga3_control = 4'd10;
		end
		6'd30: begin
			vga1_control = 5'd10;
			vga2_control = 4'd10;
			vga3_control = 4'd10;
		end
		6'd29: begin
			vga1_control = 5'd9;
			vga2_control = 4'd10;
			vga3_control = 4'd10;
		end
		6'd28: begin
			vga1_control = 5'd8;
			vga2_control = 4'd10;
			vga3_control = 4'd10;
		end
		6'd27: begin
			vga1_control = 5'd7;
			vga2_control = 4'd10;
			vga3_control = 4'd10;
		end
		6'd26: begin
			vga1_control = 5'd6;
			vga2_control = 4'd10;
			vga3_control = 4'd10;
		end
		6'd25: begin
			vga1_control = 5'd5;
			vga2_control = 4'd10;
			vga3_control = 4'd10;
		end
		6'd24: begin
			vga1_control = 5'd4;
			vga2_control = 4'd10;
			vga3_control = 4'd10;
		end
		6'd23: begin
			vga1_control = 5'd3;
			vga2_control = 4'd10;
			vga3_control = 4'd10;
		end
		6'd22: begin
			vga1_control = 5'd2;
			vga2_control = 4'd10;
			vga3_control = 4'd10;
		end
		6'd21: begin
			vga1_control = 5'd1;
			vga2_control = 4'd10;
			vga3_control = 4'd10;
		end
		6'd20: begin
			vga1_control = 5'd0;
			vga2_control = 4'd10;
			vga3_control = 4'd10;
		end
		6'd19: begin
			vga1_control = 5'd0;
			vga2_control = 4'd9;
			vga3_control = 4'd10;
		end
		6'd18: begin
			vga1_control = 5'd0;
			vga2_control = 4'd8;
			vga3_control = 4'd10;
		end
		6'd17: begin
			vga1_control = 5'd0;
			vga2_control = 4'd7;
			vga3_control = 4'd10;
		end
		6'd16: begin
			vga1_control = 5'd0;
			vga2_control = 4'd6;
			vga3_control = 4'd10;
		end
		6'd15: begin
			vga1_control = 5'd0;
			vga2_control = 4'd5;
			vga3_control = 4'd10;
		end
		6'd14: begin
			vga1_control = 5'd0;
			vga2_control = 4'd4;
			vga3_control = 4'd10;
		end
		6'd13: begin
			vga1_control = 5'd0;
			vga2_control = 4'd3;
			vga3_control = 4'd10;
		end
		6'd12: begin
			vga1_control = 5'd0;
			vga2_control = 4'd2;
			vga3_control = 4'd10;
		end
		6'd11: begin
			vga1_control = 5'd0;
			vga2_control = 4'd1;
			vga3_control = 4'd10;
		end
		6'd10: begin
			vga1_control = 5'd0;
			vga2_control = 4'd0;
			vga3_control = 4'd10;
		end
		6'd9: begin
			vga1_control = 5'd0;
			vga2_control = 4'd0;
			vga3_control = 4'd9;
		end
		6'd8: begin
			vga1_control = 5'd0;
			vga2_control = 4'd0;
			vga3_control = 4'd8;
		end
		6'd7: begin
			vga1_control = 5'd0;
			vga2_control = 4'd0;
			vga3_control = 4'd7;
		end
		6'd6: begin
			vga1_control = 5'd0;
			vga2_control = 4'd0;
			vga3_control = 4'd6;
		end
		6'd5: begin
			vga1_control = 5'd0;
			vga2_control = 4'd0;
			vga3_control = 4'd5;
		end
		6'd4: begin
			vga1_control = 5'd0;
			vga2_control = 4'd0;
			vga3_control = 4'd4;
		end
		6'd3: begin
			vga1_control = 5'd0;
			vga2_control = 4'd0;
			vga3_control = 4'd3;
		end
		6'd2: begin
			vga1_control = 5'd0;
			vga2_control = 4'd0;
			vga3_control = 4'd2;
		end
		6'd1: begin
			vga1_control = 5'd0;
			vga2_control = 4'd0;
			vga3_control = 4'd1;
		end
		6'd0: begin
			vga1_control = 5'd0;
			vga2_control = 4'd0;
			vga3_control = 4'd0;
		end
		default: begin
			vga1_control = 5'b10010;
			vga2_control = 4'b1010;
			vga3_control = 4'b1010;
		end
	endcase // gain_array
end
endmodule // mapping_function