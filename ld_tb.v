`timescale 1ns / 10ps

module ld_tb; 	
	reg PCout, Zlowout, Zhighout, HIout, LOout, MDRout, In_Portout, Cout, R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out,R13out, R14out, R15out; // add any other signals to see in your simulation
	reg MARin, Zin, PCin, MDRin, IRin, Yin, outPortenable, Gra, Grb, Grc, Write, r_in;
	reg IncPC, Read, ConIn, R0in, R1in, R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in, HIin, LOin, Baout;
	reg Clock, clear, CON_enable;
	reg Zin_high, Zin_low;
	reg [31:0] Mdatain;
	reg [31:0] inPort_input;
	wire [31:0] outport_out;
	wire [4:0] operation;
	

parameter	Default = 4'b0000, Reg_load1a= 4'b0001, Reg_load1b= 4'b0010,
					Reg_load2a = 4'b0011, Reg_load2b = 4'b0100, Reg_load3a = 4'b0101,
					Reg_load3b = 4'b0110, T0= 4'b0111, T1= 4'b1000,T2= 4'b1001, T3= 4'b1010, T4= 4'b1011, T5= 4'b1100, T6 = 4'b1101, T7 = 4'b1111;
reg	[3:0] Present_state = Default;

DataPath DUT(Gra, Grb, Grc, PCout, Zlowout, Zhighout, HIout, LOout, MDRout, In_Portout, outPortenable, inPortenable, Cout, 
R0out, R1out, R2out, R3out, R4out, R5out, R6out, R7out, R8out, R9out, R10out, R11out, R12out,
R13out, R14out, R15out, MARin, PCin, MDRin, IRin, Yin, IncPC, Read,ConIn, R0in, R1in,
R2in, R3in, R4in, R5in, R6in, R7in, R8in, R9in, R10in, R11in, R12in, R13in, R14in, R15in, Clock,
clear, Zin_high, Zin_low, HIin, LOin, Mdatain, inPort_input, operation, Write, outport_out, Baout, r_in);

initial 
	begin
		clear = 0;
		Clock = 0;
		forever #10 Clock = ~ Clock;
		#500 $finish;
end

always @(posedge Clock)//finite state machine; if clock rising-edge
begin
	case (Present_state)
		Default			:	#40 Present_state = T0;
		T0					:	#40 Present_state = T1;
		T1					:	#40 Present_state = T2;
		T2					:	#40 Present_state = T3;
		T3					:	#40 Present_state = T4;
		T4					:	#40 Present_state = T5;
		T5					:	#40 Present_state = T6;
		T6					:	#40 Present_state = T7;
		endcase
	end

always @(Present_state)// do the required job in each state
begin
	case (Present_state)              //assert the required signals in each clock cycle
				Default: begin	//initialize all signals
					Zlowout <= 0; MDRout <= 0; 
					MARin <= 0; Zin_high <= 0; Zin_low <= 0; CON_enable<=0; 
					outPortenable<=0; inPort_input<=32'd0;
					MDRin <= 0; IRin <= 0;Yin <= 0; Write<=0;
					Gra<=0; Grb<=0; Grc<=0;
				   Baout<=0; Cout<=0; In_Portout<=0; Zhighout<=0; LOout<=0; HIout<=0; 
					HIin<=0; LOin<=0; Read<=0; r_in <= 0;
					

		end
		T0: begin//see if you need to de-assert these signals	
				#5 PCout <= 1;
					 MARin <= 1;
					//#20 PCout <=0; MARin <= 0;
		end
		T1: begin	//loadss RAM output into MDR 	
				PCout <=0; MARin<=0;		
				#5 Read <= 1;
					 MDRin <= 1;
					Zlowout<=1;
					//#10 Read <= 0; MDRin <= 0;
		end
		T2: begin
		MDRin<=0; Read<=0;Zlowout<=0;
			MDRout <= 1; IRin <= 1;
				#10 MDRout <= 1; IRin <=1;PCin<=1;
		end
		T3: begin
		IRin<=0;MDRout<=0;
			Grb<=1;
			Baout <=1;
			#5 Yin<=1;
				//#20 Grb<=0;Baout<=0;Yin<=0;
		end
		T4: begin
		Grb<=0;Baout<=0;Yin<=0;
			Cout<=1;
			#5 Zin_high<=1; Zin_low<=1;
				//#20 Cout<=0; Zin_high<= 0; Zin_low<=0;
		end
		T5: begin
		Cout<=0; Zin_high<= 0; Zin_low<=0;
				Zlowout <=1;
				#5 MARin <=1;
					//#20 Zlowout<=0;MARin<=0;
		end
		T6: begin
		Zlowout<=0;MARin<=0;
				#5 Read<=1;
				 MDRin <=1;
				//#30 Read<=0;MDRin<=0;
		end
		T7: begin	
		 Read<=0;MDRin<=0;
			MDRout<=1;
			#5 Gra<=1;
			r_in<=1;
		end
	endcase
end

endmodule

//Addition = 5'b00011, Subtraction = 5'b00100, Multiplication = 5'b01110, Division = 5'b01111, Shift_right = 5'b00101, Shift_left = 5'b00110, Rotate_right = 5'b00111, Rotate_left = 5'b01000, 
//Logical_AND = 5'b01001, Logical_OR = 5'b01010, Negate = 5'b10000, Not = 5'b10001
//addi = 5'b01011, andi = 5'b01100, ori = 5'b01101, ldw = 5'b00000, ldwi = 5'b00001, stw = 5'b00010,
//branch = 5'b10010, jr = 5'b10011, jal = 5'b10100, mfhi = 5'b10111, mflo = 5'b11000, in = 5'b10101, out = 5'b10110, nop = 5'b11001, halt = 5'b11010;
	