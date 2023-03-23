module MAR(input wire clk, clr, MARin, input wire[31:0] BusMuxOut, output [8:0] Q);
	wire [31:0] dataOut;
	
	Registers(.clk(clk), .clr(clr), .D(BusMuxOut), .Q(dataOut), .Rin(MARin));
	
	assign Q = dataOut[8:0];
	
endmodule

	