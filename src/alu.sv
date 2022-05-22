module ALU #(parameter XLEN = 32) (input1, input2, alu_operation, out, negative, zero
    //overflow
);
    
    input[XLEN-1:0] input1,input2;
    input[3:0] alu_operation; //TODO check size
    output reg[XLEN-1:0] out;
    output zero;
    output negative;
    //output overflow;
    
    wire signed [XLEN - 1 : 0] signed_input1;
    wire signed [XLEN - 1 : 0] signed_input2;
    assign signed_input1 = input1;
    assign signed_input2 = input2;

    localparam [3:0] NOP = 4'd0, XOR = 4'd1, OR = 4'd2, AND = 4'd3,
                     NOR = 4'd4 ,SLL = 4'd5, SRL = 4'd6, SLT = 4'd7, ADD = 4'd8,
                     ADDU = 4'd9, SUB = 4'd10, SUBU = 4'd11, MULT = 4'd12,
                     DIV = 4'd13,SRA = 4'd14, LUI = 4'd15 ;

    assign zero = ~|out;

    assign negative = out[XLEN - 1];


    always @(input1, input2, alu_operation) begin
        case(alu_operation)
            XOR :    out = input1 ^ input2;
            OR :     out = input1 | input2;
            AND :    out = input1 & input2;
            NOR :    out = ~(input1 | input2);
            SLL :    out = input2 << input1;
            SRL :    out = input2 >> input1;
            ADD :    out = input1 + input2;
            ADDU :   out = input1 + input2;
            SUB :    out = input1 - input2;
            SUBU :   out = input1 - input2;
            MULT :   out = input1 * input2;
            DIV :    out = input1 / input2;
<<<<<<< HEAD
            SLT :    out = signed_input1 < signed_input2 ? 1 : 0; 
=======
            SLT :    out = signed_input1 < signed_input2 ? 1 : 0;
>>>>>>> 2c15575aee2d4556b9ce7ab38993b71de74e9785
            SRA :    out = signed_input2 >>> input1; 
            LUI :    out = {signed_input2[(XLEN / 2) - 1: 0],{(XLEN/2){1'b0}}};
            NOP :    out = input1;
            default: out = {XLEN{1'b0}};
        endcase
    end
    always @(alu_operation) begin
        $display("alu_op = %d , input1 = %d , input2 = %d ,out = %d",alu_operation,input1,input2,out);
    end

endmodule
