module memRam(input [31:0] dataIn, input [7:0] address, input we, clk,output [31:0] dataOut);
			reg [31:0] ram[511:0];
			reg [31:0] addressRegister;

			initial begin : INIT
					$readmemh("Mif1.mif", ram);
			end
			
			always@(posedge clk)
			begin
				if (we)
						ram[address] <= dataIn;
				addressRegister <= address;
			end
			assign dataOut = ram[addressRegister];
endmodule
