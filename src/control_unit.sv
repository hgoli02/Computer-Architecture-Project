module CU (
    opcode, func, halted, aluSrc, regDest, link, pcOrMem, memOrReg, branch
);
    output reg halted;
    output reg aluSrc;
    output reg link;
    output reg pcOrMem;
    output reg memOrReg;
    output reg branch;
    output reg regDest;


    input[5:0] opcode;
    input[5:0] func;

    //ALU_CONTROLLER aluController();

    localparam [5:0] RTYPE = 6'b0;

    localparam [5:0] SYSCALL = 6'b001100, ADD = 6'b100000;

    always @(*) begin
        link = 0;
        pcOrMem = 0;
        branch = 0;
        //reset control signals!
        case (opcode)
            RTYPE:
            case (func)
                SYSCALL: begin
                    halted = 1;
                end
                ADD : begin
                    aluSrc = 0;
                    regDest = 1;
                    memOrReg = 0;
                end
                default: begin
                    $display("No func in R type %b",func);
                end
            endcase
            default: begin
                $display("No Opcode %b", opcode);
            end
 
        endcase

    end
    
endmodule