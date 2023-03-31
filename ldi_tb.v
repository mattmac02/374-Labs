`timescale 1ns / 10ps

module ldi_tb; 	
	reg PCout, Zlowout, Zhighout, HIout, LOout, MDRout, In_Portout, Cout; // add any other signals to see in your simulation
	reg MARin, Zin, PCin, MDRin, IRin, Yin, outPortenable, Gra, Grb, Grc, Write, r_in;
	reg IncPC, Read, ConIn, HIin, LOin, Baout;
	reg Clock, clear, CON_enable;
	reg Zin_high, Zin_low;
	reg [31:0] Mdatain;
	reg [31:0] inPort_input;
	wire [31:0] outport_out;
	wire [4:0] operation;
	

parameter	Default = 4'b0000, T0= 4'b0111, T1= 4'b1000,T2= 4'b1001, T3= 4'b1010, T4= 4'b1011, T5= 4'b1100;

DataPath DUT(Gra, Grb, Grc, PCout, Zlowout, Zhighout, HIout, LOout, MDRout, In_Portout, outPortenable, inPortenable, Cout,  MARin, PCin, MDRin, IRin, Yin, IncPC, Read,ConIn, Clock,
clear, Zin_high, Zin_low, HIin, LOin, Mdatain, inPort_input, operation, Write, outport_out, Baout, r_in);

initial 
	begin
		clear = 0;
		Clock = 0;
		forever #10 Clock = ~ Clock;
end

always @(posedge Clock)//finite state machine; if clock rising-edge
begin
	case (Present_state)
		Default			:	#60 Present_state = T0;
		T0					:	#60 Present_state = T1;
		T1					:	#60 Present_state = T2;
		T2					:	#60 Present_state = T3;
		T3					:	#60 Present_state = T4;
		T4					:	#60 Present_state = T5;
		T5					:	#60 Present_state = T6;
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
				#5 PCout <= 1; 
					 #5 MARin <= 1;  //incPC <= 1; Zin <= 1; used to inc PC by 4
					 #20 PCout <= 0; MARin <= 0;
		end
		T1: begin	//loadss RAM output into MDR 		
				#5 Read <= 1; 
					 #5 MDRin <= 1;
					 #20 Read <= 0; MDRin <= 0;
		end
		T2: begin
		MDRout<= 1; IRin <= 1; 
					 #20 MDRout <= 0; IRin <= 0;		end
		T3: begin
		//select R0out since Rb = 0000
                Grb <= 1;
                //set to 1 to generate R0out = 1 and store value of R0 (0) into Y register
                BAout <= 1;
                #10 Yin <= 1; 
					 #20 Grb <= 0; BAout <= 0; Yin <= 0;
		end
		T4: begin
				//store C sign extended value on bus (should be 85 decimal)
                Cout <=1; 
                //perform add between 85/BuxMuxOut + R0 (0)/BuxMuxInY	
                //store result in Z register
                #10 Zin <=1;
					 #20 Cout <= 0; Zin <= 0;
		end
		T5: begin
		 //store Z register contents (80) in bus
                Zlowout <= 1;
                //load 85/busMuxOut into MAR to get address of 85
                #5 Gra <= 1; Rin <= 1;
					 #20 Zlowout <= 0; Gra <= 0; Rin <= 0;
		end
	endcase
end
endmodule


	