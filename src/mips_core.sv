module mips_core(
    inst_addr,
    inst,
    mem_addr,
    mem_data_out,
    mem_data_in,
    mem_write_en,
    halted,
    clk,
    rst_b
);
    parameter XLEN = 32;
    output  [XLEN - 1:0] inst_addr;
    input   [XLEN - 1:0] inst;
    output  [XLEN - 1:0] mem_addr;
    input   wire [7:0]  mem_data_out[0:3];
    output  wire [7:0]  mem_data_in[0:3];
    output         mem_write_en;
    output reg     halted;
    input          clk;
    input          rst_b;

    wire mem_or_reg;
    wire alu_src;
    wire [3:0] alu_operation;
    wire reg_write_enable;
    wire reg_dest;
    wire branch;
    wire jump;
    wire jump_register;
    wire pc_or_mem;
    wire link;
    wire does_shift_amount_need;
    wire reg_write_enable;

    data_path DataPath(
        .inst(inst),
        .inst_addr(inst_addr),
        .mem_addr(mem_addr),
        .mem_data_in(mem_data_in),
        .mem_data_out(mem_data_out),
        .mem_or_reg(mem_or_reg),
        .alu_src(alu_src),
        .clk(clk),
        .rst_b(rst_b),
        .halted(halted),
        .alu_operation(alu_operation),
        .reg_write_enable(reg_write_enable),
        .reg_dest(reg_dest),
        .branch(branch),
        .jump(jump),
        .jump_register(jump_register),
        .pc_or_mem(pc_or_mem),
        .link(link),
        .does_shift_amount_need(does_shift_amount_need)
    );

    control_unit ControlUnit(
        .halted(halted),
        .opcode(inst[31:26]),
        .func(inst[5:0]),
        .alu_src(alu_src),
        .reg_dest(reg_dest), 
        .link(link),
        .pc_or_mem(pc_or_mem),
        .mem_or_reg(mem_or_reg),
        .branch(branch),
        .jump_register(jump_register),
        .jump(jump),
        .reg_write_enable(reg_write_enable),
        .does_shift_amount_need(does_shift_amount_need),
        .alu_operation(alu_operation),
        .mem_write_en(mem_write_en)
    );
    
   
endmodule
