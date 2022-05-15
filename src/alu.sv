module ALU (
    input1,
    input2,
    alu_operation,
    out,
    zero
);
    parameter XLEN=32;
    input[XLEN-1:0] input1,input2;
    input[3:0] alu_operation; //TODO check size
    output[XLEN-1:0] out;
    output zero; //TODO what is zero?!

    assign zero = 1'b0;
endmodule