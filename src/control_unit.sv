module CU (
    opcode, func, halted, alu_src, reg_dest, link, pc_or_mem, mem_or_reg, branch
);
    output reg halted;
    output reg alu_src;
    output reg reg_dest;
    output reg link;
    output reg pc_or_mem;
    output reg mem_or_reg;
    output reg branch;

    input[5:0] opcode;
    input[5:0] func;

    //ALU_CONTROLLER aluController();


    localparam [5:0] RTYPE = 6'b0;

    localparam [5:0] SYSCALL = 6'b001100, ADD = 6'b100000;

    always @(*) begin
        link = 0;
        pc_or_mem = 0;
        branch = 0;
        //reset control signals!
        case (opcode)
            RTYPE:
            case (func)
                SYSCALL: begin
                    halted = 1;
                end
                ADD : begin
                    alu_src = 0;
                    reg_dest = 1;
                    mem_or_reg = 0;
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