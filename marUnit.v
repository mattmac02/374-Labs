module marUnit(input wire clk, clr, input [31:0] MARin, input wire[31:0] BusMuxOut, output [8:0] Q);
	wire [31:0] dataOut;
	
	Registers marUnit(.clk(clk), .clr(clr), .D(BusMuxOut), .Q(dataOut), .Rin(MARin));
	
	assign Q = dataOut[8:0];
	
endmodule

	