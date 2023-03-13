// and datapath_tb.v file: <This is the filename>
`timescale 1ns/10ps
module div_tb;
	reg PCout, Zlowout, Zhighout, HIout, LOout, MDRout, In_Portout, Cout, R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out,R13out, R14out, R15out; // add any other signals to see in your simulation
	reg MARin, Zin, PCin, MDRin, IRin, Yin;
	reg IncPC, Read, ADD, R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in, HIin, LOin;
	reg Clock, clear;
	reg Zin_high, Zin_low;
	reg [31:0] Mdatain;
	reg [3:0] operation;
	
	parameter	Default = 4'b0000, Reg_load1a = 4'b0001, Reg_load1b = 4'b0010, Reg_load2a = 4'b0011,
					Reg_load2b = 4'b0100, Reg_load3a = 4'b0101, Reg_load3b = 4'b0110, T0 = 4'b0111,
					T1 = 4'b1000, T2 = 4'b1001, T3 = 4'b1010, T4 = 4'b1011, T5 = 4'b1100, T6 = 4'b1101;
	reg [3:0] Present_state = Default;
	
DataPath DUT(PCout, Zlowout, Zhighout, HIout, LOout, MDRout, In_Portout, Cout, 
R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out,
R13out, R14out, R15out, MARin, PCin, MDRin, IRin, Yin, IncPC, Read, R0in, R1in,
R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in, Clock,
clear, Zin_high, Zin_low, HIin, LOin, Mdatain, operation);

// add test logic here
initial
	begin
		Clock = 0;
end

always begin
		#10 Clock = ~ Clock;
end

always @(posedge Clock) // finite state machine; if clock rising-edge
		begin
		case (Present_state)
					Default     :   #40 Present_state = Reg_load1a;
					Reg_load1a  :   #40 Present_state = Reg_load1b;
					Reg_load1b  :   #40 Present_state = Reg_load2a;
					Reg_load2a  :   #40 Present_state = Reg_load2b;
					Reg_load2b  :   #40 Present_state = Reg_load3a;
					Reg_load3a  :   #40 Present_state = Reg_load3b;
					Reg_load3b  :   #40 Present_state = T0;
					T0          :   #40 Present_state = T1;
					T1          :   #40 Present_state = T2;
					T2          :   #40 Present_state = T3;
					T3          :   #40 Present_state = T4;
					T4          :   #40 Present_state = T5;
					T5				:	 #40 Present_state = T6;
		endcase
	end

	always @(Present_state) // do the required job in each state
		begin
		case (Present_state) // assert the required signals in each clock cycle
			Default: begin
				PCout <= 0; clear <= 0; Zlowout <= 0; Zhighout <= 0; Cout <= 0; In_Portout <= 0; MDRout <= 0; LOout <= 0 ; HIout <= 0; // initialize the signals
					{R15out, R14out, R13out, R12out, R11out, R10out, R9out, R8out, R7out, R6out, R5out, R4out, R3out, R2out, R1out, R0out} <= 0; MARin <= 0; Zin <= 0;
					PCin <=0; MDRin <= 0; IRin <= 0; Yin <= 0;
					IncPC <= 0; Read <= 0; ADD <= 0; operation <= 00000;
					R0in  <= 0; R1in <= 0; R2in <= 0; R3in <= 0;
					R4in <= 0; R5in <= 0; R6in <= 0; R7in <= 0; HIin <= 0; LOin <= 0;
					R1in <= 0; R2in <= 0; R3in <= 0;	Mdatain <= 32'h00000000;
			end
			Reg_load1a: begin
				Mdatain <= 32'd0000003;
				Read = 0; MDRin = 0; // the first zero is there for completeness
				#10 Read <= 1; MDRin <= 1;
				#15 Read <= 0; MDRin <= 0;
			end
			Reg_load1b: begin
				#10 MDRout <= 1; R6in <= 1;
				#15 MDRout <= 0; R6in <= 0; 
			end
			Reg_load2a: begin
				Mdatain <= 32'd00000002;
				#10 Read <= 1; MDRin <= 1; 
				#15 Read <= 0; MDRin <= 0;
			end
			Reg_load2b: begin
				#10 MDRout <= 1; R7in <= 1;
				#15 MDRout <= 0; R7in <= 0; 
			end
			T0: begin // see if you need to de-assert these signals
				PCout <= 1; MARin <= 1; IncPC <= 1; Zin_low <= 1; Zin_high <= 1;
				#15 PCout <= 0; MARin <= 0; IncPC <= 0; Zin_low <= 0;
			end
			T1: begin
				Zlowout <= 1; PCin <= 1; Read <= 1; MDRin <= 1;
				Mdatain <= 32'h1E918000; // opcode for “mul R6, R7”
				#15 Zlowout <= 0; PCin <= 0; Read <= 0; MDRin <= 0;
			end
			T2: begin
				MDRout <= 1; IRin <= 1;
				#15 MDRout <= 0; IRin <= 0;
			end
			T3: begin
				#10 R6out <= 1; Yin <= 1;
				#15 R6out <= 0; Yin <= 0;
			end
			T4: begin
				R7out <= 1;
				#5 operation <= 4'b0011; // Div 
				#5 Zin_low <= 1; Zin_high <= 1;
				#10 Zin_low <= 0; Zin_high <=0; R7out <= 0; 
			end
			T5: begin
				Zlowout <= 1; LOin <= 1;
			end
			T6: begin
				Zhighout <= 1; HIin <= 1;
			end
		endcase
	end
	endmodule
	