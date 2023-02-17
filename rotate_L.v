module rotate_L(input [31:0] Ra, output [63:0] Rout);
	assign Rout = {8'h00000000, Ra[30:0], Ra[31]};
endmodule