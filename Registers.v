module Registers(clk, clr, D, Q, Rin);
	input [31:0] D;
	input clk, clr, Rin;
	output [31:0] Q;
	reg [31:0] Q;
	
	always @(posedge clr) begin
		if(clr == 0) begin
			Q <= 0;
	
		end
   end                                                   
	
	always @(posedge clk)
	begin
		Q <= D;
	end
endmodule
