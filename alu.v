`timescale 1ns/10ps
module alu(
	input [3:0] opCode,
	input [31:0] A, B,
	input flag,
	output [31:0] zOutLow, zOutHigh
);

	reg [31:0] cOut, additional, aValue, bValue;
	wire [63:0] zOut;
	integer i;
	reg temp;
	multiply multiply(.x(A), .y(B), .out(zOut));
	//add add (.Ra(A), .Rb(B), .sum(zOut), .cout(cOut));
	
	
	always @ (opCode) begin
		aValue = A;
		bValue = B;
		case(opCode)
			4'b1101: begin //Add
				cOut = A + B;
			end
			
			4'b0001: begin //Sub
				cOut = A - B;
			end
			
			4'b0010: begin //Mul
				cOut = zOut[31:0];
				additional = zOut[63:32];
			end
			
			4'b0011: begin //Div
				cOut = A / B;
				additional = A % B;
			end
			
			4'b0100: begin //ShL
				for(i=1;i<32;i=i+1) begin
					cOut[i] = A[i-1];
				end
				cOut[0] = 0;
			end
			
			4'b0101: begin //ShR
				for(i=0;i<31;i=i+1) begin
					cOut[i] = B[i+1];
				end
				cOut[31] = 0;
			end
			
			4'b0110: begin //RoL
				for(i=1;i<32;i=i+1) begin
					cOut[i] = A[i-1];
				end
				cOut[0] = A[31];
			end
			
			4'b0111: begin //RoR
				for(i=0;i<31;i=i+1) begin
					cOut[i] = A[i+1];
				end
				cOut[31] = A[0];
			end
			
			4'b1000: begin //And
				for(i=0;i<32;i=i+1) begin
					cOut[i] = A[i] & B[i];
				end 
				//cOut = A & B;
			end 
			
			4'b1001: begin //Or
				for(i=0;i<32;i=i+1) begin
					cOut[i] = A[i] | B[i];
				end
			end
			
			4'b1010: begin //Neg
				for(i=0;i<32;i=i+1) begin
					cOut[i] = ~bValue[i];
				end
				cOut = cOut + 1'b1;
			end
			
			4'b1011: begin //Not
				for(i=0;i<32;i=i+1) begin
					cOut[i] = ~bValue[i];
				end
			end
			4'b1100: begin //SHRA
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
		endcase
	end
	
assign zOutLow = cOut;
assign zOutHigh = additional;
	
endmodule
