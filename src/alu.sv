module ALU #(
    parameter XLEN = 32
) (
    input1,
    input2,
    alu_operation,
    out,
    negative,
    zero
);
    
    input[XLEN-1:0] input1,input2;
    input[3:0] alu_operation; //TODO check size
    output[XLEN-1:0] out;
    output zero;
    output negative;

endmodule