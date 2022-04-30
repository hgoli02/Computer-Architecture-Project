module regfile(
    rs_data,
    rt_data,
    rs_num,
    rt_num,
    rd_num,
    rd_data,
    rd_we,
    clk,
    rst_b,
    halted
);
    parameter XLEN=32, size=32;

    output [XLEN-1:0] rs_data;
    output [XLEN-1:0] rt_data;
    input       [4:0] rs_num;
    input       [4:0] rt_num;
    input       [4:0] rd_num;
    input  [XLEN-1:0] rd_data;
    input             rd_we;
    input             clk;
    input             rst_b;
    input             halted;

    reg [XLEN-1:0] data[0:size-1];

    assign rs_data = data[rs_num];
    assign rt_data = data[rt_num];

    always_ff @(posedge clk, negedge rst_b) begin
        if (rst_b == 0) begin
            int i;
            for (i = 0; i < size; i++)
                data[i] <= 0;
        end else begin
            if (rd_we && (rd_num != 0))
                data[rd_num] <= rd_data;
        end
    end

	always @(halted) begin
        integer fd = 0;
        integer i = 0;
		if (rst_b && (halted)) begin
			fd = $fopen("output/regdump.reg");

			$display("=== Simulation Cycle %0d ===", $time/2);
			$display("*** RegisterFile dump ***");
			$fdisplay(fd, "*** RegisterFile dump ***");
			
			for(i = 0; i < size; i = i+1) begin
				$display("r%2d = 0x%8x", i, data[i]);
				$fdisplay(fd, "r%2d = 0x%8h", i, data[i]); 
			end
			
			$fclose(fd);
		end
	end
    
endmodule
