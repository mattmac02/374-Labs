module alu_tb;
    reg [31:0] alu_in_a, alu_in_b, brn_flag;
     reg [4:0] op_code;
    wire [63:0] alu_out;
	 
initial
    begin
		  brn_flag <= 0;
        alu_in_a <= 32'd10;
        alu_in_b <= 32'd2;
        #300 op_code <= 5'b10001;

    end
    alu alu_unit(brn_flag, alu_in_a, alu_in_b, op_code, alu_out);
endmodule

//Addition = 5'b00011, Subtraction = 5'b00100, Multiplication = 5'b01110, Division = 5'b01111, Shift_right = 5'b00101, Shift_left = 5'b00110, Rotate_right = 5'b00111, Rotate_left = 5'b01000, 
//Logical_AND = 5'b01001, Logical_OR = 5'b01010, Negate = 5'b10000, Not = 5'b10001