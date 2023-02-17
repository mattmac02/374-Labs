module rotate_R(
	input [31:0] Ra,
	output [63:0] Rout
	);
	
	assign Rout = {8'h00000000, Ra[0], Ra[31:1]};
endmodule