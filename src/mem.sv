module memory_cache (
    data_in, data_out, addr, hit, mem_we, opcode, mips_machine_data_in, mips_machine_data_out, mips_machine_addr, clk, rst_b, reg_write_enable
);
    output hit;
    output mem_we;
    output [7:0] mips_machine_data_in [0:3];
    output [7:0] data_out [0:3];
    output [31:0] mips_machine_addr;
    output reg_write_enable;
    input [7:0] data_in [0:3];
    input [31:0] addr;
    input [5:0] opcode;
    input clk, rst_b;
    input [7:0] mips_machine_data_out  [0:3];
    wire dirty_bit;
    wire mem_in_select;
    wire cache_in_select;
    wire cache_we;
    wire is_byte;

    memory_datapath Memory_datapath(
        .data_out(data_out),
        .addr(addr),
        .data_in(data_in),
        .cache_we(cache_we),
        .clk(clk),
        .rst_b(rst_b),
        .mem_data_in(mips_machine_data_in),
        .mem_data_out(mips_machine_data_out),
        .mem_addr(mips_machine_addr),
        .mem_in_select(mem_in_select),
        .hit(hit),
        .dirty_bit(dirty_bit),
        .is_byte(is_byte),
        .cache_in_select(cache_in_select)
    );    

    cache_cu Cache_cu(
        .dirty(dirty_bit),
        .cache_we(cache_we),
        .mem_we(mem_we),
        .mem_in_select(mem_in_select),
        .clk(clk),
        .rst_b(rst_b),
        .hit(hit),
        .opcode(opcode),
        .reg_write_enable(reg_write_enable),
        .cache_in_select(cache_in_select),
        .is_byte(is_byte)
    );

    // initial begin
    //     $monitor("data_in %b, data_out %b, addr %b, hit %b, mem_we %b,\nopcode %b, mips_machine_data_in %b, mips_machine_data_out %b, mips_machine_addr %b, clk %b, rst_b %b, dirty_bit,mem_in_select = %b,cache_in_select = %b,cache_we = %b,reg_write_enable = %bis_byte = %b",data_in, data_out, addr, hit, mem_we, opcode, mips_machine_data_in, mips_machine_data_out, mips_machine_addr, clk, rst_b,dirty_bit,mem_in_select,cache_in_select,cache_we,reg_write_enable, is_byte);
    // end
    
endmodule