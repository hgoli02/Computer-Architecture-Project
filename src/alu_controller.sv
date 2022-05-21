module ALU_CONTROLLER(alu_operation, opcode, func);

    output reg[3:0] alu_operation;
    input [5:0] opcode;
    input [5:0] func;

    localparam [3:0] NOP = 4'd0, XOR = 4'd1, OR = 4'd2, AND = 4'd3,
                     NOR = 4'd4 ,SLL = 4'd5, SRL = 4'd6, SLT = 4'd7, ADD = 4'd8,
                     ADDU = 4'd9, SUB = 4'd10, SUBU = 4'd11, MULT = 4'd12, DIV = 4'd13 ;

    always @(*) begin
        
        case (opcode)
            // R instructions
            6'b000000 :begin
                case (func):
                    6'b000100 : alu_operation = SLL; //SLL, SLLV
                    6'b000110 : alu_operation = SRL; //SRL, SRLV
                    6'b100110 : alu_operation = XOR; //XOR
                    6'b100010 : alu_operation = SUB; // sub
                    6'b101010 : alu_operation = SLT; //SLT
                    6'b100011 : alu_operation = SUBU;//sub unsigned
                    6'b100101 : alu_operation = OR; // OR
                    6'b100111 : alu_operation = NOR; //NOR
                    6'b100001 : alu_operation = ADDU; //add unsigned
                    6'b011000 : alu_operation = MULT; //mult
                    6'b011010 : alu_operation = DIV; //div
                    6'b100100 : alu_operation = AND; //AND
                    6'b100000 : alu_operation = ADD; //add
                    default : alu_operation = NOP;
                endcase
            end
            // I instructions
            6'b001110 : alu_operation = XOR; //XORi
            6'b001010 : alu_operation = SLT; //SLTi
            6'b001000: alu_operation = ADD; //ADDi
            6'b001100 : alu_operation = AND; //ANDi
            6'b001101 : alu_operation = OR; //ORi 
            6'b001001 : alu_operation = ADDU; //ADDiu (unsigned) 
            6'b000100 : alu_operation = SUB; //BEQ 
            6'b000101 : alu_operation = SUB; //BNE
            6'b000110 : alu_operation = SUB; //BLEZ
            6'b000111 : alu_operation = SUB; //BGTZ        
            6'b000001 : alu_operation = SUB; //BGEZ             
            default : alu_operation = NOP;
            
        endcase
    end
endmodule