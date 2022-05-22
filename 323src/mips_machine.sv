module mips_machine(
    clk,
    rst_b
);
    input clk;
    input rst_b;

    wire halted;

    wire [31:0] inst_addr;
    wire [31:0] mem_addr;
    wire [31:0] inst;
    wire [7:0]  instruction_parts[0:3];
    wire [7:0]  mem_data_in [0:3];
    wire [7:0]  mem_data_out [0:3];
    wire mem_write_en;

    assign inst = {instruction_parts[0], instruction_parts[1], instruction_parts[2],instruction_parts[3]};

    mips_core core(
        .inst(inst), 
        .inst_addr(inst_addr), 
        .mem_addr(mem_addr), 
        .mem_data_out(mem_data_out),
        .mem_data_in(mem_data_in),
        .mem_write_en(mem_write_en),
        .halted(halted),
        .clk(clk), 
        .rst_b(rst_b)
    );
        

    memory instruction_memory(
        .data_out(instruction_parts[0:3]),
        .addr(inst_addr), 
        .data_in(),                 
        .we(1'b0), 
        .clk(clk), 
        .rst_b(rst_b)
    );
    
    memory data_memory(
        .data_out(mem_data_out), 
        .addr(mem_addr), 
        .data_in(mem_data_in),        
        .we(mem_write_en), 
        .clk(clk), 
        .rst_b(rst_b)
    );

    defparam instruction_memory.top=4096;
    defparam instruction_memory.has_default=1;
    defparam instruction_memory.default_file="output/instructions.mem";

    always @(halted)
        if (halted == 1)
            $finish();
endmodule
