`timescale 1ns/10ps
module alu(
	input [31:0] operation,
	input [31:0] A, B,
	input flag,
	output [31:0] zOutLow, zOutHigh
);
	reg [4:0] opCode;
	reg [31:0] cOut, additional, aValue, bValue;
	wire [63:0] zOut;
	integer i;
	reg temp;
	multiply multiply(.x(A), .y(B), .out(zOut));
	//add add (.Ra(A), .Rb(B), .sum(zOut), .cout(cOut));

	
	always @ (*) begin
		opCode = operation[31:27];
		aValue = A;
		bValue = B;
		case(opCode)
			5'b00011: begin //Add
				cOut = A + B;
			end
			
			5'b00100: begin //Sub
				cOut = A - B;
			end
			
			5'b01111: begin //Mul
				cOut = zOut[31:0];
				additional = zOut[63:32];
			end
			
			5'b10000: begin //Div
				cOut = A / B;
				additional = A % B;
			end
			
			5'b01001: begin //ShL
				for(i=1;i<32;i=i+1) begin
					cOut[i] = A[i-1];
				end
				cOut[0] = 0;
			end
			
			5'b00111: begin //ShR
				for(i=0;i<31;i=i+1) begin
					cOut[i] = B[i+1];
				end
				cOut[31] = 0;
			end
			
			5'b01011: begin //RoL
				for(i=1;i<32;i=i+1) begin
					cOut[i] = A[i-1];
				end
				cOut[0] = A[31];
			end
			
			5'b01010: begin //RoR
				for(i=0;i<31;i=i+1) begin
					cOut[i] = A[i+1];
				end
				cOut[31] = A[0];
			end
			
			5'b00101: begin //And
				for(i=0;i<32;i=i+1) begin
					cOut[i] = A[i] & B[i];
				end 
				//cOut = A & B;
			end 
			
			5'b00110: begin //Or
				for(i=0;i<32;i=i+1) begin
					cOut[i] = A[i] | B[i];
				end
			end
			
			5'b10001: begin //Neg
				for(i=0;i<32;i=i+1) begin
					cOut[i] = ~bValue[i];
				end
				cOut = cOut + 1'b1;
			end
			
			5'b10010: begin //Not
				for(i=0;i<32;i=i+1) begin
					cOut[i] = ~bValue[i];
				end
			end
			5'b01000: begin //SHRA
				temp = A[31];
				for(i=0;i<31;i=i+1) begin
					cOut[i] = A[i+1];
				end
				cOut[31] = temp;
			end
			5'b10011:begin
			if(flag==1)begin
				cOut=A+B;
				end
			else begin
				cOut=A;
				end
				end
			5'b00000:begin //load
				cOut[31:0] <= A + B;
				//cOut[31:0] <= 5'd50000;
				additional[31:0] <= 32'd0;
			end
			5'b00001:begin //loadi
				cOut[31:0] <= A + B;
				additional[31:0] <= 32'd0;
				end
			5'b00010:begin//store
				cOut[31:0] <= A + B;
				additional[31:0] <= 32'd0;
				end
			5'b01100:begin //addi
				cOut[31:0] <= A + B;
				additional[31:0] <= 32'd0;
				end
		endcase
	end
	
assign zOutLow = cOut;
assign zOutHigh = additional;
	
endmodule
