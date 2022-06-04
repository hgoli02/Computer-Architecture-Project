module cache_cu (
    proc,
    dirty,
    cache_we,
    mem_we,
    mem_in_select,
    clk,
    rst_b
);
    integer counter;
    output reg cache_we;
    output reg mem_we;
    output reg mem_in_select;
    
    input clk;
    input dirty;
    input rst_b;
    input proc;

    //Handle FSM states

    always @(posedge clk, negedge rst_b) begin
        if(rst_b == 0) begin
            cache_we <= 0;
            mem_we <= 0;
            mem_in_select <= 0; 
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
    
endmodule