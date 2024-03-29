module DataPath(input Gra, Grb, Grc, PCout, Zlowout, Zhighout, HIout, LOout, MDRout, In_Portout, outPortenable, inPortenable, Cout, 
 MARin, PCin, MDRin, IRin, Yin, IncPC, Read, ConIn, Clock, clear, Zin_high, Zin_low, HIin, 
LOin, input [31:0] Mdatain, input [31:0] inPort_input, output[4:0] operation, input wire Write, output [31:0] outport_out, input wire Baout, input wire r_in);

//add Write and ram_out



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
	wire [31:0] Zlow_data;
	wire [31:0] Zhigh_data;
	wire [31:0] zhigh_2;
	wire [31:0] zlow_2;
	wire [31:0] MDR_data;
	wire [31:0] Ram_out;
	wire [31:0] busmuxout_wire, Hibusmuxout_wire, Lobusmuxout_wire;
	wire [31:0] BusMuxInPort;
	wire brFlag;
	
	wire serout;
	wire [8:0] BusMuxIn_MAR;
	wire [31:0] c_sign;
	
	
	reg [15:0] enableReg;
	reg [15:0] Rout;
	wire [15:0] enableReg_IR, Rout_IR;

	initial begin
		Rout = 16'b0;
		enableReg = 16'b0;
	end

		//sets register enable and out signals based on provided info from IR
		always@(*)begin			
			if (enableReg_IR) enableReg <= enableReg_IR; 
			//else enableReg <= enableReg_CPU;

			if (Rout_IR) Rout <= Rout_IR; 
			else Rout <= 16'b0;	
		end 


	// Registers
	//do we need a register for zlow and zhigh or just z
	wire[31:0] r0Out;
	Registers r0(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(r0Out), .Rin(R0in));
	assign r0_data = {32{!Baout}} & r0Out;
	
	
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
	
	//mdr_unit MDR(.BusMuxOut(busmuxout_wire), .Mdatain(Mdatain), .Q(MDR_data), .read(Read), .MDRin(MDRin), .Clock(Clock), .clear(clear));	// Not sure about this line 
	
	//New MDR Line
	mdr_unit mdr_unit(.BusMuxOut(busmuxout_wire), .Mdatain(Ram_out), .read(Read), .MDRin(MDRin), .Clock(Clock), .clear(clear), .Q(MDR_data));
	
	Registers HI(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(HI_data), .Rin(HIin));
	Registers LO(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(LO_data), .Rin(LOin));
	Registers Y(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(Y_data), .Rin(Yin));
	Registers Zhigh(.clk(Clock), .clr(clear), .D(Hibusmuxout_wire), .Q(Zhigh_data), .Rin(Zin_high));
	Registers Zlow(.clk(Clock), .clr(clear), .D(Lobusmuxout_wire), .Q(Zlow_data), .Rin(Zin_low));
	Registers inport(.clk(Clock), .clr(clear), .D(inPort_input), .Q(BusMuxInPort), .Rin(inPortenable));
	Registers outport(.clk(Clock), .clr(clear), .D(busmuxout_wire), .Q(outport_out), .Rin(outPortenable));
	
	
	//Select and Encode
	//selectandencoder selectandencoder(.IRin(IR_data), .Gra(Gra), .Grb(Grb), .Grc(Grc), .Rin(r_in), .Rout(serout), .BAout(Baout), .opcode(operation), .C_sign_extended(c_sign), .RegIn(enableReg_IR), .RegOut(Rout_IR));
	
	
	//CONFF
	CONFF CONFF(.branch(brFlag), .ConIn(ConIn), .IR(IR_data), .BusMuxIn(busmuxout_wire));
	
	SelectEncode sel(.IR(IR_data), .Gra(Gra), .Grb(Grb), .Grc(Grc), .Rin(r_in), .Rout(serout), .BAout(Baout), .C_sign_e(c_sign), .R0in(R0in), 
			 .R0out(R0out), .R1in(R1in), .R1out(R1out), .R2in(R2in), .R2out(R2out), .R3in(R3in), .R3out(R3out), .R4in(R4in), .R4out(R4out),
			 .R5in(R5in), .R5out(R5out), .R6in(R6in), .R6out(R6out), .R7in(R7in), .R7out(R7out), .R8in(R8in), .R8out(R8out), .R9in(R9in), 
			 .R9out(R9out), .R10in(R10in), .R10out(R10out), .R11in(R11in), .R11out(R11out), .R12in(R12in), .R12out(R12out), .R13in(R13in), 
			 .R13out(R13out), .R14in(R14in), .R14out(R14out), .R15in(R15in), .R15out(R15out));
	
	//MAR unit
	marUnit marUnit(.clk(Clock), .clr(clear), .MARin(MARin), .BusMuxOut(busmuxout_wire), .Q(BusMuxIn_MAR));

	RamFinal ram(.address(BusMuxIn_MAR), .clock(Clock), .data(MDR_data), .wren(Write), .q(Ram_out));
	//memRam RAM(.dataIn(BusMuxIn_MDR), .address(BusMuxIn_MAR), .we(Ram_enable), .clk(Clock), .dataOut(Ram_out))
	
	
	//Bus Connection
	wire [4:0] select;
	/* encoder encoder(.Sout(select), .Registers({R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, 
	R14in, R15in, PCout, Zlowout, Zhighout, MDRin, HIout, LOout, MDRout, In_Portout, Cout, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0})); */
	
	encoder encoder(.Sout(select), .register({ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, Cout, In_Portout, MDRout, LOout, HIout, 
	Zhighout, Zlowout, PCout, R15out, R14out, R13out, R12out, R11out, R10out, R9out, R8out, R7out, R6out, R5out, R4out, R3out, R2out, R1out, R0out})); 
	
	
	//do again for mux
	//wire [4:0] operation;

	Mux_32_1_if Mux_32_1_if(.BusMuxIn_R0(r0_data) , .BusMuxIn_R1(r1_data) , .BusMuxIn_R2(r2_data) , .BusMuxIn_R3(r3_data) , .BusMuxIn_R4(r4_data), 
	.BusMuxIn_R5(r5_data) ,.BusMuxIn_R6(r6_data) ,.BusMuxIn_R7(r7_data) ,.BusMuxIn_R8(r8_data) ,.BusMuxIn_R9(r9_data) ,
				.BusMuxIn_R10(r10_data), .BusMuxIn_R11(r11_data),
	.BusMuxIn_R12(r12_data), .BusMuxIn_R13(r13_data), .BusMuxIn_R14(r14_data), .BusMuxIn_R15(r15_data), .BusMuxIn_HI(HI_data),
				.BusMuxIn_LO(LO_data), .BusMuxIn_Zhigh(Zhigh_data), 
	.BusMuxIn_Zlow(Zlow_data), 
	.BusMuxIn_PC(PC_data), 
	.BusMuxIn_MDR(MDR_data), 
	.BusMuxIn_InPort(BusMuxInPort), 
	.C_sign_ext(c_sign),
	.BusMuxOut(busmuxout_wire),
	.Sout(select));
	
	//FIX (split RC into 2 32 bit registers)
	//or would it be mdatain bc in dqatapath_tb the mdatain is where the opcode is
	alu alu(.operation(IR_data), .A(Y_data), .B(busmuxout_wire), .flag(brFlag), .zOutLow(Lobusmuxout_wire), .zOutHigh(Hibusmuxout_wire));
	endmodule
	
