<<<<<<< HEAD
module ALU (
    input1,
    input2,
    alu_operation,
    result,
    zero
=======
module alu (
    
>>>>>>> 2449d72c12180bac86291c00fe7e62605ef4e6eb
);
    input[XLEN-1:0] input1,input2;
    input[3:0]alu_operation //todo check size
    output[XLEN-1:0] result,zero;

    assign zero = 32'b0;
    parameter XLEN=32
endmodule