module control_unit (
    inst_ID, inst_MEM, inst_EX, halted, alu_src, reg_dest, pc_or_mem, mem_or_reg, branch, jump_register,jump,
    reg_write_enable, does_shift_amount_need, alu_operation,mem_write_en,zero,negative,is_unsigned,pc_we,hit,should_branch,stall,float_reg_write_enable,regfile_mux,
    fp_regfile_mux//,is_byte
);
    output reg float_reg_write_enable;
    output reg halted;
    output reg alu_src;
    output reg reg_dest;
    output reg pc_or_mem;
    output reg mem_or_reg;
    output reg branch;
    output reg jump_register;
    output reg jump;
    output reg is_unsigned;
    output reg reg_write_enable;
    output reg does_shift_amount_need;
    output reg mem_write_en;
    output reg pc_we;
    // output reg is_byte;
    output [4:0] alu_operation;
    output reg should_branch;
    output reg fp_regfile_mux;
    output reg regfile_mux;

    wire is_mem_inst;

    input [31:0] inst_ID;
    input [31:0] inst_MEM;
    input [31:0] inst_EX;
    input negative,zero;
    input hit;
    input stall;

    wire [5:0] opcode_ID = inst_ID[31:26];
    wire [5:0] func_ID = inst_ID[5:0];
    wire [5:0] opcode_MEM = inst_MEM[31:26];
    wire [5:0] func_MEM = inst_MEM[5:0];
    wire [5:0] opcode_EX = inst_EX[31:26];
    wire [5:0] func_EX = inst_EX[5:0];

    assign pc_we = ~stall; //avaz she
    assign is_mem_inst = (opcode_MEM == LW | opcode_MEM == SW | opcode_MEM == LB | opcode_MEM == SB);

    ALU_CONTROLLER aluController(alu_operation, opcode_ID, func_ID);

    localparam [5:0] RTYPE = 6'b000000, ADDIU = 6'b001001, ADDi = 6'b001000,
        SYSCALL = 6'b001100, ADD = 6'b100000 , BEQ = 6'b000100,BGTZ = 6'b000111,
        BNE = 6'b000101 , JUMP = 6'b000010,BLEZ = 6'b000110,BGEZ = 6'b000001,
        AND = 6'b100100 , OR = 6'b100101, DIV = 6'b011010, MULT = 6'b011000, NOR = 6'b100111,
        XOR = 6'b100110 , SUB = 6'b100010, ANDi = 6'b001100 ,XORi = 6'b001110,ORi = 6'b001101,
        SLLV = 6'b000100 , SLL = 6'b000000 , SRL = 6'b000010 , SRLV = 6'b000110, SRA = 6'b000011,
        SLT = 6'b101010 , SLTi = 6'b001010 , ADDU = 6'b100001, SUBU = 6'b100011 , JR = 6'b001000,
        JAL = 6'b000011, SW = 6'b101011, LW = 6'b100011, LUi = 6'b001111, LB = 6'b100000, SB = 6'b101000,
        MFC1 = 6'b111111, MTC1 = 6'b111110, ADD_S = 6'b111101, SUB_S = 6'b111100, MUL_S = 6'b111000, DIV_S = 6'b110100,
        INV_S = 6'b111011, RND_S = 6'b111001, SLT_S = 6'b111010;
    always @(*) begin
        halted = 0;
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
        fp_regfile_mux = 0;
        regfile_mux = 0;
        float_reg_write_enable = 0;
        // is_byte = 0;        
        //reset control signals!
        case (opcode_ID)
            RTYPE:
            case (func_ID)
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
                MTC1: begin
                    float_reg_write_enable = 1;
                    reg_dest = 1;
                    fp_regfile_mux = 1;
                end
                MFC1: begin
                    reg_write_enable = 1;
                    regfile_mux = 1;
                end
                ADD_S: begin
                    float_reg_write_enable = 1;
                    reg_dest = 1;
                end
                SUB_S: begin
                    float_reg_write_enable = 1;
                    reg_dest = 1;
                end
                MUL_S: begin
                    float_reg_write_enable = 1;
                    reg_dest = 1;
                end
                DIV_S: begin
                    float_reg_write_enable = 1;
                    reg_dest = 1;
                end
                INV_S: begin
                    float_reg_write_enable = 1;
                    reg_dest = 1;
                end
                RND_S: begin
                    float_reg_write_enable = 1;
                    reg_dest = 1;
                end
                SLT_S: begin
                    float_reg_write_enable = 1;
                    reg_dest = 1;
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
                is_unsigned = 1;
            end
            XORi: begin
                reg_write_enable = 1;
                alu_src = 1;
                is_unsigned = 1;
            end
            ORi: begin
                reg_write_enable = 1;
                alu_src = 1;
                is_unsigned = 1;
            end
            SLTi : begin
                reg_write_enable = 1;
                alu_src = 1;
            end
            JAL : begin 
                pc_or_mem = 1;
                reg_write_enable = 1;
                jump = 1;
                //TODO bug , pc + 8 -> R[31]
            end
            LW : begin
                mem_or_reg = 1;
                alu_src = 1;
                //reg_write_enable = 1;
            end
            LB: begin
                mem_or_reg = 1;
                alu_src = 1;
                // is_byte = 1;
            end 

            SW : begin
                alu_src = 1;
                //mem_write_en = 1;
            end

            SB : begin
                alu_src = 1;
                // is_byte = 1;
            end 

            LUi : begin
                reg_write_enable = 1;
                alu_src = 1;
            end
            default: begin
            
            end
            
        endcase

    end
    
    

endmodule