module SelectEncode(
	input [31:0] IR, 
	input Gra, Grb, Grc, Rin, Rout, BAout,
	output [31:0] C_sign_e,
	output 	      R0in, R0out,
						R1in, R1out,
						R2in, R2out,
						R3in, R3out,
						R4in, R4out,
						R5in, R5out,
						R6in, R6out,
						R7in, R7out,
						R8in, R8out,
						R9in, R9out,
						R10in, R10out,
						R11in, R11out,
						R12in, R12out,
						R13in, R13out,
						R14in, R14out,
						R15in, R15out
	);
	
	reg [3:0] OpCode, Ra, Rb, Rc, decoderInput;
	reg [15:0] decoderOutput, out, in;
	reg [31:0] C_sign_extended;
	reg temp;
	integer i;
	
	always @ (*) begin
		OpCode = IR[31:27];
		Ra = IR[26:23];
		Rb = IR[22:19];
		Rc = IR[18:15];
		
		if (Gra == 1) begin
			decoderInput = Ra;
			end
		else if (Grb == 1) begin
			decoderInput = Rb;
			end
		else if (Grc == 1) begin
			decoderInput = Rc;
			end
			
		if(decoderInput == 4'b0000) begin
        decoderOutput = 16'b0000000000000001;
    end
    else if(decoderInput == 4'b0001) begin
        decoderOutput = 16'b0000000000000010;
    end
    else if(decoderInput == 4'b0010) begin
        decoderOutput = 16'b0000000000000100;
    end
    else if(decoderInput == 4'b0011) begin
        decoderOutput = 16'b0000000000001000;
    end
    else if(decoderInput == 4'b0100) begin
        decoderOutput = 16'b0000000000010000;
    end
    else if(decoderInput == 4'b0101) begin
        decoderOutput = 16'b0000000000100000;
    end
    else if(decoderInput == 4'b0110) begin
        decoderOutput = 16'b0000000001000000;
    end
    else if(decoderInput == 4'b0111) begin
        decoderOutput = 16'b0000000010000000;
    end
    else if(decoderInput == 4'b1000) begin
        decoderOutput = 16'b0000000100000000;
    end
    else if(decoderInput == 4'b1001) begin
        decoderOutput = 16'b0000001000000000;
    end
    else if(decoderInput == 4'b1010) begin
        decoderOutput = 16'b0000010000000000;
    end
    else if(decoderInput == 4'b1011) begin
        decoderOutput = 16'b0000100000000000;
    end
    else if(decoderInput == 4'b1100) begin
        decoderOutput = 16'b0001000000000000;
    end
    else if(decoderInput == 4'b1101) begin
        decoderOutput = 16'b0010000000000000;
    end
    else if(decoderInput == 4'b1110) begin
        decoderOutput = 16'b0100000000000000;
    end
    else if(decoderInput == 4'b1111) begin
        decoderOutput = 16'b1000000000000000;
    end
	 else begin 
		decoderOutput = 16'b0000000000000000;
	 end 
			
		for (i=0; i<16; i=i+1) begin
			in[i] = decoderOutput[i] & Rin;
			end
		temp = Rout | BAout;
		for (i=0; i<16; i=i+1) begin
			out[i] = decoderOutput[i] & temp;
			end
		C_sign_extended = {{13{IR[18]}}, {IR[18:0]}};
			
	end
	
		assign {R15in, R14in, R13in, R12in, R11in, R10in, R9in, R8in, R7in, R6in, R5in, R4in, R3in, R2in, R1in, R0in} = in;
		assign {R15out, R14out, R13out, R12out, R11out, R10out, R9out, R8out, R7out, R6out, R5out, R4out, R3out, R2out, R1out, R0out} = out;
		assign  C_sign_e = C_sign_extended;
		
endmodule
		
		

			