`timescale 1ns / 10ps
module mdr_unit(input [31:0] BusMuxOut, input [31:0] Mdatain, input read, MDRin, Clock, clear, output wire [31:0] Q);
	reg[31:0] input_data;

	always @(*)
	begin
	if (read==0)input_data=BusMuxOut[31:0];
	else if (read==1)input_data=Mdatain[31:0];
	end
	
	Registers mdr_reg(.clk(Clock), .clr(clear), .D(input_data), .Q(Q), .Rin(MDRin));

endmodule

