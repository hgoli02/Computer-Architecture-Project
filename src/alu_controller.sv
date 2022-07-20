module ALU_CONTROLLER(alu_operation, opcode, func);

    output reg[4:0] alu_operation;
    input [5:0] opcode;
    input [5:0] func;

    localparam [4:0] NOP = 5'd0, XOR = 5'd1, OR = 5'd2, AND = 5'd3,
                     NOR = 5'd4 ,SLL = 5'd5, SRL = 5'd6, SLT = 5'd7, ADD = 5'd8,
                     ADDU = 5'd9, SUB = 5'd10, SUBU = 5'd11, MULT = 5'd12, DIV = 5'd13,
                     LUI = 5'd15 ,SRA = 5'd14, ADD_S = 5'd16, SUB_S = 5'd17, MUL_S = 5'd18,
                     DIV_S = 5'd19, INV_S = 5'd20, RND_S = 5'd21, NOP_S = 5'd22, SLT_S = 5'd23;

    always @(opcode, func) begin
        
        case (opcode)
            // R instructions
            6'b000000 :begin
                case (func)
                    6'b000000 : alu_operation = SLL; //SLLV
                    6'b000100 : alu_operation = SLL; //SLL
                    6'b000010 : alu_operation = SRL; //SRL
                    6'b000110 : alu_operation = SRL; //SRLV
                    6'b000011 : alu_operation = SRA; //SRA
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
                    6'b111101 : alu_operation = ADD_S;
                    6'b111100 : alu_operation = SUB_S;
                    6'b111000 : alu_operation = MUL_S;
                    6'b110100 : alu_operation = DIV_S;
                    6'b111011 : alu_operation = INV_S;
                    6'b111001 : alu_operation = RND_S;
                    6'b111010 : alu_operation = SLT_S;
                    //6'd49 : alu_operation = INV_S; 
                    //6'd50 : alu_operation = RND_S;
                    //6'd51 : alu_operation = NOP_S;
                    //6'd52 : alu_operation = SLT_S;
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
            6'b001111 : alu_operation = LUI; //LUi
            6'b000110 : alu_operation = NOP; //BLEZ
            6'b000111 : alu_operation = NOP; //BGTZ        
            6'b000001 : alu_operation = NOP; //BGEZ
            6'b101011 : alu_operation = ADD; //SW
            6'b100011 : alu_operation = ADD; //LW 
            6'b100000 : alu_operation = ADD; //SB
            6'b101000 : alu_operation = ADD; //LB
                   
            default : alu_operation = NOP;
            
        endcase
    end
endmodule
