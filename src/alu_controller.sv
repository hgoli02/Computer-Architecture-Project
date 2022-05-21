module ALU_CONTROLLER(alu_operation, opcode, func);

    output reg[3:0] alu_operation;
    input [5:0] opcode;
    input [5:0] func;

    localparam [3:0] NOP = 4'd0, XOR = 4'd1, OR = 4'd2, AND = 4'd3,
                     NOR = 4'd4 ,SLL = 4'd5, SRL = 4'd6, SLT = 4'd7, ADD = 4'd8,
                     ADDU = 4'd9, SUB = 4'd10, SUBU = 4'd11, MULT = 4'd12, DIV = 4'd13 ;

    always @(*) begin
        

    // R instructions
    if (opcode == 6'b000000) begin
        if(func == 6'b000100) //SLL, SLLV
            alu_operation = SLL;

        if(func == 6'b000110) //SRL, SRLV
            alu_operation = SRL;

        if(func == 6'b100110) //xor
            alu_operation = XOR;

        if(func == 6'b100010) // sub
            alu_operation = SUB;

        if(func == 6'b101010) // slt
            alu_operation = SLT;

        if(func == 6'b100011) //sub unsigned
            alu_operation = SUBU;

        if(func == 6'b100101) // OR
            alu_operation = OR;

        if(func == 6'b100111) //NOR
            alu_operation = NOR;

        if(func == 6'b100001) //add unsigned
            alu_operation = ADDU;

        if(func == 6'b011000) //mult
            alu_operation = MULT;

        if(func == 6'b011010) //div
            alu_operation = DIV;

        if(func == 6'b100100) //AND
            alu_operation = AND;

        if(func == 6'b100000) //add
            alu_operation = ADD;
        else
            alu_operation = NOP;

        
    end
    
    // I instructions
    else begin
        if(opcode == 6'b001110) //XORi
            alu_operation = XOR;

        if(opcode == 6'b001010) //SLTi
            alu_operation = SLT;

        if(opcode == 6'b001000) //ADDi
            alu_operation = ADD;

        if(opcode == 6'b001100) //ANDi
            alu_operation = AND;

        if(opcode == 6'b001101) //ORi 
            alu_operation = OR;   

        if(opcode == 6'b001001) //ADDiu (unsigned) 
            alu_operation = ADDU;

        if(opcode == 6'b000100) //BEQ 
            alu_operation = SUB;

        if(opcode == 6'b000101) //BNE
            alu_operation = SUB;

        if(opcode == 6'b000110) //BLEZ
            alu_operation = SUB;

        if(opcode == 6'b000111) //BGTZ
            alu_operation = SUB;

        if(opcode == 6'b000001) //BGEZ 
            alu_operation = SUB;
        else
            alu_operation = NOP;
        
        end
    end
endmodule
