module control_unit (
    opcode, func, halted, alu_src, reg_dest, link, pc_or_mem, mem_or_reg, branch, jump_register,jump,
    reg_write_enable, does_shift_amount_need, alu_operation,mem_write_en,zero,negative,is_unsigned
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
    output reg is_unsigned;
    output reg reg_write_enable;
    output reg does_shift_amount_need;
    output [3:0] alu_operation;
    output reg mem_write_en;

    reg should_branch;

    input[5:0] opcode;
    input[5:0] func;
    input negative,zero;

    ALU_CONTROLLER aluController(alu_operation, opcode, func);


    localparam [5:0] RTYPE = 6'b000000, ADDIU = 6'b001001;

    localparam [5:0] SYSCALL = 6'b001100, ADD = 6'b100000 , BEQ = 6'b000100,
        BNE = 6'b000101 , JUMP = 6'b000010;
    always @(*) begin
        link = 0;
        pc_or_mem = 0;
        branch = 0;
        jump_register = 0;
        jump = 0;
        reg_write_enable = 0;
        does_shift_amount_need = 0;
        mem_or_reg = 0;
        alu_src = 0;
        mem_write_en = 0;
        should_branch = 0;
        //reset control signals!
        case (opcode)
            RTYPE:
            case (func)
                SYSCALL: begin
                    halted = 1;
                end
                ADD : begin
                    reg_dest = 1;
                    reg_write_enable = 1;
                    //TODO!
                end
                default: begin

                end
            endcase
            ADDIU: begin
                reg_write_enable = 1;
                alu_src = 1;
                is_unsigned = 1;
            end
            BNE:begin
                should_branch = 1;
            end
            BEQ:begin
                should_branch = 1;
            end
            JUMP:begin
                jump = 1;
            end
            default: begin
            
            end
            
        endcase

    end
    always @(should_branch ,zero , negative)begin
        branch = 0;
        if (should_branch)begin
            case(opcode)
                BEQ: if(zero)begin 
                    branch = 1;
                end
                BNE: if(~zero) branch = 1;
                default:begin end
            endcase
        end
        // $display("should_branch = %d , branch = %d , zero = %d , negative = %d,opcode = %d",should_branch,branch,zero,negative,opcode);

    end
endmodule