module Registers #(parameter qInitial = 0)(clk, clr, D, Q, Rin);
	input [31:0] D;
	input clk, clr, Rin;
	output [31:0] Q;
	reg [31:0] Q;                                                 
	
	always @(posedge clk)
	begin
		if(Rin) 
		Q <= D;
		else if(clr == 1) 
			Q <= 0;
	end
endmodule
