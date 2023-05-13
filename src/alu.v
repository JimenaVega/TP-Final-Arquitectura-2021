`timescale 1ns / 1ps

module alu#(
        parameter NB_REG    = 32,
        parameter NB_ALU_CTRLI = 4
    )    
    (
        input signed [NB_REG-1 : 0]         i_a,
        input signed [NB_REG-1 : 0]         i_b,
        input       [NB_ALU_CTRLI-1 : 0]    i_alu_ctrl, // codigo de operacion que viene de la alu_control
        output                              o_zero,
        output                              o_oe,       // overflow exception
        output reg signed [NB_REG-1 : 0]    o_result 
    );

    reg zero = 0;
    reg oe;
   
    always@(*) begin
        if(o_result == 0)
            zero = 1;
        else
            zero = 0;
        
        case(i_alu_ctrl)
            4'h0 : begin
                o_result =   i_b << i_a;      // SLL Shift left logical (r1<<r2) y SLLV
                oe = 0;
            end
            4'h1 : begin
                o_result =   i_b >> i_a;      // SRL Shift right logical (r1>>r2) y SRLV
                oe = 0;
            end
            4'h2 : begin
                o_result =   i_b >>> i_a;     // SRA  Shift right arithmetic (r1>>>r2) y SRAV
                oe = 0;
            end
            4'h3 : begin
                o_result =   i_a + i_b;       // ADD Sum (r1+r2)
                oe =(((i_a[NB_REG-1] && i_b[NB_REG-1]) && (!o_result[NB_REG-1])) || (((!i_a[NB_REG-1] && !i_b[NB_REG-1]) && o_result[NB_REG-1])));
            end
            4'h4 : begin
                o_result =   i_a - i_b;       // SUB Substract (r1-r2)
                oe = (((i_a[NB_REG-1] && !i_b[NB_REG-1]) && (!o_result[NB_REG-1])) || (((!i_a[NB_REG-1] && i_b[NB_REG-1]) && o_result[NB_REG-1])));
            end
            4'h5 : begin
                o_result =   i_a & i_b;       // AND Logical and (r1&r2)
                oe = 0;
            end
            4'h6 : begin
                o_result =   i_a | i_b;       // OR Logical or (r1|r2)
                oe = 0;
            end
            4'h7 : begin
                o_result =   i_a ^ i_b;       // XOR Logical xor (r1^r2)
                oe = 0;
            end
            4'h8 : begin
                o_result = ~(i_a | i_b);      // NOR Logical nor ~(r1|r2)
                oe = 0;
            end
            4'h9 : begin 
                o_result =   i_a < i_b;       // SLT Compare (r1<r2)
                oe = 0;
            end
            4'ha : begin
                o_result =   i_b << 16;       // SLL16
                oe = 0;
            end
            4'hb : begin
                o_result =   i_a == i_b;      // BEQ
                oe = 0;
            end
            4'hc : begin
                o_result =   i_a != i_b;      // BNEQ
                oe = 0;
            end
            default : begin 
                o_result =  {NB_REG{1'b0}}; 
                oe = 0;
            end
        endcase
    end
    
    assign o_zero = zero;
    assign o_oe = oe;
       
endmodule