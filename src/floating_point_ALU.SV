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



    input [31:0] input1 ;
    input [31:0] input2;
    input  [2:0] operation;
    output reg [31:0] result;
    output reg division_by_zero,QNaN,SNaN,inexact,underflow,overflow;


    reg sign1, sign2, sign_res;
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
                                        mantissa_res = mantissa2[24:0] +{1'b0, -(mantissa1[23:0])};
                                        
                                    end
                                    else begin
                                        
                                         mantissa_res = mantissa1[24:0] + {1'b0,-(mantissa2[23:0])};
                                   
                                    end
                                    
                                      if(mantissa_res[24]) begin
                                            if(mantissa_res [23 : 0] == 24'b0) begin
                                                sign_res = 0;
                                                exp_res = 0;
                                                mantissa_res = 0;
                                                
                                            end
                                            else begin
                                                while(mantissa_res[23] != 1) begin
                                                    mantissa_res = mantissa_res << 1;
                                                    exp_res = exp_res - 1;
                                                end
                                                sign_res = 0;
                                            end
                                        end
                                        else begin
                                            
                                            mantissa_res = -mantissa_res; //whole or just first 24 bits ?
                                            sign_res = 1;
                                            while(mantissa_res[23] != 1) begin
                                                    mantissa_res = mantissa_res << 1;
                                                    exp_res = exp_res - 1;
                                                    
                                                end 
                                        end
                            end

                            else begin
                                 mantissa_res = mantissa1 + mantissa2;
                                 sign_res = sign1;
                                 if(mantissa_res[24]) begin
                                    mantissa_res = mantissa_res >> 1;
                                    exp_res = exp_res + 1;
                                 end
                                 else begin
                                    if(mantissa_res[23] == 0) begin
                                        if(mantissa_res[22:0] != 23'b0) begin
                                            while (mantissa_res[23] != 1) begin
                                                mantissa_res = mantissa_res << 1;
                                                exp_res = exp_res - 1;
                                            end
                                        end
                                    end
                                 end

                            end

                            result = {sign_res,exp_res,mantissa_res[22:0]};

                    end
                    
                 end
                 end

            SUB : 
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

                            if(!(sign1 ^ sign2)) begin
                                    if(sign1) begin
                                        mantissa_res = mantissa2[24:0] + {1'b0, -(mantissa1[23:0])};
                                        
                                    end
                                    else begin
                                        
                                         mantissa_res = mantissa1[24:0] + {1'b0,-(mantissa2[23:0])};
                                   
                                    end
                                    
                                      if(mantissa_res[24]) begin
                                            if(mantissa_res [23 : 0] == 24'b0) begin
                                                sign_res = 0;
                                                exp_res = 0;
                                                mantissa_res = 0;
                                                
                                            end
                                            else begin
                                                while(mantissa_res[23] != 1) begin
                                                    mantissa_res = mantissa_res << 1;
                                                    exp_res = exp_res - 1;
                                                end
                                                sign_res = 0;
                                            end
                                        end
                                        else begin
                                            
                                            mantissa_res = -mantissa_res; //whole or just first 24 bits ?
                                            sign_res = 1;
                                            while(mantissa_res[23] != 1) begin
                                                    mantissa_res = mantissa_res << 1;
                                                    exp_res = exp_res - 1;
                                                    
                                                end 
                                        end
                            end

                            else begin
                                 mantissa_res = mantissa1 + mantissa2;
                                 sign_res = sign1;
                                 if(mantissa_res[24]) begin
                                    mantissa_res = mantissa_res >> 1;
                                    exp_res = exp_res + 1;
                                 end
                                 else begin
                                    if(mantissa_res[23] == 0) begin
                                        if(mantissa_res[22:0] != 23'b0) begin
                                            while (mantissa_res[23] != 1) begin
                                                mantissa_res = mantissa_res << 1;
                                                exp_res = exp_res - 1;
                                            end
                                        end
                                    end
                                 end

                            end

                            result = {sign_res,exp_res,mantissa_res[22:0]};

                    end
                    
                 end
                 end

            MUL : 
                 begin
                
                 end

            DIV : 
                 begin
                    if(input2 == 0) begin
                       division_by_zero = 1;
                    end
                    else begin
                        if(input1 == 0) begin
                            result = 0;
                        end
                        else begin
                            sign_res = sign1 ^ sign2;
                            mantissa_res = 25'b0;

                            if(mantissa1 > mantissa2) begin
                                
                                mantissa_res[23] = mantissa1[0];
                                mantissa1 = mantissa1 >> 1; // ¯\_(ツ)_/¯
                                exp1 = exp1 + 1;
                            end

                            exp_res = exp1 - exp2 + 126;
                           

                            mantissa_res = {mantissa1[23 : 0],mantissa_res[23 : 0]} / mantissa2[23 : 0];
                        
                            while(mantissa_res[23] != 1) begin
                                
                                mantissa_res = mantissa_res << 1;
                                exp_res = exp_res - 1;
                                                    
                                end 

                            result = {sign_res,exp_res,mantissa_res[22:0]};
                            
                        end
                    end
                 end

            RND : 
                 begin
                    exp2 = exp1 - 127;
                    if(exp1 < 126) begin
                        result = 0;
                    end
                    else begin
                        if(exp1 > 149) begin
                            result = input1;
                        end
                        else begin
                            if(exp1 == 126) begin
                                if(mantissa1[23]) begin
                                    result = {sign1, 8'b01111111, 23'b0};
                                end
                                else begin
                                    result = 0; 
                                end
                                   
                            end
                            else begin
                                
                                if(mantissa1[22 - exp2]) begin
                                    mantissa2 = 0;
                                    mantissa2[22 - exp2] = 1;
                                    mantissa_res = mantissa1 + mantissa2;
                                    mantissa_res = mantissa_res >> 22 - exp2;
                                    mantissa_res = mantissa_res << 22 - exp2;
                                    sign_res = sign1;
                                    exp_res = exp1;
                                    if(mantissa_res[24]) begin
                                        mantissa_res = mantissa_res >> 1;
                                        exp_res = exp_res + 1;
                                    end
                                end
                                else begin
                                    mantissa_res = mantissa1;
                                    mantissa_res = mantissa_res >> 22 - exp2;
                                    mantissa_res = mantissa_res << 22 - exp2;
                                    sign_res = sign1;
                                    exp_res = exp1;
                                end
                                result = {sign_res,exp_res,mantissa_res[22:0]};
                            end
                        end
                    end
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

                    sign1 = 0;
                    sign2 = input1[31];
        
                    exp1 = 8'b01111111;
                    exp2 = input1[30 : 23];

                    mantissa1 = 23'b0;
                    mantissa2 = input1[22 : 0];
                    mantissa1[23] = 1;
                    mantissa2[23] = 1;
                    
                    if(input2 == 0) begin
                        division_by_zero = 1;
                    end
                    else begin
                        if(input1 == 0) begin
                            result = 0;
                        end
                        else begin
                            sign_res = sign1 ^ sign2;
                            mantissa_res = 25'b0;

                            if(mantissa1 > mantissa2) begin
                                
                                mantissa_res[23] = mantissa1[0];
                                mantissa1 = mantissa1 >> 1; // ¯\_(ツ)_/¯
                                exp1 = exp1 + 1;
                            end

                            exp_res = exp1 - exp2 + 126;
                           

                            mantissa_res = {mantissa1[23 : 0],mantissa_res[23 : 0]} / mantissa2[23 : 0];
                        
                            while(mantissa_res[23] != 1) begin
                                
                                mantissa_res = mantissa_res << 1;
                                exp_res = exp_res - 1;
                                                    
                                end 

                            result = {sign_res,exp_res,mantissa_res[22:0]};
                            
                        end
                    end
                 end     
                 
        endcase
    end

endmodule

