module buff_IF_ID(pc_in,pc_out, inst_in,inst_out, clk, rst_b, flush, stall);
    parameter XLEN = 32; 
    output [31:0] pc_out;
    output [31:0] inst_out;
    input [31:0] pc_in;
    input [31:0] inst_in;
    input flush, stall, clk, rst_b;
    
    Register pc_inc_reg (.clk(clk), .rst_b(rst_b),.data_in(pc_in), .data_out(pc_out), .we(stall));
    Register instruction_reg (.clk(clk), .rst_b(rst_b), .data_in(inst_in), .data_out(inst_out), .we(stall));
endmodule