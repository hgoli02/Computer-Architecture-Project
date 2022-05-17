module register #(
    parameter XLEN = 32
) (
    clk,
    reset,
    data_in,
    data,
    we
);
input[XLEN -1 : 0] data_in;
input clk;
input reset;
input we;
output reg [XLEN -1 : 0] data;

always @(posedge clk , negedge reset) begin
    if (reset)
        data = {XLEN{1'b0}};
    else
        if(we)
            data = data_in;    
end
    
endmodule