module cache (
    addr, data_in, data_out, we, clk, rst_b   
);
    parameter XLEN = 32;
    parameter C_WIDTH = 10;//random 10 neveshatm dorost she

    output [XLEN - 1 : 0] data_out;

    input [XLEN - 1 : 0] data_in;
    input [C_WIDTH - 1: 0] addr;
    input we;
    input clk;
    input rst_b;

endmodule