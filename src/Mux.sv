module MUX #(
    parameter XLEN = 32
) (
    s, in0, in1, out, en
);
    input s;
    input en;
    input [XLEN - 1:0] in0, in1;
    output out;
    assign out = s == 0 ? in0 : in1;
    
endmodule