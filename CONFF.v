module CONFF(
input [31:0] BusMuxIn, 
input [31:0] IR, 
input ConIn, 
output branch
);


reg temp;
reg temp2;
reg [3:0] BusMuxInIR;
integer i;
always @(ConIn) begin 
	BusMuxInIR = IR[22:19];
	
	if (BusMuxInIR == 4'b0000) begin
		
		if (BusMuxIn == 0) begin
		
			temp2 = 1;
		
		end
		
		else begin
		
			temp2 = 0;
			
		end
	end
	
	else if (BusMuxIn == 4'b0001) begin
		
		if (BusMuxIn != 0) begin
		
			temp2 = 1;
		
		end
		
		else begin
		
			temp2 = 0;
			
		end
	end
	
	else if (BusMuxIn == 4'b0010) begin
		
		if (BusMuxIn > 0) begin
		
			temp2 = 1;
		
		end
		
		else begin
		
			temp2 = 0;
			
		end
	end
	
	else if (BusMuxInIR == 4'b0011) begin
		
		if (BusMuxIn < 0) begin
		
		temp2 = 1;
		
		end
		
		else begin
		
		temp2 = 0;
			
		end
	end
	
end 
	
assign branch = temp2; 


endmodule 