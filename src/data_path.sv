module data_path (
    inst,inst_addr , regDest, reg_write_enable, aluSrc, alu_operation, mem_addr, mem_data_in,mem_data_out,
    memOrReg,clk,halted,rst_b,branch,jump,jump_register
);
parameter XLEN = 32;
input clk, halted, rst_b;
input wire [XLEN - 1:0] inst,inst_addr;
output wire[XLEN - 1:0] mem_addr;

input  wire [7:0]  mem_data_in[0:3];
input  wire [7:0]  mem_data_out[0:3];
wire[XLEN - 1:0] memory_in;
wire[XLEN - 1:0] memory_out;


assign memory_in = {mem_data_in[0], mem_data_in[1], mem_data_in[2],mem_data_in[3]};      //TODO check indexes (!!!!)
assign memory_out = {mem_data_in[0], mem_data_in[1], mem_data_in[2],mem_data_in[3]};



input [3:0] alu_operation; //TODO: alu Operation number of bytes to be determined
input regDest; // R type and I type Mux from control unit
input reg_write_enable; // register file write enable from control unit 
input aluSrc; //aluSrc
input memOrReg; // what data to write in reg file from control unit
input branch;
input jump;
input jump_register;
wire zero;
wire negative;
wire [XLEN - 1:0] rs_data, rt_data, data_d, alu_second_source,
                    alu_result;

wire [4:0] write_reg ;

wire [XLEN -1 : 0] sign_extended_first16bit_inst;
assign sign_extended_first16bit_inst = {{16{inst[15]}}, inst[15:0]};

Mux #(5) writeRegFileMux(.select(regDest),.in0(inst[20:16]),.in1(inst[15:11]),.out(write_reg));
Mux aluInputMux(.select(aluSrc),.in0(rt_data),.in1(sign_extended_first16bit_inst),.out(alu_second_source));
Mux memOrAluResultMux(.select(memOrReg),.in0(alu_result),.in1(memory_out),.out(data_d));


ALU alu(.input1(rs_data), .input2(alu_second_source), .out(alu_result), .zero(zero),.negative(negative),.alu_operation(alu_operation));

assign mem_addr = alu_result;
assign memory_in = rt_data;


wire[XLEN -1 : 0] pc_value;
wire[XLEN -1 : 0] pc_input;
assign pc_value = inst_addr;
register pc(.clk(clk),.reset(rst_b),.data_in(pc_input),.data(pc_value),.we(1'b1));


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
        .rd_num(write_reg),
        .rd_data(data_d),
        .rd_we(reg_write_enable),
        .clk(clk),
        .rst_b(rst_b),
        .halted(halted)
    );


endmodule