module test;
    initial begin
        if (2'bx1 == 2'b11) begin
            $$display("hello");
        end
        $display("hi");
    end

endmodule