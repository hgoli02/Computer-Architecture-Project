module data_path (
    inst,inst_addr , reg_dest, reg_write_enable, alu_src, alu_operation, mem_addr, mem_data_in,mem_data_out,
    mem_or_reg,clk,halted,rst_b,branch,jump,jump_register,pc_or_mem,does_shift_amount_need,zero,negative,
    is_unsigned,pc_we,flush,stall,reg_write_enable_cache,inst_ID, inst_MEM, inst_EX, should_branch,float_reg_write_enable,regfile_mux,
    fp_regfile_mux);

 localparam [5:0] RTYPE = 6'b000000, ADDIU = 6'b001001, ADDi = 6'b001000,
        SYSCALL = 6'b001100, ADD = 6'b100000 , BEQ = 6'b000100,BGTZ = 6'b000111,
        BNE = 6'b000101 , JUMP = 6'b000010,BLEZ = 6'b000110,BGEZ = 6'b000001,
        AND = 6'b100100 , OR = 6'b100101, DIV = 6'b011010, MULT = 6'b011000, NOR = 6'b100111,
        XOR = 6'b100110 , SUB = 6'b100010, ANDi = 6'b001100 ,XORi = 6'b001110,ORi = 6'b001101,
        SLLV = 6'b000100 , SLL = 6'b000000 , SRL = 6'b000010 , SRLV = 6'b000110, SRA = 6'b000011,
        SLT = 6'b101010 , SLTi = 6'b001010 , ADDU = 6'b100001, SUBU = 6'b100011 , JR = 6'b001000,
        JAL = 6'b000011, SW = 6'b101011, LW = 6'b100011, LUi = 6'b001111, LB = 6'b100000, SB = 6'b101000;
parameter XLEN = 32;
input clk, halted, rst_b;
input wire [XLEN - 1:0] inst;
input reg_write_enable_cache;
output wire[XLEN - 1:0] mem_addr, inst_addr; //bug
output  wire [7:0]  mem_data_in[0:3]; //bug
input  wire [7:0]  mem_data_out[0:3];
wire[XLEN - 1:0] memory_in;
wire[XLEN - 1:0] memory_out_MEM;
input flush;
input stall;

assign {mem_data_in[3], mem_data_in[2], mem_data_in[1],mem_data_in[0]} = memory_in;      //TODO check indexes (!!!!)
assign memory_out_MEM = {mem_data_out[3], mem_data_out[2], mem_data_out[1],mem_data_out[0]};

input regfile_mux;
input fp_regfile_mux;
input float_reg_write_enable;
input [4:0] alu_operation;
input pc_we;
input reg_dest; // R type and I type Mux from control unit
input reg_write_enable; // register file write enable from control unit 
input alu_src; //alu_src
input mem_or_reg; // what data to write in reg file from control unit
input pc_or_mem;
input branch;
input jump;
input jump_register;
input does_shift_amount_need;
input is_unsigned;
input should_branch;
output zero;
output negative;
output [31:0] inst_ID;
output [31:0] inst_MEM;
output [31:0] inst_EX;

wire float_reg_write_enable_EX, float_reg_write_enable_MEM;
wire regfile_mux_EX, regfile_mux_MEM;


//IF
wire[XLEN - 1 : 0 ] pc_incremented_IF;
wire[XLEN - 1 : 0] pc_value;
wire[XLEN - 1 : 0] pc_input;
wire[XLEN - 1 : 0] inst_IF;
Adder pc_incrementer(pc_value,32'd4,pc_incremented_IF);
assign inst_addr = pc_value;
assign inst_IF = inst;
Register pc(.clk(clk),.rst_b(rst_b),.data_in(pc_input),.data_out(pc_value),.we(pc_we));


buff_IF_ID buff_ifid(
    .pc_incremented_IF(pc_incremented_IF),
    .pc_incremented_ID(pc_incremented_ID),
    .inst_IF(inst_IF),
    .inst_ID(inst_ID),
    .clk(clk),
    .rst_b(rst_b),
    .flush(flush),
    .stall(stall));

//ID
wire reg_dest_ID = reg_dest;
wire reg_write_enable_ID = reg_write_enable;
wire alu_src_ID = alu_src;
wire mem_or_reg_ID = mem_or_reg;
wire pc_or_mem_ID = pc_or_mem;
wire branch_ID = branch;
wire jump_ID = jump;
wire jump_register_ID = jump_register;
wire does_shift_amount_need_ID = does_shift_amount_need;
wire is_unsigned_ID = is_unsigned;
wire should_branch_ID = should_branch;
wire [31:0] inst_ID;
wire [31:0] pc_jump_address_ID;
wire [31:0] pc_incremented_ID;
wire [31:0] rs_data_ID;
wire [31:0] rt_data_ID;
wire [31:0] fs_data_ID;
wire [31:0] ft_data_ID;
wire [31:0] shift_amount_32bit_ID;
wire [31:0] shifted_first16bit_extended_inst_ID;
wire [31:0] immediate_data_ID;
wire [4:0] alu_operation_ID = alu_operation;
wire [4:0] rd_num_ID;
wire [5:0] opcode_ID = inst_ID[31:26];
wire [XLEN -1 : 0] sign_extended_first16bit_inst;
assign sign_extended_first16bit_inst = {{(XLEN/2){inst_ID[15]}}, inst_ID[15:0]};
assign shifted_first16bit_extended_inst_ID = sign_extended_first16bit_inst << 2;
Mux unsigned_mux(.select(is_unsigned_ID),.in0(sign_extended_first16bit_inst),.in1({{(XLEN/2){1'b0}},inst_ID[15:0]}),
.out(immediate_data_ID));
wire [4:0] write_reg_num_inst;
Mux #(5) write_reg_file_mux(.select(reg_dest_ID),.in0(inst_ID[20:16]),.in1(inst_ID[15:11]),.out(write_reg_num_inst));
Mux #(5) write_reg_if_jal_mux(.select(pc_or_mem_ID),.in0(write_reg_num_inst),.in1(5'd31),.out(rd_num_ID));
wire [XLEN - 5 : 0] shifted_first26bit_inst;
assign shifted_first26bit_inst = {2'b0,inst_ID[25:0]} << 2;
assign pc_jump_address_ID = {pc_incremented_ID[31:28],shifted_first26bit_inst};
assign shift_amount_32bit_ID = {{(XLEN - 5){1'b0}},inst_ID[10:6]};



regfile RegisterFile(
        .rs_data(rs_data_ID),
        .rt_data(rt_data_ID),
        .rs_num(inst_ID[25:21]),
        .rt_num(inst_ID[20:16]),
        .rd_num(rd_num_WB),
        .rd_data(rd_data),
        .rd_we(reg_write_enable_WB),
        .clk(clk),
        .rst_b(rst_b),
        .halted(halted),
        .can_print(1'b1)
);

regfile RegisterFile_Float(
        .rs_data(fs_data_ID),
        .rt_data(ft_data_ID),
        .rs_num(inst_ID[25:21]),
        .rt_num(inst_ID[20:16]),
        .rd_num(rd_num_WB),
        .rd_data(fd_data),
        .rd_we(float_reg_write_enable_WB),
        .clk(clk),
        .rst_b(rst_b),
        .halted(halted),
        .can_print(1'b0)
);



buff_ID_EX buff_idex(
    .should_branch_ID(should_branch_ID),
    .reg_dest_ID(reg_dest_ID),
    .reg_write_enable_ID(reg_write_enable_ID),
    .alu_src_ID(alu_src_ID),
    .mem_or_reg_ID(mem_or_reg_ID),
    .pc_or_mem_ID(pc_or_mem_ID),
    .jump_ID(jump_ID),
    .jump_register_ID(jump_register_ID),
    .does_shift_amount_need_ID(does_shift_amount_need_ID),
    .is_unsigned_ID(is_unsigned_ID),
    .inst_ID(inst_ID),
    .pc_jump_address_ID(pc_jump_address_ID),
    .pc_incremented_ID(pc_incremented_ID),
    .rs_data_ID(rs_data_ID),
    .rt_data_ID(rt_data_ID),
    .shift_amount_32bit_ID(shift_amount_32bit_ID),
    .shifted_first16bit_extended_inst_ID(shifted_first16bit_extended_inst_ID),
    .immediate_data_ID(immediate_data_ID),
    .alu_operation_ID(alu_operation_ID),
    .rd_num_ID(rd_num_ID),
    .opcode_ID(opcode_ID),
    .should_branch_EX(should_branch_EX),
    .reg_dest_EX(reg_dest_EX),
    .reg_write_enable_EX(reg_write_enable_EX),
    .alu_src_EX(alu_src_EX),
    .mem_or_reg_EX(mem_or_reg_EX),
    .pc_or_mem_EX(pc_or_mem_EX),
    .jump_EX(jump_EX),
    .jump_register_EX(jump_register_EX),
    .does_shift_amount_need_EX(does_shift_amount_need_EX),
    .is_unsigned_EX(is_unsigned_EX),
    .pc_jump_address_EX(pc_jump_address_EX),
    .pc_incremented_EX(pc_incremented_EX),
    .rs_data_EX(rs_data_EX),
    .rt_data_EX(rt_data_EX),
    .shift_amount_32bit_EX(shift_amount_32bit_EX),
    .shifted_first16bit_extended_inst_EX(shifted_first16bit_extended_inst_EX),
    .immediate_data_EX(immediate_data_EX),
    .inst_EX(inst_EX),
    .alu_operation_EX(alu_operation_EX),
    .rd_num_EX(rd_num_EX),
    .opcode_EX(opcode_EX),
    .clk(clk),
    .rst_b(rst_b),
    .flush(flush),
    .stall(stall),
    .float_reg_write_enable_ID(float_reg_write_enable),
    .float_reg_write_enable_EX(float_reg_write_enable_EX),
    .fp_regfile_mux_ID(fp_regfile_mux),
    .fp_regfile_mux_EX(fp_regfile_mux_EX),
    .regfile_mux_ID(regfile_mux),
    .regfile_mux_EX(regfile_mux_EX),
    .fs_data_ID(fs_data_ID),
    .fs_data_EX(fs_data_EX),
    .ft_data_ID(ft_data_ID),
    .ft_data_EX(ft_data_EX)
    );


//EX
wire fp_regfile_mux_EX;
wire reg_dest_EX;
wire reg_write_enable_EX;
wire alu_src_EX;
wire mem_or_reg_EX;
wire pc_or_mem_EX;
wire jump_EX;
wire jump_register_EX;
wire should_branch_EX;
wire does_shift_amount_need_EX;
wire is_unsigned_EX;
wire [31:0] pc_jump_address_EX;
wire [31:0] pc_incremented_EX;
wire [31:0] rs_data_EX;
wire [31:0] rt_data_EX;
wire [31:0] shift_amount_32bit_EX;
wire [31:0] shifted_first16bit_extended_inst_EX;
wire [31:0] immediate_data_EX;
wire [31:0] inst_EX;
wire [4:0] alu_operation_EX;
wire [4:0] rd_num_EX;
wire [5:0] opcode_EX;
wire [31:0] fs_data_EX;
wire [31:0] ft_data_EX;
wire zero_EX;
wire negative_EX;
wire [31 : 0 ]fp_alu_result_EX;

wire [XLEN - 1:0] alu_second_source, alu_first_source, alu_result_EX;
wire[XLEN -1 : 0 ] pc_branch_value_EX;
Mux alu_input2_mux(.select(alu_src_EX),.in0(rt_data_EX),.in1(immediate_data_EX),.out(alu_second_source));
Mux select_shift_amount_mux(.select(does_shift_amount_need_EX),.in0(rs_data_EX),.in1(shift_amount_32bit_EX),.out(alu_first_source));
ALU alu(.input1(alu_first_source), .input2(alu_second_source), .out(alu_result_EX), .zero(zero_EX),.negative(negative_EX),.alu_operation(alu_operation_EX));
Adder pc_branch(pc_incremented_EX,shifted_first16bit_extended_inst_EX,pc_branch_value_EX);

floating_point_ALU fp_alu(.input1(fs_data_EX),.input2(ft_data_EX),.operation(alu_operation_EX),.result(fp_alu_result_EX),.division_by_zero(),.QNaN(),.SNaN(),.inexact(),.underflow(),.overflow());

buff_EX_MEM buff_exmem(
    .should_branch_EX(should_branch_EX),
    .reg_dest_EX(reg_dest_EX),
    .reg_write_enable_EX(reg_write_enable_EX),
    .mem_or_reg_EX(mem_or_reg_EX),
    .pc_or_mem_EX(pc_or_mem_EX),
    .jump_EX(jump_EX),
    .jump_register_EX(jump_register_EX),
    .is_unsigned_EX(is_unsigned_EX),
    .zero_EX(zero_EX),
    .negative_EX(negative_EX),
    .inst_EX(inst_EX),
    .pc_jump_address_EX(pc_jump_address_EX),
    .pc_incremented_EX(pc_incremented_EX),
    .pc_branch_value_EX(pc_branch_value_EX),
    .rs_data_EX(rs_data_EX),
    .rt_data_EX(rt_data_EX),
    .alu_result_EX(alu_result_EX),
    .rd_num_EX(rd_num_EX),
    .opcode_EX(opcode_EX),
    .clk(clk),
    .rst_b(rst_b),
    .flush(flush),
    .stall(stall),
    .reg_dest_MEM(reg_dest_MEM),
    .reg_write_enable_MEM(reg_write_enable_MEM),
    .mem_or_reg_MEM(mem_or_reg_MEM),
    .pc_or_mem_MEM(pc_or_mem_MEM),
    .jump_MEM(jump_MEM),
    .jump_register_MEM(jump_register_MEM),
    .is_unsigned_MEM(is_unsigned_MEM),
    .zero_MEM(zero_MEM),
    .negative_MEM(negative_MEM),
    .inst_MEM(inst_MEM),
    .pc_jump_address_MEM(pc_jump_address_MEM),
    .pc_incremented_MEM(pc_incremented_MEM),
    .pc_branch_value_MEM(pc_branch_value_MEM),
    .rs_data_MEM(rs_data_MEM),
    .rt_data_MEM(rt_data_MEM),
    .alu_result_MEM(alu_result_MEM),
    .rd_num_MEM(rd_num_MEM),
    .opcode_MEM(opcode_MEM),
    .should_branch_MEM(should_branch_MEM),
    .float_reg_write_enable_EX(float_reg_write_enable_EX),
    .float_reg_write_enable_MEM(float_reg_write_enable_MEM),
    .fp_regfile_mux_MEM(fp_regfile_mux_MEM),
    .fp_regfile_mux_EX(fp_regfile_mux_EX),
    .regfile_mux_MEM(regfile_mux_MEM),
    .regfile_mux_EX(regfile_mux_EX),
    .fs_data_MEM(fs_data_MEM),
    .fs_data_EX(fs_data_EX),
    .fp_alu_result_EX(fp_alu_result_EX),
    .fp_alu_result_MEM(fp_alu_result_MEM)
);


//MEM
wire fp_regfile_mux_MEM;
wire reg_dest_MEM;
wire reg_write_enable_MEM;
wire mem_or_reg_MEM;
wire pc_or_mem_MEM;
wire jump_MEM;
wire should_branch_MEM;
wire jump_register_MEM;
wire is_unsigned_MEM;
wire zero_MEM;
wire negative_MEM;
wire [31:0] inst_MEM;
wire [31:0] pc_jump_address_MEM;
wire [31:0] pc_incremented_MEM;
wire [31:0] pc_branch_value_MEM;
wire [31:0] rs_data_MEM;
wire [31:0] rt_data_MEM;
wire [31:0] alu_result_MEM;
wire [4:0] rd_num_MEM;
wire [5:0] opcode_MEM;
wire [31:0] fs_data_MEM;
wire [31 : 0 ]fp_alu_result_MEM;

wire reg_write_enable_MEM2 = reg_write_enable_MEM | reg_write_enable_cache;

assign mem_addr = alu_result_MEM;
assign memory_in = rt_data_MEM;
wire [XLEN - 1 : 0] pc_after_j_or_branch;
wire[XLEN -1 : 0 ] pc_value_after_branch;
Mux mux_if_branch(.select(branch_MEM),.in0(pc_incremented_IF),.in1(pc_branch_value_MEM),.out(pc_value_after_branch));
Mux mux_if_jump(.select(jump_MEM),.in0(pc_value_after_branch),.in1(pc_jump_address_MEM),.out(pc_after_j_or_branch));
Mux mux_jump_register(.select(jump_register_MEM),.in0(pc_after_j_or_branch),.in1(rs_data_MEM),.out(pc_input));

reg branch_MEM;
always @(should_branch_MEM ,zero_MEM , negative_MEM)begin //TODO: Big Bug (This part should be in datapath and only the should branch signal be activated)
        branch_MEM = 0;
        if (should_branch_MEM)begin
            case(opcode_MEM)
                BEQ: if(zero_MEM) branch_MEM = 1;
                BNE: if(~zero_MEM) branch_MEM = 1;
                BLEZ: if(zero_MEM || negative_MEM) branch_MEM = 1;
                BGTZ: if(~negative_MEM && ~zero_MEM) branch_MEM = 1;
                BGEZ: if(~negative_MEM) branch_MEM = 1;
                default:begin end
            endcase
        end
        // $display("should_branch = %d , branch = %d , zero = %d , negative = %d,opcode = %d",should_branch,branch,zero,negative,opcode);
    end

buff_MEM_WB buff_memwb(
    .memory_out_MEM(memory_out_MEM),
    .alu_result_MEM(alu_result_MEM),
    .rd_num_MEM(rd_num_MEM),
    .opcode_MEM(opcode_MEM),
    .reg_dest_MEM(reg_dest_MEM),
    .pc_incremented_MEM(pc_incremented_MEM),
    .reg_write_enable_MEM(reg_write_enable_MEM2),
    .mem_or_reg_MEM(mem_or_reg_MEM),
    .pc_or_mem_MEM(pc_or_mem_MEM),
    .clk(clk),
    .rst_b(rst_b),
    .flush(flush),
    .stall(stall),
    .memory_out_WB(memory_out_WB),
    .alu_result_WB(alu_result_WB),
    .rd_num_WB(rd_num_WB),
    .pc_incremented_WB(pc_incremented_WB),
    .opcode_WB(opcode_WB),
    .reg_dest_WB(reg_dest_WB),
    .reg_write_enable_WB(reg_write_enable_WB),
    .mem_or_reg_WB(mem_or_reg_WB),
    .pc_or_mem_WB(pc_or_mem_WB),
    .float_reg_write_enable_MEM(float_reg_write_enable_MEM),
    .float_reg_write_enable_WB(float_reg_write_enable_WB),
    .rt_data_WB(rt_data_WB),
    .rt_data_MEM(rt_data_MEM),
    .fp_regfile_mux_MEM(fp_regfile_mux_MEM),
    .fp_regfile_mux_WB(fp_regfile_mux_WB),
    .regfile_mux_MEM(regfile_mux_MEM),
    .regfile_mux_WB(regfile_mux_WB),
    .fs_data_MEM(fs_data_MEM),
    .fs_data_WB(fs_data_WB),
    .fp_alu_result_MEM(fp_alu_result_MEM),
    .fp_alu_result_WB(fp_alu_result_WB)
);


//WB
wire [31:0] memory_out_WB;
wire [31:0] alu_result_WB;
wire [31:0] pc_incremented_WB;
wire [4:0] rd_num_WB;
wire [5:0] opcode_WB;
wire reg_dest_WB;
wire reg_write_enable_WB;
wire float_reg_write_enable_WB;
wire mem_or_reg_WB;
wire pc_or_mem_WB;
wire fp_regfile_mux_WB;
wire [31 : 0] rt_data_WB, fp_alu_WB;
wire [31 : 0 ]fp_alu_result_WB;
wire [XLEN -1 : 0] mem_or_alu_write_data;
wire [XLEN -1 : 0]rd_data;
wire [XLEN -1 : 0]fd_data;
wire [XLEN -1 : 0]fs_data_WB;
wire [XLEN -1 : 0]memoralu_or_pc_incremented_mux_out;
wire [31:0] fs_data_WB;
wire regfile_mux_WB;

Mux mem_or_alu_result_mux(.select(mem_or_reg_WB),.in0(alu_result_WB),.in1(memory_out_WB),.out(mem_or_alu_write_data));

Mux memoralu_or_pc_incremented_mux(.select(pc_or_mem_WB),.in0(mem_or_alu_write_data),.in1(pc_incremented_WB),.out(memoralu_or_pc_incremented_mux_out));

Mux fp_reg_mux(.select(fp_regfile_mux_WB),.in1(rt_data_WB),.in0(fp_alu_result_WB),.out(fd_data));

Mux reg_mux(.select(regfile_mux_WB),.in0(memoralu_or_pc_incremented_mux_out),.in1(fs_data_WB),.out(rd_data));


integer x;
initial begin
    x = 0;
end
always @(negedge clk) begin
    $display("\n\n*************************************\nclock  %d\n\n",x);
    $display("fs_data_EX = %h, ft_data_EX = %h, alu_operation_EX = %d, fp_alu_result_EX = %h",fs_data_EX ,ft_data_EX, alu_operation_EX, fp_alu_result_EX);
    $display("rt_data ID, EX, MEM, WB = %h %h %h %h", rt_data_ID, rt_data_EX, rt_data_MEM, rt_data_WB);
    $display("fs_data = %h, ft_data = %h, fs_num = %h, ft_num = %h, fd_num = %h", fs_data_ID, ft_data_ID, inst_ID[25:21], inst_ID[20:16], rd_num_WB);
    $display("fd_data = %h", fd_data);
    $display("rd_data = %h", rd_data);
    $display("fs_data ID, EX, MEM, WB = %h %h %h %h", fs_data_ID, fs_data_EX, fs_data_MEM, fs_data_WB);
    $display("rd_num ID, EX, MEM, WB = %h %h %h %h", rd_num_ID, rd_num_EX, rd_num_MEM, rd_num_WB);
    $display("regfile_mux ID, EX, MEM, WB: %h %h %h %h", regfile_mux, regfile_mux_EX, regfile_mux_MEM, regfile_mux_WB);
    $display("fs_data ID, EX, MEM, WB = %h %h %h %h", fs_data_ID, fs_data_EX, fs_data_MEM, fs_data_WB);
    $display("func ID = %h, opcode_ID = %h", inst_ID[5 : 0], inst_ID[31 : 26]);
    $display("register_file_float[4] = %h", RegisterFile_Float.data[4]);
    $display("register_float[4] = %h", RegisterFile.data[4]);
    $display("reg_write_enable ID, EX, MEM, WB = %h %h %h %h", reg_write_enable, reg_write_enable_EX, reg_dest_MEM, reg_dest_WB);
    $display("fp_regfile_mux ID, EX, MEM, WB = %h %h %h %h", fp_regfile_mux, fp_regfile_mux_EX, fp_regfile_mux_MEM, fp_alu_result_WB);
    $display("float_reg_write_enable ID, EX, MEM, WB = %h %h %h %h", float_reg_write_enable, float_reg_write_enable_EX, float_reg_write_enable_MEM, float_reg_write_enable_WB);
    x = x + 1;
    // $display("does_shift_amount_need = %d alu_src =  %d alu_src_ID = %d alu_src_EX = %d immediate_ID_EX = %d %d",does_shift_amount_need, alu_src,alu_src_ID, alu_src_EX, immediate_data_ID, immediate_data_EX);
    // $display("alu second src = %d, alu first src = %d, alu result EX = %d, alu result MEM %d, alu_result_WB = %d", alu_second_source, alu_first_source, alu_result_EX, alu_result_MEM, alu_result_WB);
    // $display("reg_write_enable WB = %d, mem_or_reg = %d, pc_or_mem = %d, rd_data = %d, rd_num = %d", reg_write_enable_WB, mem_or_reg_WB, pc_or_mem_WB,rd_data,rd_num_WB);
    // $display("rd_num_ID/EX/MEM/WB = %d %d %d %d",rd_num_ID,rd_num_EX,rd_num_MEM,rd_num_WB);
    // $display("pc_or_mem = %d, reg_dst = %d",pc_or_mem, reg_dest);
    // $display("immediate ID,EX =  %d,%d" ,immediate_data_ID,immediate_data_EX);
    // $display("inst ID,EX,MEM =  %h,%h,%h" ,inst_ID,inst_EX,inst_MEM);
    
end


endmodule