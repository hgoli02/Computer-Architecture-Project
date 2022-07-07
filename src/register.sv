module Register #(
    parameter XLEN = 32
) (
    clk,
    rst_b,
    data_in,
    data_out,
    we
);
input[XLEN - 1 : 0] data_in;
input clk;
input rst_b;
input we;
output reg [XLEN -1 : 0] data_out;

always @(posedge clk) begin
    if (rst_b == 0)
        data_out <= {XLEN{1'b0}};
    else
        if(we)
            data_out <= data_in;    
end
    
endmodule