module cache (
    data_out,
    hit,
    we,
    clk, 
    rst_b, 
    addr, 
    data_in,
    cache_miss_addr;    
);
    parameter XLEN = 32;
    parameter C_WIDTH = 13;//random 10 neveshatm dorost she
    parameter start = 0, top = (1<<13) - 1;
    parameter last_index = top >> 2;

    output [7:0] data_out[0:3];
    output hit;
    output [31 : 0] cache_miss_addr;

    input  [7:0] data_in[0:3];
    input [C_WIDTH - 1: 0] addr;
    input we;
    input clk;
    input rst_b;


    reg [7 : 0] mem [start:top];
    reg [18 : 0] cache_tags [start:last_index];
    reg dirty_bits [start:last_index];
    reg valid_bits [start:last_index];


    assign cache_miss_addr = {cache_tags[addr[12:2]] ,addr[12:2],2'b00};
    assign hit = (cache_tags[addr[12:2]] == adddr [31 : 13]) && (valid_bits[addr[12:2]] == 1) ? 1'b1 : 1'b0;
    
    assign data_out[0] = mem[addr[12:2]];
    assign data_out[1] = mem[addr[12:2] + 1];
    assign data_out[2] = mem[addr[12:2] + 2];
    assign data_out[3] = mem[addr[12:2] + 3];


    always_ff @(posedge clk) begin
        if(we) begin
            if(addr[31 : 18] == cache_tags[addr[12:2]]) begin
                dirty_bits [addr[12:2]] <= 1'b1;
                valid_bits [addr[12:2]] <= 1'b1;

                mem [addr[12:2]] <= data_in[0];
                mem [addr[12:2] + 1] <= data_in[1];
                mem [addr[12:2] + 2] <= data_in[2];
                mem [addr[12:2] + 3] <= data_in[3];
            end
            
        end

    end

endmodule