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
    dirty_bit,
    cache_in_select,
    is_byte,
    hit
);
    output [7:0] data_out[0:3];
    output [31:0] mem_addr;
    output [7:0] mem_data_in[0:3];
    output hit;
    output dirty_bit;

    input [7:0] mem_data_out[0:3];
    input [31:0] addr;
    input [7:0] data_in[0:3];
    input clk;
    input rst_b;
    input mem_in_select;
    input cache_we;
    input cache_in_select;
    input is_byte;

    wire[31:0] cache_miss_addr;
    wire [7:0] cache_data_in [0:3];

    assign cache_data_in = (cache_in_select == 1) ? data_in : mem_data_out; 
    
    cache Cache(
        .addr(addr),
        .data_in(cache_data_in),
        .dirty_bit(dirty_bit),
        .data_out(data_out),
        .cache_miss_addr(cache_miss_addr),
        .we(cache_we),
        .hit(hit),
        .clk(clk), 
        .is_byte(is_byte),
        .rst_b(rst_b)
    );

    always @(negedge clk) begin
        $display("cache_addr = %h mem_addr = %h hit = %h mem_data_out = %h cache_data_out = %h data_in = %d mem_data_in = %d",addr, mem_addr, hit,mem_data_out, data_out,data_in,mem_data_in);
    end

    assign mem_addr = mem_in_select == 1 ? cache_miss_addr : addr;
    assign mem_data_in = data_out;

endmodule