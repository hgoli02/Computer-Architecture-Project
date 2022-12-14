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
    wire [4:0] alu_operation;
    wire reg_write_enable;
    wire reg_dest;
    wire branch;
    wire jump;
    wire jump_register;
    wire pc_or_mem;
    wire link;
    wire does_shift_amount_need;
    wire reg_write_enable;
    wire negative;
    wire zero;
    wire is_unsigned;
    wire pc_we;
    wire hit;
    wire should_branch;
    wire flush = 0;
    wire stall;
    wire reg_write_enable_cache;
    wire [31:0] inst_ID;
    wire [31:0] inst_MEM;
    wire [31:0] inst_EX;
    wire float_reg_write_enable;
    wire regfile_mux;
    wire fp_regfile_mux;

    data_path DataPath(
        .regfile_mux(regfile_mux),
        .fp_regfile_mux(fp_regfile_mux),
        .inst(inst),
        .inst_addr(inst_addr),
        .mem_addr(datapath_mem_addr), 
        .mem_data_in(data_in_datapath),
        .mem_data_out(data_out_datapath),
        .mem_or_reg(mem_or_reg),
        .alu_src(alu_src),
        .clk(clk),
        .rst_b(rst_b),
        .halted(halted),
        .alu_operation(alu_operation),
        .reg_write_enable(reg_write_enable),
        .reg_write_enable_cache(reg_write_enable_cache),
        .reg_dest(reg_dest),
        .branch(branch),
        .jump(jump),
        .jump_register(jump_register),
        .pc_or_mem(pc_or_mem),
        .does_shift_amount_need(does_shift_amount_need),
        .zero(zero),
        .negative(negative),
        .is_unsigned(is_unsigned),
        .pc_we(pc_we),
        .flush(flush),
        .stall(stall),
        .inst_ID(inst_ID),
        .inst_MEM(inst_MEM),
        .inst_EX(inst_EX),
        .should_branch(should_branch),
        .float_reg_write_enable(float_reg_write_enable)
    );

    control_unit ControlUnit(
        .regfile_mux(regfile_mux),
        .fp_regfile_mux(fp_regfile_mux),
        .halted(halted),
        .inst_ID(inst_ID),
        .inst_MEM(inst_MEM),
        .inst_EX(inst_EX),
        .alu_src(alu_src),
        .reg_dest(reg_dest), 
        .pc_or_mem(pc_or_mem),
        .mem_or_reg(mem_or_reg),
        .branch(branch),
        .jump_register(jump_register),
        .jump(jump),
        .reg_write_enable(reg_write_enable),
        .does_shift_amount_need(does_shift_amount_need),
        .alu_operation(alu_operation),
        .mem_write_en(mem_write_en),
        .zero(zero),
        .negative(negative),
        .is_unsigned(is_unsigned),
        .pc_we(pc_we),
        .hit(hit),
        .should_branch(should_branch),
        .stall(stall),
        .float_reg_write_enable(float_reg_write_enable)
    );

    wire [7:0] data_out_datapath[0:3];
    wire [7:0] data_in_datapath[0:3];
    wire [XLEN - 1:0] datapath_mem_addr;
    
    memory_cache mem(
        .data_in(data_in_datapath),
        .data_out(data_out_datapath),
        .addr(datapath_mem_addr),
        .hit(hit),
        .mem_we(mem_write_en),
        .opcode(inst_MEM[31:26]),
        .mips_machine_data_in(mem_data_in),
        .mips_machine_data_out(mem_data_out),
        .mips_machine_addr(mem_addr),
        .clk(clk),
        .reg_write_enable(reg_write_enable_cache),
        .rst_b(rst_b),
        .stall(stall)
    );

    // wire [XLEN - 1:0] datapath_mem_addr;
  
    // wire cache_we;
    // wire hit;
    // wire dirty_bit;
    // wire mem_in_select;
    // wire cache_in_select;
    // wire mem_we;
    // wire is_byte;
    
    // memory_datapath Memory_datapath(
    //     .data_out(data_out_datapath),
    //     .addr(datapath_mem_addr),
    //     .data_in(data_in_datapath),
    //     .cache_we(cache_we),
    //     .clk(clk),
    //     .rst_b(rst_b),
    //     .mem_data_in(mem_data_in),
    //     .mem_data_out(mem_data_out),
    //     .mem_addr(mem_addr),
    //     .mem_in_select(mem_in_select),
    //     .hit(hit),
    //     .dirty_bit(dirty_bit),
    //     .is_byte(is_byte),
    //     .cache_in_select(cache_in_select)
    // );    

    // cache_cu Cache_cu(
    // .dirty(dirty_bit),
    // .cache_we(cache_we),
    // .mem_we(mem_write_en),
    // .mem_in_select(mem_in_select),
    // .clk(clk),
    // .rst_b(rst_b),
    // .hit(hit),
    // .opcode(opcode),
    // .reg_write_enable(reg_write_enable),
    // .cache_in_select(cache_in_select),
    // .is_byte(is_byte)
    // );
    
// always @(*) begin
//     $display("we = %b ,mem_addr = %h , mem_in = %h, mem_out = %h",mem_write_en,mem_addr,{mem_data_in[3],mem_data_in[2],mem_data_in[1],mem_data_in[0]},
//      {mem_data_out[3],mem_data_out[2],mem_data_out[1],mem_data_out[0]});
// end

endmodule
