module cache_cu (
    proc,
    dirty,
    cache_we,
    mem_we,
    mem_in_select,
    clk,
    rst_b,
    hit,
    opcode,
    reg_write_enable,
    mem_write_en
);
    integer counter;
    output reg cache_we;
    output reg mem_we;
    output reg mem_in_select;
    output reg reg_write_enable;
    
    input clk;
    input dirty;
    input rst_b;
    input proc;
    input hit;

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
            case (pstate)
                init: begin  
                    if(hit == 1) begin
                        case (opcode)
                            LW: reg_write_enable = 1;
                            SW: cache_we = 1;
                            default: begin end
                        endcase
                    end else begin
                        
                    end
                end 
                write: begin
                    
                end
                read: begin
                    
                end
                default: begin end
            endcase
        end
    end

    always @(posedge clk, negedge rst_b) begin
        if(rst_b == 0) begin
            cache_we <= 0;
            mem_we <= 0;
            mem_in_select <= 0; 
            counter <= 0;
        end else begin
            pstate = nstate;
        end
    end
    
endmodule