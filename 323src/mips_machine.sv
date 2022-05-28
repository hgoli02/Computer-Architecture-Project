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
        .mem_data_out(mem_data_out_d4),
        .mem_data_in(mem_data_in),
        .mem_write_en(mem_write_en),
        .halted(halted),
        .clk(clk), 
        .rst_b(rst_b)
    );

    wire [7:0] mem_data_out_d1[0:3];
    wire [7:0] mem_data_out_d2[0:3];
    wire [7:0] mem_data_out_d3[0:3];
    wire [7:0] mem_data_out_d4[0:3];
    wire [7:0] mem_data_in_d1[0:3];
    wire [7:0] mem_data_in_d2[0:3];
    wire [7:0] mem_data_in_d3[0:3];
    wire [7:0] mem_data_in_d4[0:3];
    wire mem_we_d1;
    wire mem_we_d2;
    wire mem_we_d3;
    wire mem_we_d4;


    // Memory delays on reads
    dff #(8) delay_out1[0:3](.d(mem_data_out), .q(mem_data_out_d1), .clk(clk), .rst_b(rst_b));
    dff #(8) delay_out2[0:3](.d(mem_data_out_d1), .q(mem_data_out_d2), .clk(clk), .rst_b(rst_b));
    dff #(8) delay_out3[0:3](.d(mem_data_out_d2), .q(mem_data_out_d3), .clk(clk), .rst_b(rst_b));
    dff #(8) delay_out4[0:3](.d(mem_data_out_d3), .q(mem_data_out_d4), .clk(clk), .rst_b(rst_b));

    // Memory delays on writes
    dff #(8) delay_in1[0:3](.d(mem_data_in), .q(mem_data_in_d1), .clk(clk), .rst_b(rst_b));
    dff #(8) delay_in2[0:3](.d(mem_data_in_d1), .q(mem_data_in_d2), .clk(clk), .rst_b(rst_b));
    dff #(8) delay_in3[0:3](.d(mem_data_in_d2), .q(mem_data_in_d3), .clk(clk), .rst_b(rst_b));
    dff #(8) delay_in4[0:3](.d(mem_data_in_d3), .q(mem_data_in_d4), .clk(clk), .rst_b(rst_b));

    dff delay_we1(.d(mem_write_en), .q(mem_we_d1), .clk(clk), .rst_b(rst_b));
    dff delay_we2(.d(mem_we_d1), .q(mem_we_d2), .clk(clk), .rst_b(rst_b));
    dff delay_we3(.d(mem_we_d2), .q(mem_we_d3), .clk(clk), .rst_b(rst_b));
    dff delay_we4(.d(mem_we_d3), .q(mem_we_d4), .clk(clk), .rst_b(rst_b));

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
        .data_in(mem_data_in_d4), 
        .we(mem_we_d4), 
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
