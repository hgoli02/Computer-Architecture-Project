module Mux #(
    parameter XLEN = 32
) (
    select, in0, in1, out
);
    input select;
    input [XLEN - 1:0] in0, in1;
    output [XLEN - 1:0] out;
    assign out = (select == 1'b0 ? in0 : in1);  
    
endmodule