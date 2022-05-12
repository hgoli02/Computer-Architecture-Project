module Mux #(
    parameter XLEN = 32
) (
    select, in0, in1, out
);
    input select;
    input [XLEN - 1:0] in0, in1;
    output out;
    assign out = select == 0 ? in0 : in1;
    
endmodule