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
    cache_in_select
);
    integer counter;
    output reg cache_we;
    output reg mem_we;
    output reg mem_in_select;
    output reg reg_write_enable;
    output reg cache_in_select;
    
    input clk;
    input dirty;
    input rst_b;
    input hit;
    input[5:0] opcode;

    localparam [5:0] RTYPE = 6'b000000, ADDIU = 6'b001001, ADDi = 6'b001000,
        SYSCALL = 6'b001100, ADD = 6'b100000 , BEQ = 6'b000100,BGTZ = 6'b000111,
        BNE = 6'b000101 , JUMP = 6'b000010,BLEZ = 6'b000110,BGEZ = 6'b000001,
        AND = 6'b100100 , OR = 6'b100101, DIV = 6'b011010, MULT = 6'b011000, NOR = 6'b100111,
        XOR = 6'b100110 , SUB = 6'b100010, ANDi = 6'b001100 ,XORi = 6'b001110,ORi = 6'b001101,
        SLLV = 6'b000100 , SLL = 6'b000000 , SRL = 6'b000010 , SRLV = 6'b000110, SRA = 6'b000011,
        SLT = 6'b101010 , SLTi = 6'b001010 , ADDU = 6'b100001, SUBU = 6'b100011 , JR = 6'b001000,
        JAL = 6'b000011, SW = 6'b101011, LW = 6'b100011, LUi = 6'b001111;

    localparam[1:0] init = 2'b00, write = 2'b01,
                    read = 2'b10;
    reg[1:0] pstate;
    reg[1:0] nstate;

    //Handle FSM states
    always @(*) begin
        if(opcode == LW || opcode == SW)begin
            // nstate = init;
            cache_in_select = 0;
            cache_we = 0;
            mem_in_select = 0;
            mem_we = 0;
            case (pstate)
                init: begin  
                    counter = 0;
                    if(hit == 1) begin
                        case (opcode)
                            LW: reg_write_enable = 1;
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
                    mem_in_select = 1;
                    if (counter == 4) begin
                        nstate = read;
                        counter = 0; 
                    end
                end
                read: begin
                    if (counter == 0) begin
                        mem_in_select = 0;
                    end
                    mem_we = 0;//not needed
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
        end
        else if (opcode == SW)begin
            $display("SW instruction");
            $display("Current state = %d next state = %d",pstate,nstate);
        end
        $display("counter = %d",counter);
        $display("mem_we in cu = %h",mem_we);
    end
endmodule