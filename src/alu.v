`timescale 1ns / 1ps

module alu#(
        parameter NB_REG    = 32,
        parameter NB_ALU_CTRLI = 4
    )    
    (
        input       [NB_REG-1 : 0]          i_a,
        input       [NB_REG-1 : 0]          i_b,
        input       [NB_ALU_CTRLI-1 : 0]    i_alu_ctrl, // codigo de operacion que viene de la alu_control
        output                              o_zero,
        output reg  [NB_REG-1 : 0]          o_result 
    );

    reg zero = 0;
   
    always@(*) begin
        if(o_result == 0)
            zero = 1;
        else
            zero = 0;

        case(i_alu_ctrl)
            4'h0 : o_result =   i_b << i_a;      // SLL Shift left logical (r1<<r2) y SLLV
            4'h1 : o_result =   i_b >> i_a;      // SRL Shift right logical (r1>>r2) y SRLV
            4'h2 : o_result =   i_b >>> i_a;     // SRA  Shift right arithmetic (r1>>>r2) y SRAV
            4'h3 : o_result =   i_a + i_b;       // ADD Sum (r1+r2)
            4'h4 : o_result =   i_a - i_b;       // SUB Substract (r1-r2)
            4'h5 : o_result =   i_a & i_b;       // AND Logical and (r1&r2)
            4'h6 : o_result =   i_a | i_b;       // OR Logical or (r1|r2)
            4'h7 : o_result =   i_a ^ i_b;       // XOR Logical xor (r1^r2)
            4'h8 : o_result = ~(i_a | i_b);      // NOR Logical nor ~(r1|r2)
            4'h9 : o_result =   i_a < i_b;       // SLT Compare (r1<r2)
            4'ha : o_result =   i_a << 16;       // SLL16
            4'hb : o_result =   i_a == i_b;      // BEQ
            4'hc : o_result =   i_a != i_b;      // BNEQ   
            default : o_result =  {NB_REG{1'b0}}; 
        endcase
    end
    
    assign o_zero = zero;
       
endmodule