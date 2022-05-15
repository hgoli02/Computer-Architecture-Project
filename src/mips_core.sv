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
    output   wire [7:0]  mem_data_out[0:3];
    input  wire [7:0]  mem_data_in[0:3];
    output         mem_write_en;
    output reg     halted;
    input          clk;
    input          rst_b;

    wire memOrReg;
    wire aluSrc;
    wire [3:0] alu_operation;
    wire write_enable;
    wire regDest;

    data_path DataPath(
        .inst(inst),
        .mem_addr(mem_addr),
        .mem_data_in(mem_data_in),
        .mem_data_out(mem_data_out),
        .memOrReg(memOrReg),
        .aluSrc(aluSrc),
        .clk(clk),
        .rst_b(rst_b),
        .halted(halted),
        .alu_operation(alu_operation),
        .write_enable(write_enable),
        .regDest(regDest)
    );
    
   
endmodule
