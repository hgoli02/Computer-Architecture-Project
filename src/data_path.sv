module data_path (
    inst, regDest, write_enable, aluSrc, alu_operation, mem_addr, mem_data_in,mem_data_out,
    memOrReg,clk,halted,rst_b
);
parameter XLEN = 32;
input clk, halted, rst_b;

input wire [XLEN - 1:0] inst ,mem_addr;

input  wire [7:0]  mem_data_in[0:3];
input  wire [7:0]  mem_data_out[0:3];
wire[XLEN - 1:0] memory_in;
wire[XLEN - 1:0] memory_out;


assign memory_in = {mem_data_in[0], mem_data_in[1], mem_data_in[2],mem_data_in[3]};      //TODO check indexes (!!!!)
assign memory_out = {mem_data_in[0], mem_data_in[1], mem_data_in[2],mem_data_in[3]};



input [3:0] alu_operation; //TODO: alu Operation number of bytes to be determined
input regDest; // R type and I type Mux from control unit
input write_enable; // register file write enable from control unit 
input aluSrc; //aluSrc
input memOrReg; // what data to write in reg file from control unit

wire isAluZero;
wire [XLEN - 1:0] data_s, data_t, data_d, alu_second_source,
                    alu_result;

wire [4:0] write_reg ;

Mux #(5) writeRegFileMux(.select(regDest),.in0(inst[20:16]),.in1(inst[15:11]),.out(write_reg));
Mux aluInputMux(.select(aluSrc),.in0(data_t),.in1({{16{inst[15]}}, inst[15:0]}),.out(alu_second_source));
Mux memOrAluResultMux(.select(memOrReg),.in0(alu_result),.in1(memory_out),.out(data_d));

ALU alu(.input1(data_s), .input2(alu_second_source), .out(alu_result), .zero(isAluZero),.alu_operation(alu_operation));

assign alu_result = mem_addr;
assign data_t = memory_in;


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