module CU (
    opcode, funct, halted, alu_src, reg_dest, link, pc_or_mem, mem_or_reg, pc_src
);
    output reg halted;
    output reg alu_src;
    output reg reg_dest;
    output reg link;
    output reg pc_or_mem;
    output reg mem_or_reg;

    input[5:0] opcode;
    input[5:0] funct;

    ALU_CONTROLLER aluController(.alu_operation(),.opcode(opcode),.func(func));

    localparam [5:0] RTYPE = 6'b0;

    localparam [5:0] SYSCALL = 6'b001100, ADD = 6'b100000;

    always @(*) begin
        link = 0;
        pcOrMem = 0;
        //reset control signals!
        case (opcode)
            RTYPE:
            case (funct)
                SYSCALL: begin
                    halted = 1;
                end
                ADD : begin
                    aluSrc = 0;
                    regDst = 1;
                    memOrReg = 0;


                end
                // default: 
            endcase

            // default: 
        endcase

    end
    
endmodule