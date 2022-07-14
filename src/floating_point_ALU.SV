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
    reg [24 : 0] mantissa1, mantissa2, mantissa_res;

    always @(input1, input2, operation) begin
        sign1 = input1[31];
        sign2 = input2[31];
        
        exp1 = input1[30 : 23];
        exp2 = input2[30 : 23];

        mantissa1 = input1[22 : 0];
        mantissa2 = input2[22 : 0];
        mantissa1[23] = 1;
        mantissa2[23] = 1;

        case(operation)
            NOP : 
                 begin
                        result = input1;
                 end

            ADD : 
                 begin
                    if(input2 == 0) begin
                        result = input1;
                    end
                    
                    else begin
                        if(input1 == 0) begin
                        result = input2;    
                        end

                        else begin
                            if(exp1 > exp2) begin
                            while (exp1 != exp2) begin
                            exp2 = exp2 + 1;
                            mantissa2 = mantissa2 >> 1;
                                end
                            end

                            if(exp2 > exp1) begin
                                while (exp1 != exp2) begin
                            exp1 = exp1 + 1;
                            mantissa1 = mantissa1 >> 1;
                                end
                            end

                            exp_res = exp1;

                            if(sign1 ^ sign2) begin
                                    if(sign1) begin
                                        mantissa_res = mantissa2 - mantissa1;
                                        if(mantissa_res[24]) begin
                                            if(mantissa_res [23 : 0] == 0) begin
                                                sign_res = 0;
                                                exp_res = 0;
                                                mantissa_res = 0;
                                            end
                                            else begin
                                                while(mantissa_res[23] != 1) begin
                                                    mantissa_res = mantissa_res << 1;
                                                    exp_res = exp_res + 1;
                                                end
                                                sign_res = 0;
                                            end
                                        end
                                        else begin
                                            mantissa_res = -mantissa_res; //whole or just first 24 bits ?
                                            sign_res = 1;
                                            while(mantissa_res[23] != 1) begin
                                                    mantissa_res = mantissa_res << 1;
                                                    exp_res = exp_res + 1;
                                                end 
                                        end
                                    end
                                    else begin
                                         mantissa_res = mantissa2 - mantissa1;
                                        if(mantissa_res[24]) begin
                                            if(mantissa_res [23 : 0] == 0) begin
                                                sign_res = 0;
                                                exp_res = 0;
                                                mantissa_res = 0;
                                            end
                                            else begin
                                                while(mantissa_res[23] != 1) begin
                                                    mantissa_res = mantissa_res << 1;
                                                    exp_res = exp_res + 1;
                                                end
                                            end
                                        end
                                        else begin
                                            mantissa_res = -mantissa_res;
                                            sign_res = -sign1;
                                            while(mantissa_res[23] != 1) begin
                                                    mantissa_res = mantissa_res << 1;
                                                    exp_res = exp_res + 1;
                                                end 
                                        end
                                    end
                            end

                            else begin
                                 mantissa_res = mantissa1 + mantissa2;
                                 if(mantissa_res[24]) begin
                                    mantissa_res = mantissa_res >> 1;
                                    exp_res = exp_res + 1;
                                 end
                                 else begin
                                    if(mantissa_res[23] == 0) begin
                                        if(mantissa_res[22:0] != 0) begin
                                            while (mantissa_res[23] != 1) begin
                                                mantissa_res = mantissa_res << 1;
                                                exp_res = exp_res - 1;
                                            end
                                        end
                                    end
                                 end

                            end

                            result = {sign_res,exp_res,mantissa_res[22:0]}

                    end
                    
                 end
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