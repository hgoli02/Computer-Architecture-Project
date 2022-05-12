module data_path (
    inst, regDest, write_enable, aluSrc, aluOperation, mem_addr, mem_data_in,mem_data_out,
    memOrReg
);
parameter XLEN = 32;

input wire [XLEN - 1:0] inst , mem_data_in, mem_data_out,mem_addr;

input [3:0] aluOperation; //TODO: alu Operation number of bytes to be determined
input regDest; // R type and I type Mux from control unit
input write_enable; // register file write enable from control unit 
input aluSrc; //aluSrc
input memOrReg; // what data to write in reg file from control unit

wire isAluZero;
wire [XLEN - 1:0] write_reg, data_s, data_t, data_d, alu_second_source,
                    alu_result;

Mux writeRegFileMux(.select(regDest),.in0(inst[20:16]),.in1(inst[15:11]),.out(write_reg));
Mux aluInputMux(.select(aluSrc),.in0(data_t),.in1({{16{inst[15]}}, inst[15:0]}),.out(alu_second_source));
Mux memOrAluResultMux(.select(memOrReg),.in0(alu_result),.in1(mem_data_out),.out(data_d));

ALU alu(.input1(data_s), .input2(alu_second_source), .out(alu_result), .zero(isAluZero),.alu_operation(aluOperation));

assign mem_addr = alu_result;
assign mem_data_in = data_t;


regfile RegisterFile(
        .rs_data(data_s),
        .rt_data(data_t),
        .rs_num(inst[25:21]),
        .rt_num(inst[20:16]),
        .rd_num(write_reg),
        .rd_data(data_d),
        .rd_we(write_enable),
        .clk(clk),
        .rst_b(rst_b),
        .halted(halted)
    );

endmodule