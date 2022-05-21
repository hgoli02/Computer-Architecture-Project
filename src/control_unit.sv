
module control_unit (
    opcode, func, halted, alu_src, reg_dest, link, pc_or_mem, mem_or_reg, branch, jump_register,jump,
    reg_write_enable, does_shift_amount_need, alu_operation
);
    output reg halted;
    output reg alu_src;
    output reg reg_dest;
    output reg link;
    output reg pc_or_mem;
    output reg mem_or_reg;
    output reg branch;
    output reg jump_register;
    output reg jump;
    output reg reg_write_enable;
    output reg does_shift_amount_need;
    output [3:0] alu_operation;


    input[5:0] opcode;
    input[5:0] func;


    ALU_CONTROLLER aluController(alu_operation, opcode, func);


    localparam [5:0] RTYPE = 6'b000000, ADDIU = 6'b001001;

    localparam [5:0] SYSCALL = 6'b001100, ADD = 6'b100000;

    always @(*) begin
        link = 0;
        pc_or_mem = 0;
        branch = 0;
        jump_register = 0;
        jump = 0;
        reg_write_enable = 0;
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
            ADDIU: begin
                reg_write_enable = 1;
                alu_src = 1;
                does_shift_amount_need = 0;
                mem_or_reg = 0;
                pc_or_mem = 0;
            end

            default: begin
                $display("No Opcode %b", opcode);
            end
 

        endcase

    end
    
endmodule