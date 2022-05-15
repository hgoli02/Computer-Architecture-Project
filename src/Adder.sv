module Adder #(parameter len = 32) (a, b, s);

input[len - 1:0] a;
input[len - 1:0] b;
output[len - 1:0] s;

assign s = a + b;
    
endmodule