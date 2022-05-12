module data_path (
    inst, regDest, write_enable
);
parameter XLEN = 32;

input   [31:0] inst;

input regDest; // R type and I type Mux from control unit
input write_enable; // register file write enable from control unit 

wire [XLEN - 1:0] write_reg, data_s, data_t, data_d;

Mux writeRegFileMux(.select(regDest),.in0(inst[20:16]),.in1(inst[15:11]),.out(write_reg));

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