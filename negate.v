module negate(input [31:0] in, output [31:0] negatedValue);
assign negatedValue = (~in)+1;
endmodule