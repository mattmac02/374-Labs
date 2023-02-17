module divide(input [31:0] dividend, divisor, output reg [31:0] quotient);
    reg [31:0] m, q;
    reg [32:0] a;
    integer i;

    always @ (*)
    begin
        begin
        q = dividend;
        m = divisor;
        a = 0;
        for(i = 0; i < 32; i = i+1)
        begin
            a = {a[30:0], q[31]};
            q[31:1] = q[30:0];
            a = a - m;

            if(a[31] == 1)
            begin
                q[0] = 0;
                a = a + m;
            end
            else
            begin
                q[0] = 1;
            end
        end
        quotient = q;
          end
    end 

endmodule