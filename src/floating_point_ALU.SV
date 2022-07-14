module floating_point_ALU(
    input1,
    input2,
    operation,
    result,
    division_by_zero,
    QNaN,
    SNaN,
    inexact,
    underflow,
    overflow

);

    localparam [3:0] NOP = 4'd0, ADD = 4'd1, SUB = 4'd2, MUL = 4'd3,
                     DIV = 4'd4 ,RND = 4'd5, SLT = 4'd6, INV = 4'd7;



    input input1 [31:0];
    input input2 [31:0];
    input operation [2:0];
    output reg result[31:0];
    output reg division_by_zero,QNaN,SNaN,inexact,underflow,overflow;


    reg sign1, sing2, sign_res;
    reg [7 : 0] exp1, exp2, exp_res;
    reg [22 : 0] mantissa1, mantissa2, mantissa_res;

    always @(input1, input2, operation) begin
        sign1 = input1[31];
        sign2 = input2[31];
        
        exp1 = input1[30 : 23];
        exp2 = input2[30 : 23];

        mantissa1 = input1[22 : 0];
        mantissa2 = input2[22 : 0];

        case(operation)
            NOP : 
                 begin
                        result = input1;
                 end

            ADD : 
                 begin
                
                 end

            SUB : 
                 begin
                
                 end

            MUL : 
                 begin
                
                 end

            DIV : 
                 begin
                
                 end

            RND : 
                 begin
                
                 end

            SLT : 
                 begin
                    if (sign1 > sign2)
                         result = 1;
                    else if (sign1 < sign2)
                         result = 0;
                    else if (sign1 == 0) begin
                         if (exp1 < exp2)
                              result = 1;
                         else if (exp1 > exp2)
                              result = 0;
                         else begin
                              if (mantissa1 < mantissa2)
                                   result = 1;
                              else 
                                   result = 0;
                         end
                    end else begin
                         if (exp1 > exp2) 
                              result = 1;
                         else if (exp1 < exp2)
                              result = 0;
                         else begin
                              if (mantissa1 > mantissa2)
                                   result = 1;
                              else 
                                   result = 0;
                         end
                    end
                 end

            INV : 
                 begin
                
                 end     
                 
        endcase
    end

endmodule