module cache_cu (
    dirty,
    cache_we,
    mem_we,
    mem_in_select,
    clk,
    rst_b,
    hit,
    opcode,
    reg_write_enable,
    cache_in_select,
    is_byte
);
    integer counter;
    output reg cache_we;
    output reg mem_we;
    output reg mem_in_select;
    output reg reg_write_enable;
    output reg cache_in_select;
    output reg is_byte;
    
    input clk;
    input dirty;
    input rst_b;
    input hit;
    input[5:0] opcode;

    localparam [5:0] 
        SW = 6'b101011, 
        LW = 6'b100011, 
        LB = 6'b100000, 
        SB = 6'b101000;

    localparam[1:0] init = 2'b00, write = 2'b01,
                    read = 2'b10;
    reg[1:0] pstate;
    reg[1:0] nstate;

    //Handle FSM states
    always @(*) begin
        if(opcode == LW || opcode == SW || opcode == SB || opcode == LB)begin
            // nstate = init;
            cache_in_select = 0;
            cache_we = 0;
            mem_in_select = 0;
            mem_we = 0;
            is_byte = 0;
            case (pstate)
                init: begin  
                    counter = 0;
                    if(hit == 1) begin
                        case (opcode)
                            LW: begin
                                reg_write_enable = 1;
                            end
                            LB: begin
                                reg_write_enable = 1;
                                is_byte = 1;
                            end
                            SB: begin
                                cache_we = 1;
                                cache_in_select = 1;
                                is_byte = 1;
                            end 
                            SW: begin 
                                cache_we = 1;
                                cache_in_select = 1;
                            end
                            default: begin end
                        endcase
                    end else begin
                        if(dirty == 1) begin
                            mem_in_select = 1;
                            mem_we = 1;
                            nstate = write;
                        end else
                            nstate = read;
                    end
                end 
                write: begin
                    if (counter <= 4)
                        mem_in_select = 1;
                    if (counter == 5) begin
                        mem_in_select = 0;  
                        nstate = read;
                        counter = 0; 
                    end
                end
                read: begin
                    if (counter == 4) begin
                        //now mem_data_out is ready enable cache we
                        cache_we = 1;
                        nstate = init; //it works beatifully it will set reg_write_enable to 1 in the next cycle if needed
                    end
                end
                default: begin end
            endcase
        end
    end

    always @(posedge clk, negedge rst_b) begin
        if(rst_b == 0) begin
            cache_we = 0;
            mem_we = 0;
            mem_in_select = 0; 
            counter = 0;
        end else begin
            pstate = nstate;
            if(pstate != nstate) counter = 0;
            else counter    = counter + 1;
        end
    end

    always @(negedge clk) begin
        if (opcode == LW) begin
            $display("LW instruction");
            $display("Current state = %d next state = %d",pstate,nstate);
        end else if (opcode == SW)begin
            $display("SW instruction");
            $display("Current state = %d next state = %d",pstate,nstate);
        end else if (opcode == LB)begin
            $display("LB instruction");
            $display("Current state = %d next state = %d",pstate,nstate);
        end else if (opcode == SB)begin
            $display("SB instruction");
            $display("Current state = %d next state = %d",pstate,nstate);
        end
        $display("counter = %d",counter);
      
    end
endmodule