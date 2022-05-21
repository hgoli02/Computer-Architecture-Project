module tb_alu;
reg [31:0] input1;
reg [31:0] input2;
reg [3:0] alu_operation;
wire [31:0] out;
wire negative;
wire zero;


ALU alu(
    input1,
    input2,
    alu_operation,
    out,
    negative,
    zero
);


initial begin
    input1 = 32'b00001111;
    input2 = 32'b00101010;
    alu_operation = 1;
    #5;
    alu_operation = 2;
    #5;
    alu_operation = 3;
    #5;
    alu_operation = 4;
    #5;
    input1 = 32'b00001111;
    input2 = 32'b00000100;
    alu_operation = 5;
    #5;
    input1 = 32'b11111111;
    input2 = 32'b00000100;
    alu_operation = 6;
    #5;
    input1 = 32'b000011111;
    input2 = 32'b000110000;
    alu_operation = 7;
    #5;
    input1 = 7;
    input2 = -3;
    alu_operation = 8;
    #10;
    input1 = 7;
    input2 = 8;
    alu_operation = 9;
    #10;
    alu_operation = 10;
    #5;
    alu_operation = 11;
    #5;
    alu_operation = 12;
    #5;
    input1 = 32;
    input2 = 8;
    alu_operation = 13;
    #5;
    alu_operation = 14;
    #5;
    alu_operation = 15;
    #5;
end

initial begin
    $monitor("alu_operation = %d , out = %b , negative = %b , zero = %b", alu_operation, out, negative, zero);
end

endmodule
`default_nettype wire