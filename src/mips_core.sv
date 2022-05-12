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
    output  [31:0] inst_addr;
    input   [31:0] inst;
    output  [31:0] mem_addr;
    input   [7:0]  mem_data_out[0:3];
    output  [7:0]  mem_data_in[0:3];
    output         mem_write_en;
    output reg     halted;
    input          clk;
    input          rst_b;
    
    regfile RegisterFile(
        .rs_data(),
        .rt_data(),
        .rs_num(),
        .rt_num(),
        .rd_num(),
        .rd_data(),
        .rd_we(),
        .clk(clk),
        .rst_b(rst_b),
        .halted(halted)
    );
endmodule
