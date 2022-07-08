module buff_IF_ID(pc_incremented_IF,pc_incremented_ID, inst_IF,inst_ID, clk, rst_b, flush, stall);
    output [31:0] pc_incremented_ID;
    output [31:0] inst_ID;
    input [31:0] pc_incremented_IF;
    input [31:0] inst_IF;
    input flush, stall, clk, rst_b;
    Register pc_inc_reg (.clk(clk), .rst_b(rst_b),.data_in(pc_incremented_IF), .data_out(pc_incremented_ID), .we(~stall));
    Register instruction_reg (.clk(clk), .rst_b(rst_b), .data_in(inst_IF), .data_out(inst_ID), .we(~stall));
endmodule

module buff_IF_EX(
    input reg_dest_ID,
    input reg_write_enable_ID,
    input alu_src_ID,
    input mem_or_reg_ID,
    input pc_or_mem_ID,
    input branch_ID,
    input jump_ID,
    input jump_register_ID,
    input does_shift_amount_need_ID,
    input is_unsigned_ID,
    input [31:0] inst_ID,
    input [31:0] pc_jump_address_ID,
    input [31:0] pc_incremented_ID,
    input [31:0] rs_data_ID,
    input [31:0] rt_data_ID,
    input [31:0] shift_amount_32bit_ID,
    input [31:0] shifted_first16bit_extended_inst_ID,
    input [31:0] immediate_data_ID,
    input [3:0] alu_operation_ID,
    input [4:0] rd_num_ID,
    input [5:0] opcode_ID,

    input clk, rst_b, flush, stall,

    output reg_dest_EX,
    output reg_write_enable_EX,
    output alu_src_EX,
    output mem_or_reg_EX,
    output pc_or_mem_EX,
    output branch_EX,
    output jump_EX,
    output jump_register_EX,
    output does_shift_amount_need_EX,
    output is_unsigned_EX,
    output [31:0] pc_jump_address_EX,
    output [31:0] pc_incremented_EX,
    output [31:0] rs_data_EX,
    output [31:0] rt_data_EX,
    output [31:0] shift_amount_32bit_EX,
    output [31:0] shifted_first16bit_extended_inst_EX,
    output [31:0] immediate_data_EX,
    output [31:0] inst_EX,
    output [3:0] alu_operation_EX,
    output [4:0] rd_num_EX,
    output [5:0] opcode_EX);

    Register #(1) reg_dest_reg(.clk(clk),.rst_b(rst_b),.data_in(reg_dest_ID),.data_out(reg_dest_EX),.we(~stall));
    Register #(1) reg_write_enable_reg(.clk(clk),.rst_b(rst_b),.data_in(reg_write_enable_ID),.data_out(reg_write_enable_EX),.we(~stall));
    Register #(1) alu_src_reg(.clk(clk),.rst_b(rst_b),.data_in(alu_src_ID),.data_out(alu_src_EX),.we(~stall));
    Register #(1) mem_or_reg_reg(.clk(clk),.rst_b(rst_b),.data_in(mem_or_reg_ID),.data_out(mem_or_reg_EX),.we(~stall));
    Register #(1) pc_or_mem_reg(.clk(clk),.rst_b(rst_b),.data_in(pc_or_mem_ID),.data_out(pc_or_mem_EX),.we(~stall));
    Register #(1) branch_reg(.clk(clk),.rst_b(rst_b),.data_in(branch_ID),.data_out(branch_EX),.we(~stall));
    Register #(1) jump_reg(.clk(clk),.rst_b(rst_b),.data_in(jump_ID),.data_out(jump_EX),.we(~stall));
    Register #(1) jump_register_reg(.clk(clk),.rst_b(rst_b),.data_in(jump_register_ID),.data_out(jump_register_EX),.we(~stall));
    Register #(1) does_shift_amount_need_reg(.clk(clk),.rst_b(rst_b),.data_in(does_shift_amount_need_ID),.data_out(does_shift_amount_need_EX),.we(~stall));
    Register #(1) is_unsigned_reg(.clk(clk),.rst_b(rst_b),.data_in(is_unsigned_ID),.data_out(is_unsigned_EX),.we(~stall));


    Register inst_reg(.clk(clk),.rst_b(rst_b),.data_in(inst_ID),.data_out(inst_EX),.we(~stall));
    Register pc_jump_address_reg(.clk(clk),.rst_b(rst_b),.data_in(pc_jump_address_ID),.data_out(pc_jump_address_EX),.we(~stall));
    Register pc_incremented_reg(.clk(clk),.rst_b(rst_b),.data_in(pc_incremented_ID),.data_out(pc_incremented_EX),.we(~stall));
    Register rs_data_reg(.clk(clk),.rst_b(rst_b),.data_in(rs_data_ID),.data_out(rs_data_EX),.we(~stall));
    Register rt_data_reg(.clk(clk),.rst_b(rst_b),.data_in(rt_data_ID),.data_out(rt_data_EX),.we(~stall));
    Register shift_amount_32bit_reg(.clk(clk),.rst_b(rst_b),.data_in(shift_amount_32bit_ID),.data_out(shift_amount_32bit_EX),.we(~stall));
    Register shifted_first16bit_extended_inst_reg(.clk(clk),.rst_b(rst_b),.data_in(shifted_first16bit_extended_inst_ID),.data_out(shifted_first16bit_extended_inst_EX),.we(~stall));
    Register immediate_data_reg(.clk(clk),.rst_b(rst_b),.data_in(immediate_data_ID),.data_out(immediate_data_EX),.we(~stall));
    
    Register #(4) alu_operation_reg(.clk(clk),.rst_b(rst_b),.data_in(alu_operation_ID),.data_out(alu_operation_EX),.we(~stall));
    Register #(5) rd_num_reg(.clk(clk),.rst_b(rst_b),.data_in(rd_num_ID),.data_out(rd_num_EX),.we(~stall));
    Register #(6) opcode_reg(.clk(clk),.rst_b(rst_b),.data_in(opcode_ID),.data_out(opcode_EX),.we(~stall));
    

endmodule

module buff_EX_MEM(
    input reg_dest_EX,
    input reg_write_enable_EX,
    input mem_or_reg_EX,
    input pc_or_mem_EX,
    input branch_EX,
    input jump_EX,
    input jump_register_EX,
    input is_unsigned_EX,
    input zero_EX,
    input negative_EX,
    input [31:0] inst_EX,
    input [31:0] pc_jump_address_EX,
    input [31:0] pc_incremented_EX,
    input [31:0] pc_branch_value_EX,
    input [31:0] rs_data_EX,
    input [31:0] rt_data_EX,
    input [31:0] alu_result_EX,
    input [4:0] rd_num_EX,
    input [5:0] opcode_EX,

    input clk, rst_b, flush, stall,

    output reg_dest_MEM,
    output reg_write_enable_MEM,
    output mem_or_reg_MEM,
    output pc_or_mem_MEM,
    output branch_MEM,
    output jump_MEM,
    output jump_register_MEM,
    output is_unsigned_MEM,
    output zero_MEM,
    output negative_MEM,
    output [31:0] inst_MEM,
    output [31:0] pc_jump_address_MEM,
    output [31:0] pc_incremented_MEM,
    output [31:0] pc_branch_value_MEM,
    output [31:0] rs_data_MEM,
    output [31:0] rt_data_MEM,
    output [31:0] alu_result_MEM,
    output [4:0]  rd_num_MEM,
    output [5:0]  opcode_MEM);


    Register #(1) reg_dest_reg(.clk(clk),.rst_b(rst_b),.data_in(reg_dest_EX),.data_out(reg_dest_MEM),.we(~stall));
    Register #(1) reg_write_enable_reg(.clk(clk),.rst_b(rst_b),.data_in(reg_write_enable_EX),.data_out(reg_write_enable_MEM),.we(~stall));
    Register #(1) mem_or_reg_reg(.clk(clk),.rst_b(rst_b),.data_in(mem_or_reg_EX),.data_out(mem_or_reg_MEM),.we(~stall));
    Register #(1) pc_or_mem_reg(.clk(clk),.rst_b(rst_b),.data_in(pc_or_mem_EX),.data_out(pc_or_mem_MEM),.we(~stall));
    Register #(1) branch_reg(.clk(clk),.rst_b(rst_b),.data_in(branch_EX),.data_out(branch_MEM),.we(~stall));
    Register #(1) jump_reg(.clk(clk),.rst_b(rst_b),.data_in(jump_EX),.data_out(jump_MEM),.we(~stall));
    Register #(1) jump_register_reg(.clk(clk),.rst_b(rst_b),.data_in(jump_register_EX),.data_out(jump_register_MEM),.we(~stall));
    Register #(1) is_unsigned_reg(.clk(clk),.rst_b(rst_b),.data_in(is_unsigned_EX),.data_out(is_unsigned_MEM),.we(~stall));
    Register #(1) zero_reg(.clk(clk),.rst_b(rst_b),.data_in(zero_EX),.data_out(zero_MEM),.we(~stall));
    Register #(1) negative_reg(.clk(clk),.rst_b(rst_b),.data_in(negative_EX),.data_out(negative_MEM),.we(~stall));


    
    Register inst_reg(.clk(clk),.rst_b(rst_b),.data_in(inst_EX),.data_out(inst_MEM),.we(~stall));
    Register pc_jump_address_reg(.clk(clk),.rst_b(rst_b),.data_in(pc_jump_address_EX),.data_out(pc_jump_address_MEM),.we(~stall));
    Register pc_incremented_reg(.clk(clk),.rst_b(rst_b),.data_in(pc_incremented_EX),.data_out(pc_incremented_MEM),.we(~stall));
    Register pc_branch_value_reg(.clk(clk),.rst_b(rst_b),.data_in(pc_branch_value_EX),.data_out(pc_branch_value_MEM),.we(~stall));
    Register rs_data_reg(.clk(clk),.rst_b(rst_b),.data_in(rs_data_EX),.data_out(rs_data_MEM),.we(~stall));
    Register rt_data_reg(.clk(clk),.rst_b(rst_b),.data_in(rt_data_EX),.data_out(rt_data_MEM),.we(~stall));
    Register alu_result_reg(.clk(clk),.rst_b(rst_b),.data_in(alu_result_EX),.data_out(alu_result_MEM),.we(~stall));
    
    Register #(5) rd_num_reg(.clk(clk),.rst_b(rst_b),.data_in(rd_num_EX),.data_out(rd_num_MEM),.we(~stall));
    Register #(6) opcode_reg(.clk(clk),.rst_b(rst_b),.data_in(opcode_EX),.data_out(opcode_MEM),.we(~stall));
    

endmodule
    // Register _reg(.clk(clk),.rst_b(rst_b),.data_in(),.data_out(),.we(~stall));

module buff_MEM_WB(
    input [31:0] memory_out_MEM,
    input [31:0] alu_result_MEM,
    input [4:0] rd_num_MEM,
    input [5:0] opcode_MEM,
    input reg_dest_MEM,
    input reg_write_enable_MEM,
    input mem_or_reg_MEM,
    input pc_or_mem_MEM,
    input [31:0] pc_incremented_MEM,
    input clk,
    input rst_b,
    input flush,
    input stall,
    

    output [31:0] memory_out_WB,
    output [31:0] alu_result_WB,
    output [31:0] pc_incremented_WB,
    output [4:0] rd_num_WB,
    output [5:0] opcode_WB,
    output reg_dest_WB,
    output reg_write_enable_WB,
    output mem_or_reg_WB,
    output pc_or_mem_WB);

    Register #(1) reg_dest_reg(.clk(clk),.rst_b(rst_b),.data_in(reg_dest_MEM),.data_out(reg_dest_WB),.we(~stall));
    Register #(1) reg_write_enable_reg(.clk(clk),.rst_b(rst_b),.data_in(reg_write_enable_MEM),.data_out(reg_write_enable_WB),.we(~stall));
    Register #(1) mem_or_reg_reg(.clk(clk),.rst_b(rst_b),.data_in(mem_or_reg_MEM),.data_out(mem_or_reg_WB),.we(~stall));
    Register #(1) pc_or_mem_reg(.clk(clk),.rst_b(rst_b),.data_in(pc_or_mem_MEM),.data_out(pc_or_mem_WB),.we(~stall));

    Register memory_out_reg(.clk(clk),.rst_b(rst_b),.data_in(memory_out_MEM),.data_out(memory_out_WB),.we(~stall));
    Register alu_result_reg(.clk(clk),.rst_b(rst_b),.data_in(alu_result_MEM),.data_out(alu_result_WB),.we(~stall));
    Register pc_incremented_reg(.clk(clk),.rst_b(rst_b),.data_in(pc_incremented_MEM),.data_out(pc_incremented_WB),.we(~stall));

    Register #(5) rd_num_reg(.clk(clk),.rst_b(rst_b),.data_in(rd_num_MEM),.data_out(rd_num_WB),.we(~stall));
    Register #(6) opcode_reg(.clk(clk),.rst_b(rst_b),.data_in(opcode_MEM),.data_out(opcode_WB),.we(~stall));
    
endmodule
