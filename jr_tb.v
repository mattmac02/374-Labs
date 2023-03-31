`timescale 1ns/10ps

module jr_tb;
    reg PCout, Zlowout, Zhighout, HIout, LOout, MDRout, In_Portout, Cout; // add any other signals to see in your simulation
    reg MARin, Zin, PCin, MDRin, IRin, Yin, outPortenable, Gra, Grb, Grc, Write, r_in;
    reg IncPC, Read, ConIn, HIin, LOin, Baout;
    reg Clock, clear, CON_enable;
    reg Zin_high, Zin_low;
    reg [31:0] Mdatain;
    reg [31:0] inPort_input;
    wire [31:0] outport_out;
    wire [4:0] operation;

    parameter   Default = 4'b0000, T0= 4'b0111,T1= 4'b1000,T2= 4'b1001, T3= 4'b1010;
    reg[3:0] Present_state= Default;

DataPath DUT(Gra, Grb, Grc, PCout, Zlowout, Zhighout, HIout, LOout, MDRout, In_Portout, outPortenable, inPortenable, Cout,  MARin, PCin, MDRin, IRin, Yin, IncPC, Read,ConIn, Clock,
clear, Zin_high, Zin_low, HIin, LOin, Mdatain, inPort_input, operation, Write, outport_out, Baout, r_in);



initial begin
	clock = 0;
	forever #10 clock = ~clock; 
end 


always @(posedge clock)     //finite state machine; if clk rising-edge
    begin
        case (Present_state)
            Default     :   #60 Present_state = T0;
            T0          :   #60 Present_state = T1;
            T1          :   #60 Present_state = T2;
            T2          :   #60 Present_state = T3;
        endcase
    end
    
always @(Present_state)     // do the required job ineach state
    begin
        case (Present_state)              //assert the required signals in each clk cycle
            Default: begin
                PCout <= 0;   Zlowout <= 0;   MDRout<= 0;   //initialize the signals
                MARin <= 0;   Zin <= 0; Write <= 0; clear <= 0;
                PCin <=0;   MDRin <= 0;   IRin  <= 0;   Yin <= 0;  
                incPC <= 0;   Read <= 0; CONin <= 0;
                Gra<= 0; Grb<= 0; Grc<= 0; Rin<= 0; Rout<= 0; BAout<= 0; Cout<=0;
            end
           
            T0: begin 
                //load value in PC register (0) in MAR
                PCout <= 1; 
					 #5 MARin <= 1;  incPC <= 1; Zin <= 1;
					 #20 PCout <= 0; MARin <= 0; incPC <= 0; Zin <= 0;
            end
            T1: begin
                //Zlowout <= 1; PCin <= 1; 
                
                //MDR will grab value from ram @ address 0, this address should contain instruction
                #5 Read <= 1; 
					 #5 MDRin <= 1;
					 #20 Read <= 0; MDRin <= 0;
        
            end
            T2: begin
                //load MDR value to bus which contains instruction, instruction is then stored in IR
                MDRout<= 1; IRin <= 1; 
					 #20 MDRout <= 0; IRin <= 0;
            end

            T3: begin 
                Gra <= 1;
                Rout <= 1;
                #10 PCin <= 1; 
					 #20 Gra <= 0; Rout <= 0; PCin <= 0;
            end 
        endcase
    end
endmodule 