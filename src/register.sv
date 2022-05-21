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
    if (reset == 0) //nedge clk!
        data = {XLEN{1'b0}};
    else
        if(we)
            data = data_in;    
end
    
endmodule

module shift_register #(
    parameter LEN = 32,
    parameter COUNT = 1
    ) (
    clk,
    reset,
    data_in,
    data,
    write,
    enable,
    shift,
    shift_in,
    right
);
    
    output reg [LEN - 1:0] data;
    
    input [LEN - 1:0] data_in;
    input shift_in;
    input shift;
    input reset;
    input clk;
    input right;
    input write;
    input enable;

    always @(posedge clk, negedge reset) begin
        if (enable) begin
            if (!reset)
                data <= 0;
            else begin
                if (write)
                    data <= data_in;
                else if (shift) begin
                    if (right) begin
                        data = data_in >> COUNT;
                        if (shift_in)
                            data[LEN - 1: LEN - COUNT] = {COUNT{1'b1}};
                        else 
                            data[LEN - 1: LEN - COUNT] = {COUNT{1'b0}};
                    end else begin
                        data = data_in << COUNT;
                        if (shift_in)
                            data[COUNT - 1:0] = {COUNT{1'b1}};
                        else 
                            data[COUNT - 1:0] = {COUNT{1'b0}};
                    end
                end
            end
        end
    end
endmodule
