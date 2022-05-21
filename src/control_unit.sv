module CU (
    opcode, func, halted, aluSrc, regDest, link, pcOrMem, memOrReg, pCSrc,clk, rst
);
    output reg halted;
    output reg aluSrc;
    output reg regDst;
    output reg link;
    output reg pcOrMem;
    output reg memOrReg;

    input[5:0] opcode;
    input[5:0] funct;

    //ALU_CONTROLLER aluController();

    localparam [5:0] RTYPE = 6'b0;

    localparam [5:0] SYSCALL = 6'b001100, ADD = 6'b100000;

    always @(*) begin
        link = 0;
        pcOrMem = 0;
        //reset control signals!
        case (opcode)
            RTYPE:
            case (func)
                SYSCALL: begin
                    halted = 1;
                end
                ADD : begin
                    aluSrc = 0;
                    regDst = 1;
                    memOrReg = 0;
                end
            endcase
 
        endcase

    end
    
endmodule