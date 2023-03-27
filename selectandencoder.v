module selectandencoder(
input [31:0] IRin,
input Gra, Grb, Grc, Rin, Rout, BAout,
output [4:0] opcode,
output [31:0] C_sign_extended,
output [15:0] RegIn, RegOut
);

 wire [3:0] Ra, Rb, Rc, out0;
 reg[16:0] out;
 
 assign Ra[3] = IRin[26] & Gra;
 assign Ra[2] = IRin[25] & Gra;
 assign Ra[1] = IRin[24] & Gra;
 assign Ra[0] = IRin[23] & Gra;

 assign Rb[3] = IRin[22] & Grb;
 assign Rb[2] = IRin[21] & Grb;
 assign Rb[1] = IRin[20] & Grb;
 assign Rb[0] = IRin[19] & Grb;
 
 assign Rc[3] = IRin[18] & Grc;
 assign Rc[2] = IRin[17] & Grc;
 assign Rc[1] = IRin[16] & Grc;
 assign Rc[0] = IRin[15] & Grc;
 
 assign out0 = Ra | Rb | Rc;
 
 always @ (*)
 begin
  case(out0)
	4'b0000 :  out = 16'b0000000000000001;
	4'b0001 :  out = 16'b0000000000000010;
	4'b0010 :  out = 16'b0000000000000100; 
	4'b0011 :  out = 16'b0000000000001000;
	4'b0100 :  out = 16'b0000000000010000;
	4'b0101 :  out = 16'b0000000000100000;
	4'b0110 :  out = 16'b0000000001000000;
	4'b0111 :  out = 16'b0000000010000000;
	4'b1000 :  out = 16'b0000000100000000;
	4'b1001 :  out = 16'b0000001000000000;
	4'b1010 :  out = 16'b0000010000000000;
	4'b1011 :  out = 16'b0000100000000000;
	4'b1100 :  out = 16'b0001000000000000;
	4'b1101 :  out = 16'b0010000000000000;
	4'b1110 :  out = 16'b0100000000000000;
	4'b1111 :  out = 16'b1000000000000000;
   default :  out = 16'bx;
 endcase
 end
	 assign RegOut[15] = out[15] & (Rout | BAout);
	 assign RegOut[14] = out[14] & (Rout | BAout);
	 assign RegOut[13] = out[13] & (Rout | BAout);
	 assign RegOut[12] = out[12] & (Rout | BAout);
	 assign RegOut[11] = out[11] & (Rout | BAout);
	 assign RegOut[10] = out[10] & (Rout | BAout);
	 assign RegOut[9] = out[9] & (Rout | BAout);	
	 assign RegOut[8] = out[8] & (Rout | BAout);
	 assign RegOut[7] = out[7] & (Rout | BAout);
	 assign RegOut[6] = out[6] & (Rout | BAout);
	 assign RegOut[5] = out[5] & (Rout | BAout);
	 assign RegOut[4] = out[4] & (Rout | BAout);
	 assign RegOut[3] = out[3] & (Rout | BAout);
	 assign RegOut[2] = out[2] & (Rout | BAout); 
	 assign RegOut[1] = out[1] & (Rout | BAout);
	 assign RegOut[0] = out[0] & (Rout | BAout); 
	 
	 assign RegIn[15] = out[15] & Rin;
	 assign RegIn[14] = out[14] & Rin;
	 assign RegIn[13] = out[13] & Rin;
	 assign RegIn[12] = out[12] & Rin;
	 assign RegIn[11] = out[11] & Rin;
	 assign RegIn[10] = out[10] & Rin;
	 assign RegIn[9] = out[9] & Rin;
	 assign RegIn[8] = out[8] & Rin;
	 assign RegIn[7] = out[7] & Rin;
	 assign RegIn[6] = out[6] & Rin;
	 assign RegIn[5] = out[5] & Rin;
	 assign RegIn[4] = out[4] & Rin;
	 assign RegIn[3] = out[3] & Rin;
	 assign RegIn[2] = out[2] & Rin;
	 assign RegIn[1] = out[1] & Rin;
	 assign RegIn[0] = out[0] & Rin;
	 
	 assign opcode = IRin[31:27];
	 
	 assign C_sign_extended = {{13{IRin[18]}},IRin[18:0]};
endmodule