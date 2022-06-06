module cache (
    data_out,
    hit,
    cache_miss_addr,
    dirty_bit,
    we,
    clk, 
    rst_b, 
    addr, 
    is_byte,
    data_in    
);
    parameter XLEN = 32;
    parameter C_WIDTH = 19;
    parameter start = 0, top = (1<<13) - 1;
    parameter last_index = top >> 2;

    output [7:0] data_out[0:3];
    output hit;
    output [31:0] cache_miss_addr;
    output dirty_bit;

    input  [7:0] data_in[0:3];
    input [31: 0] addr;
    input we;
    input clk;
    input rst_b;
    input is_byte;


    reg [7 : 0] mem [start:top];
    reg [C_WIDTH - 1: 0] cache_tags [start:last_index];
    reg dirty_bits [start:last_index];
    reg valid_bits [start:last_index];


    assign cache_miss_addr = {cache_tags[addr[12:2]] ,addr[12:2],2'b00};
    assign hit = (cache_tags[addr[12:2]] == addr [31:13]) && (valid_bits[addr[12:2]] == 1) ? 1'b1 : 1'b0;
    assign dirty_bit = dirty_bits[addr[12:2]];

    always @(hit) begin
        $display("cache tag = %h, addr[31:13] = %h  valid bit = %h",cache_tags[addr[12:2]],addr [31 : 13],valid_bits[addr[12:2]]);
    end

    //wire [31:0] ea = addr & 31'hfffffffc;
    wire [12:0] ea = addr[12:0] & 13'h1ffc;
    // wire [31:0] ei = ea >> 2;

    // assign data_out[0] = mem[ea];
    // assign data_out[1] = mem[ea + 1];
    // assign data_out[2] = mem[ea + 2];
    // assign data_out[3] = mem[ea + 3];

    assign data_out[0] = is_byte ? mem[addr[12:0]] : mem[ea];
    assign data_out[1] = is_byte ? {8{mem[addr[12:0]][7]}} : mem[ea + 1];
    assign data_out[2] = is_byte ? {8{mem[addr[12:0]][7]}} : mem[ea + 2];
    assign data_out[3] = is_byte ? {8{mem[addr[12:0]][7]}} : mem[ea + 3];



    always_ff @(posedge clk, negedge rst_b) begin
        if (rst_b == 0) begin
            integer i;

            for (i = start; i < top ; i = i + 1) begin
                mem[i] <= 0;
            end
            
            for (i = start; i < last_index ; i = i + 1) begin
                valid_bits[i] <= 0;
                dirty_bits[i] <= 0;
                cache_tags[i] <= 0;
            end
        end else begin
            if (we) begin
                if (addr[31:13] == cache_tags[addr[12:2]]) begin
                        dirty_bits [addr[12:2]] <= 1'b1;
                    end else begin
                        dirty_bits [addr[12:2]] <= 1'b0;
                    end
                    valid_bits [addr[12:2]] <= 1'1;
                    cache_tags[addr[12:2]] <= addr[31:13];


                if (is_byte) begin
                    if(ea == addr[12:0])  
                        mem [ea]    <= data_in[0];
                    else if (ea + 1 == addr[12:0])
                        mem[ea + 1] <= data_in[1];
                    else if (ea + 2 == addr[12:0])
                        mem[ea + 2] <= data_in[2];
                    else 
                        mem[ea + 3] <= data_in[3];                        
                end else begin
                    mem [ea] <= data_in[0];
                    mem [ea + 1] <= data_in[1];
                    mem [ea + 2] <= data_in[2];
                    mem [ea + 3] <= data_in[3];
                end
                $display("writing %h in block = %h new tag id = %b, curr tag id = %b",{data_in[3],data_in[2],data_in[1],data_in[0]},addr[12:2], addr[31:13],cache_tags[addr[12:2]]);
            end 
        end
    end

endmodule