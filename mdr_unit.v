module mdr_unit(input [31:0] BusMuxOut, input [31:0] Mdatain, output wire [31:0] Q, read, MDRin, Clock, clear);
	reg[31:0] input_data;

	always @(*)
	begin
	if (read==0)input_data=BusMuxOut[31:0];else
	if (read==1)input_data=Mdatain[31:0];
	end
	
	Registers mdr_reg(.clk(Clock), .clr(clear), .D(input_data), .Q(Q), .Rin(MDRin));

endmodule

