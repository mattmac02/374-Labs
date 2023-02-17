module DataPath(input PCout, Zlowout, Zhighout, HIout, LOout, MDRout, In_Portout, Cout, 
R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out,
R13out, R14out, R15out, MARin, Zin_high, Zin_low, PCin, MDRin, IRin, Yin, IncPC, Read, AND, R0in, R1in,
R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in, Clock, Mdatain, clear);

	// Wires for connecting
	wire [31:0] r0_data;
	wire [31:0] r1_data;
	wire [31:0] r2_data;
	wire [31:0] r3_data;
	wire [31:0] r4_data;
	wire [31:0] r5_data;
	wire [31:0] r6_data;
	wire [31:0] r7_data;
	wire [31:0] r8_data;
	wire [31:0] r9_data;
	wire [31:0] r10_data;
	wire [31:0] r11_data;
	wire [31:0] r12_data;
	wire [31:0] r13_data;
	wire [31:0] r14_data;
	wire [31:0] r15_data;
	wire [31:0] IR_data;
	wire [31:0] PC_data;
	wire [31:0] HI_data;
	wire [31:0] LO_data;
	wire [31:0] Y_data;
	wire [31:0] Z_data;
	wire [31:0] MDR_data;

	// Registers
	//do we need a register for zlow and zhigh or just z
	
	Registers r0(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(r0_data), .Rin(R0in));
	Registers r1(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(r1_data), .Rin(R1in));
	Registers r2(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(r2_data), .Rin(R2in));
	Registers r3(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(r3_data), .Rin(R3in));
	Registers r4(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(r4_data), .Rin(R4in));
	Registers r5(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(r5_data), .Rin(R5in));
	Registers r6(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(r6_data), .Rin(R6in));
	Registers r7(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(r7_data), .Rin(R7in));
	Registers r8(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(r8_data), .Rin(R8in));
	Registers r9(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(r9_data), .Rin(R9in));
	Registers r10(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(r10_data), .Rin(R10in));
	Registers r11(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(r11_data), .Rin(R11in));
	Registers r12(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(r12_data), .Rin(R12in));
	Registers r13(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(r13_data), .Rin(R13in));
	Registers r14(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(r14_data), .Rin(R14in));
	Registers r15(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(r15_data), .Rin(R15in));
	Registers IR(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(IR_data), .Rin(IRin));
	Registers PC(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(PC_data), .Rin(PCin));
	
	mdr_unit MDR(.BusMuxOut(busmuxout_wire), .Mdatain(Mdatain), .Q(MDR_data), .read(Read), .MDRin(MDRin), .Clock(clock), .clear(clear));	// Not sure about this line 
	
	Registers HI(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(HI_data), .Rin(HIin));
	Registers LO(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(LO_data), .Rin(LOin));
	Registers Y(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(Y_data), .Rin(Yin));
	Registers Zhigh(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(Z_data), .Rin(Zin_high));
	Registers Zlow(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(Z_data), .Rin(Zin_low));
	
	
	//Bus Connection
	wire [4:0] select;
	encoder encoder(.Sout(select), .Registers({R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out, R13out, 
	R14out, R15out, PCout, Zlowout, Zhighout, MDRout, HIout, LOout, MDRout, In_Portout, Cout, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}));
	
	
	//do again for mux
	wire [31:0] busmuxout_wire;
	wire [31:0] test1;
	wire [31:0] test2;

	Mux_32_1_if Mux_32_1_if(.BusMuxOut(busmuxout_wire), .BusMuxIn_R0(r0_data) , .BusMuxIn_R1(r1_data) ,.BusMuxIn_R2(r2_data) ,.BusMuxIn_R3(r3_data) ,.BusMuxIn_R4(r4_data), 
	.BusMuxIn_R5(r5_data) ,.BusMuxIn_R6(r6_data) ,.BusMuxIn_R7(r7_data) ,.BusMuxIn_R8(r8_data) ,.BusMuxIn_R9(r9_data) ,.BusMuxIn_R10(r10_data), .BusMuxIn_R11(r11_data),
	.BusMuxIn_R12(r12_data), .BusMuxIn_R13(r13_data), .BusMuxIn_R14(r14_data), .BusMuxIn_R15(r15_data), .BusMuxIn_HI(HI_data), .BusMuxIn_LO(LO_data), .BusMuxIn_Zhigh(Zin_high), 
	.BusMuxIn_Zlow(Zin_low), 
	.BusMuxIn_PC(PC_data), 
	.BusMuxIn_MDR(MDR_data), 
	.BusMuxIn_InPort(test2), 
	.C_sign_ext(test1),
	.Sout(select));
	endmodule
	