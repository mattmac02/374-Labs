`timescale 1ns / 10ps

module ld_tb; 	
	reg PCout, Zlowout, Zhighout, HIout, LOout, MDRout, In_Portout, Cout; // add any other signals to see in your simulation
	reg MARin, Zin, PCin, MDRin, IRin, Yin, outPortenable, Gra, Grb, Grc, Write, r_in;
	reg IncPC, Read, ConIn, HIin, LOin, Baout;
	reg Clock, clear, CON_enable;
	reg Zin_high, Zin_low;
	reg [31:0] Mdatain;
	reg [31:0] inPort_input;
	wire [31:0] outport_out;
	wire [4:0] operation;
	

parameter	Default = 4'b0000, T0= 4'b0111, T1= 4'b1000,T2= 4'b1001, T3= 4'b1010, T4= 4'b1011, T5= 4'b1100, T6 = 4'b1101, T7 = 4'b1111;
reg	[3:0] Present_state = Default;

DataPath DUT(Gra, Grb, Grc, PCout, Zlowout, Zhighout, HIout, LOout, MDRout, In_Portout, outPortenable, inPortenable, Cout, 
 MARin, PCin, MDRin, IRin, Yin, IncPC, Read,ConIn, Clock,
clear, Zin_high, Zin_low, HIin, LOin, Mdatain, inPort_input, operation, Write, outport_out, Baout, r_in);

initial 
	begin
		clear = 0;
		Clock = 0;
		forever #10 Clock = ~ Clock;
end

always @(negedge Clock)//finite state machine; if clock rising-edge
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
					HIin<=0; LOin<=0; Read<=0; r_in <= 0; PCout <= 0;
					

		end
		T0: begin//see if you need to de-assert these signals	
				 PCout <= 1;
					 MARin <= 1;
					 IncPC <= 1; Zin_high <= 1; Zin_low <= 1;
				
					//#20 PCout <=0; MARin <= 0;
		end
		T1: begin	//loadss RAM output into MDR 		
				MARin <= 0; 
				IncPC <= 0; Zin_high <= 0; Zin_low <= 0;
				#5 Read <= 1;
					 MDRin <= 1; Mdatain <= 1;
					Zlowout<=1;
					//#10 Read <= 0; MDRin <= 0;
		end
		T2: begin
		MDRin<=0; Read<=0;Zlowout<=0; Mdatain <= 0; PCout <= 0;
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
		Zlowout<=0;MARin<=0; Mdatain <=1;
				#5 Read<=1;
				 MDRin <=1;
				//#30 Read<=0;MDRin<=0;
		end
		T7: begin	
		 Read<=0;MDRin<=0; Mdatain <= 0;
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
	