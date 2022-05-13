module ALU_CONTROLLER(alu_operation, opcode, func, clk);

    output [3:0] alu_operation;
    reg [3:0] alu_operation;
    input [5:0] opcode;
    input [5:0] func;
    input clk;


    // R instructions
    if (opcode == 6'b000000) begin
        if(func == 6'b000000 || func == 6'b000100) //SLL, SLLV
            alu_operation = ????;

        if(func == 6'b000010 || func == 6'b000110) //SRL, SRLV
            alu_operation = ????;

        if(func == 6'b100110) //xor
            alu_operation = ????;

        if(func == 6'b100010) // sub
            alu_operation = ????;

        if(func == 6'b101010) // slt
            alu_operation = ????;

        if(func == 6'b100011) //sub unsigned
            alu_operation = ????;

        if(func == 6'b100101) // OR
            alu_operation = ????;

        if(func == 6'b100111) //NOR
            alu_operation = ????;

        if(func == 6'b100001) //add unsigned
            alu_operation = ????;

        if(func == 6'b011000) //mult
            alu_operation = ????;

        if(func == 6'b011010) //div
            alu_operation = ????;

        if(func == 6'b100100) //AND
            alu_operation = ????;

        if(func == 6'b100000) //add
            alu_operation = ????;

        
    end
    
    // I instructions
    else begin
        if(opcode == 0'b001110) //XORi
            alu_operation = ????;

        if(opcode == 0'b001010) //SLTi
            alu_operation = ????;

        if(opcode == 0'b001000) //ADDi
            alu_operation = ????;

        if(opcode == 0'b001100) //ANDi
            alu_operation = ????;

        if(opcode == 0'b001101) //ORi 
            alu_operation = ????;   

         if(opcode == 0'b001001) //ADDiu (unsigned) 
            alu_operation = ????;   
        end
endmodule
