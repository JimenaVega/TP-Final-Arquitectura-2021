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
        output reg signed [NB_REG-1 : 0]    o_result 
    );
   
    always@(*) begin
        case(i_alu_ctrl)
            4'h0 : begin
                o_result =   i_b << i_a;      // SLL Shift left logical (r1<<r2) y SLLV
            end
            4'h1 : begin
                o_result =   i_b >> i_a;      // SRL Shift right logical (r1>>r2) y SRLV
            end
            4'h2 : begin
                o_result =   i_b >>> i_a;     // SRA  Shift right arithmetic (r1>>>r2) y SRAV
            end
            4'h3 : begin
                o_result =   i_a + i_b;       // ADD Sum (r1+r2)
            end
            4'h4 : begin
                o_result =   i_a - i_b;       // SUB Substract (r1-r2)
            end
            4'h5 : begin
                o_result =   i_a & i_b;       // AND Logical and (r1&r2)
            end
            4'h6 : begin
                o_result =   i_a | i_b;       // OR Logical or (r1|r2)
            end
            4'h7 : begin
                o_result =   i_a ^ i_b;       // XOR Logical xor (r1^r2)
            end
            4'h8 : begin
                o_result = ~(i_a | i_b);      // NOR Logical nor ~(r1|r2)
            end
            4'h9 : begin 
                o_result =   i_a < i_b;       // SLT Compare (r1<r2)
            end
            4'ha : begin
                o_result =   i_b << 16;       // SLL16
            end
            4'hb : begin
                o_result =   i_a != i_b;      // BEQ: Invertida porque AND a la entrada espera un 1 para saltar
            end
            4'hc : begin
                o_result =   i_a == i_b;      // BNEQ: Invertida 
            end
            default : begin 
                o_result =  {NB_REG{1'b0}};
            end
        endcase
    end
    
    assign o_zero = o_result == 0;
       
endmodule