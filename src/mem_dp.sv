module memory_datapath (
    data_out,
    addr,
    data_in,
    cache_we,
    clk,
    rst_b,
    mem_data_in,
    mem_data_out,
    mem_in_select,
    mem_addr,
    hit
);
    output [7:0] data_out[0:3];
    output [31:0] mem_addr;
    output [31:0] mem_data_in;
    output hit;
    
    input [31:0] mem_data_out;
    input [31:0] addr;
    input [7:0] data_in[0:3];
    input clk;
    input rst_b;

    wire[31:0] cache_miss_addr;
    
    cache Cache(
        .addr(addr),
        .data_in(mem_data_out),
        .data_out(data_out),
        .cache_miss_addr(cache_miss_addr),
        .we(cache_we),
        .hit(hit),
        .clk(clk), 
        .rst_b(rst_b)
    );

    assign mem_addr = mem_in_select == 1 ? cache_miss_addr : addr;
    assign mem_data_in = data_out;

endmodule