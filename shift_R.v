module shift_R(input [31:0] in, output [31:0] shiftedValue);
assign shifted = in >> 32'b1;
endmodule 