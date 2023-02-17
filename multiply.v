module multiply(input signed [31:0] x, y, output[63:0] out);

    reg [2:0] combBits [15:0]; 				
    reg signed [32:0] pProd [15:0];  		
    reg signed [63:0] shiftedPProd [15:0];
	 reg signed [63:0] sumPProd;
	 
	 wire signed[32:0] negX;
	 
	 integer i, j;

	 assign negX = -x;
	 always @ (x or y or negX)
    begin
        combBits[0] = {y[1], y[0], 1'b0};
            
        for(i=1;i<16;i=i+1) begin
             combBits[i] = {y[2*i+1],y[2*i],y[2*i-1]};
        end

        for(i=0;i<16;i=i+1)begin //case check for which bit and whatnot
            case(combBits[i])
                3'b001 , 3'b010 : pProd[i] = {x[31],x};
                
                3'b011 : pProd[i] = {x,1'b0};
                
                3'b100 : pProd[i] = {negX[31:0],1'b0};
                
                3'b101 , 3'b110 : pProd[i] = negX;
                
                default : pProd[i] = 0;
                
            endcase
            
            
            shiftedPProd[i] = pProd[i] << (2*i);  //sign extension 
        end

        sumPProd = shiftedPProd[0];
        
        for(i=1;i<16;i=i+1) begin //add product to tot.
            sumPProd = sumPProd + shiftedPProd[i];
        end
    end
   
    assign out = sumPProd; //after all shifts adne verythig is done, send it out
endmodule