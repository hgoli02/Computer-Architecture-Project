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
    output reg mem_write_en;
    output [3:0] alu_operation;
    reg should_branch;

    input[5:0] opcode;
    input[5:0] func;
    input negative,zero;

    ALU_CONTROLLER aluController(alu_operation, opcode, func);


    localparam [5:0] RTYPE = 6'b000000, ADDIU = 6'b001001, ADDi = 6'b001000,
        SYSCALL = 6'b001100, ADD = 6'b100000 , BEQ = 6'b000100,BGTZ = 6'b000111,
        BNE = 6'b000101 , JUMP = 6'b000010,BLEZ = 6'b000110,BGEZ = 6'b000001,
        AND = 6'b100100 , OR = 6'b100101, DIV = 6'b011010, MULT = 6'b011000, NOR = 6'b100111,
        XOR = 6'b100110 , SUB = 6'b100010, ANDi = 6'b001100 ,XORi = 6'b001110,ORi = 6'b001101,
        SLL = 6'b000100 , SLLV = 6'b000000 , SRL = 6'b000010 , SRLV = 6'b000110, SRA = 6'b000011,
        SLT = 6'b101010 , SLTi = 6'b001010 , ADDU = 6'b100001, SUBU = 6'b100011 , JR = 6'b001000,
        JAL = 6'b000011;
    always @(*) begin
        halted = 0;
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
        reg_dest = 0;
        should_branch = 0;
        is_unsigned = 0;
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
                end
                AND : begin
                    reg_dest = 1;
                    reg_write_enable = 1;
                end
                DIV : begin
                    reg_dest = 1;
                    reg_write_enable = 1;
                end
                MULT : begin
                    reg_dest = 1;
                    reg_write_enable = 1;
                end
                NOR : begin
                    reg_dest = 1;
                    reg_write_enable = 1;
                end
                OR : begin
                    reg_dest = 1;
                    reg_write_enable = 1;
                end
                XOR : begin
                    reg_dest = 1;
                    reg_write_enable = 1;
                end
                SUB : begin
                    reg_dest = 1;
                    reg_write_enable = 1;
                end
                ADDU : begin //TODO check
                    reg_dest = 1;
                    reg_write_enable = 1;
                end
                SUBU : begin //TODO check
                    reg_dest = 1;
                    reg_write_enable = 1;
                end
                SLL : begin
                    reg_dest = 1;
                    reg_write_enable = 1;
                    does_shift_amount_need = 1;
                end
                SRL : begin
                    reg_dest = 1;
                    reg_write_enable = 1;
                    does_shift_amount_need = 1;
                end
                SRA : begin
                    reg_dest = 1;
                    reg_write_enable = 1;
                    does_shift_amount_need = 1;
                end
                SLLV : begin
                    reg_dest = 1;
                    reg_write_enable = 1;
                end
                SRLV : begin
                    reg_dest = 1;
                    reg_write_enable = 1;
                end
                SLT : begin
                    reg_dest = 1;
                    reg_write_enable = 1;
                end
                JR : begin
                    jump_register = 1;
                end
                default: begin
                end
            endcase
            ADDIU: begin
                reg_write_enable = 1;
                alu_src = 1;
                is_unsigned = 1;
            end
            BNE: should_branch = 1;
            BEQ: should_branch = 1;
            BLEZ: should_branch = 1;
            BGTZ: should_branch = 1;
            BGEZ: should_branch = 1;
            JUMP: jump = 1;
            ADDi: begin
                reg_write_enable = 1;
                alu_src = 1;
            end
            ANDi: begin
                reg_write_enable = 1;
                alu_src = 1;
            end
            XORi: begin
                reg_write_enable = 1;
                alu_src = 1;
            end
            ORi: begin
                reg_write_enable = 1;
                alu_src = 1;
            end
            SLTi : begin
                reg_write_enable = 1;
                alu_src = 1;
            end
            JAL : begin 
                jump = 1;
                pc_or_mem = 1;
                link = 1;
                //TODO bug , pc + 8 -> R[31]
            end
            default: begin
            
            end
            
        endcase

    end
    always @(should_branch ,zero , negative)begin
        branch = 0;
        if (should_branch)begin
            case(opcode)
                BEQ: if(zero) branch = 1;
                BNE: if(~zero) branch = 1;
                BLEZ: if(zero || negative) branch = 1;
                BGTZ: if(~negative && ~zero) branch = 1;
                BGEZ: if(~negative) branch = 1;
                default:begin end
            endcase
        end
        $display("should_branch = %d , branch = %d , zero = %d , negative = %d,opcode = %d",should_branch,branch,zero,negative,opcode);

    end
endmodule