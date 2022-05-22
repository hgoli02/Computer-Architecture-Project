module data_path (
    inst,inst_addr , reg_dest, reg_write_enable, alu_src, alu_operation, mem_addr, mem_data_in,mem_data_out,
    mem_or_reg,clk,halted,rst_b,branch,jump,jump_register,pc_or_mem,link,does_shift_amount_need,zero,negative,
    is_unsigned

);
parameter XLEN = 32;
input clk, halted, rst_b;
input wire [XLEN - 1:0] inst;
output wire[XLEN - 1:0] mem_addr, inst_addr;

output  wire [7:0]  mem_data_in[0:3];
input  wire [7:0]  mem_data_out[0:3];
wire[XLEN - 1:0] memory_in;
wire[XLEN - 1:0] memory_out;


assign memory_in = {mem_data_in[0], mem_data_in[1], mem_data_in[2],mem_data_in[3]};      //TODO check indexes (!!!!)
assign memory_out = {mem_data_in[0], mem_data_in[1], mem_data_in[2],mem_data_in[3]};



input [3:0] alu_operation;
input reg_dest; // R type and I type Mux from control unit
input reg_write_enable; // register file write enable from control unit 
input alu_src; //alu_src
input mem_or_reg; // what data to write in reg file from control unit
input pc_or_mem;
input link;
input branch;
input jump;
input jump_register;
input does_shift_amount_need;
input is_unsigned;
output zero;
output negative;
wire [XLEN - 1:0] rs_data, rt_data, rd_data, alu_second_source,alu_first_source,
                    alu_result;

wire [4:0] write_reg_num_inst;
wire [4:0] rd_num;


Mux #(5) write_reg_file_mux(.select(reg_dest),.in0(inst[20:16]),.in1(inst[15:11]),.out(write_reg_num_inst));
Mux #(5) write_reg_if_jal_mux(.select(link),.in0(write_reg_num_inst),.in1(5'd31),.out(rd_num));

wire [XLEN -1 : 0] mem_or_alu_write_data;
Mux mem_or_alu_result_mux(.select(mem_or_reg),.in0(alu_result),.in1(memory_out),.out(mem_or_alu_write_data));
Mux memoralu_or_pc_incremented_mux(.select(pc_or_mem),.in0(mem_or_alu_write_data),.in1(pc_incremented),.out(rd_data));

wire[XLEN - 1 : 0] shift_amount_32bit;
assign shift_amount_32bit = {{(XLEN - 5){1'b0}},inst[10:6]};

wire [XLEN -1 : 0] sign_extended_first16bit_inst;
assign sign_extended_first16bit_inst = {{(XLEN/2){inst[15]}}, inst[15:0]};
wire [XLEN -1 : 0] immediate_data;

Mux unsigned_mux(.select(is_unsigned),.in0(sign_extended_first16bit_inst),.in1({{(XLEN/2){1'b0}},inst[15:0]}),.out(immediate_data));

Mux alu_input2_mux(.select(alu_src),.in0(rt_data),.in1(immediate_data),.out(alu_second_source));

Mux select_shift_amount_mux(.select(does_shift_amount_need),.in0(rs_data),.in1(shift_amount_32bit),.out(alu_first_source));

ALU alu(.input1(alu_first_source), .input2(alu_second_source), .out(alu_result), .zero(zero),.negative(negative),.alu_operation(alu_operation));

assign mem_addr = alu_result;
assign memory_in = rt_data;


wire[XLEN -1 : 0] pc_value;
wire[XLEN -1 : 0] pc_input;
assign inst_addr = pc_value;
Register pc(.clk(clk),.reset(rst_b),.data_in(pc_input),.data(pc_value),.we(1'b1));


wire[XLEN -1 : 0 ] pc_incremented;
Adder pc_incrementer(pc_value,32'd4,pc_incremented);

wire [XLEN -1 : 0] shifted_first16bit_extended_inst;
assign shifted_first16bit_extended_inst = sign_extended_first16bit_inst << 2;


wire[XLEN -1 : 0 ] pc_branch_value;
Adder pc_branch(pc_incremented,shifted_first16bit_extended_inst,pc_branch_value);


wire[XLEN -1 : 0 ] pc_value_after_branch;

Mux mux_if_branch(.select(branch),.in0(pc_incremented),.in1(pc_branch_value),.out(pc_value_after_branch));

wire [XLEN - 5 : 0] shifted_first26bit_inst;
assign shifted_first26bit_inst = {2'b0,inst[25:0]} << 2;

wire [XLEN - 1 : 0] pc_jump_address;
assign pc_jump_address = {pc_incremented[31:28],shifted_first26bit_inst};

wire [XLEN - 1 : 0] pc_after_j_or_branch;
Mux mux_if_jump(.select(jump),.in0(pc_value_after_branch),.in1(pc_jump_address),.out(pc_after_j_or_branch));

Mux mux_jump_register(.select(jump_register),.in0(pc_after_j_or_branch),.in1(rs_data),.out(pc_input));


regfile RegisterFile(
        .rs_data(rs_data),
        .rt_data(rt_data),
        .rs_num(inst[25:21]),
        .rt_num(inst[20:16]),
        .rd_num(rd_num),
        .rd_data(rd_data),
        .rd_we(reg_write_enable),
        .clk(clk),
        .rst_b(rst_b),
        .halted(halted)
    );

always @(posedge clk) begin
    $display($time, " rd=%d ,inp1_alu = %d ,inp2_alu = %d ,rd_data=%d , does_sh = %b", rd_num,alu_first_source,alu_second_source,rd_data,does_shift_amount_need);
end

endmodule