module ALU (
    input1,
    input2,
    alu_operation,
    out,
    zero
);
    parameter XLEN=32;
    input[XLEN-1:0] input1,input2;
    input[3:0] alu_operation; //todo check size
    output[XLEN-1:0] out,zero;

    assign zero = 32'b0;
endmodule