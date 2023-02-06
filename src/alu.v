`timescale 1ns / 1ps

module alu#(
        parameter NB_REG    = 32,
        parameter NB_ALU_CTRLI = 4
    )    
    (
        input       [NB_REG-1 : 0]          i_a,
        input       [NB_REG-1 : 0]          i_b,
        input       [NB_ALU_CTRLI-1 : 0]    i_alu_op, // codigo de operaci�n que viene de la alu_control
        output                              o_zero,
        output reg  [NB_REG-1 : 0]          o_result 
    );
   
    always@(*) begin
        case(i_alu_op)
            4'b0000 : o_result =   i_a << i_b;      // SLL Shift left logical (r1<<r2) y SLLV
            4'b0001 : o_result =   i_a >> i_b;      // SRL Shift right logical (r1>>r2) y SRLV
            4'b0010 : o_result =   i_a >>> i_b;     // SRA  Shift right arithmetic (r1>>>r2) y SRAV
            4'b0011 : o_result =   i_a + i_b;       // ADD Sum (r1+r2)
            4'b0100 : o_result =   i_a - i_b;       // SUB Substract (r1-r2)
            4'b0101 : o_result =   i_a & i_b;       // AND Logical and (r1&r2)
            4'b0110 : o_result =   i_a | i_b;       // OR Logical or (r1|r2)
            4'b0111 : o_result =   i_a ^ i_b;       // XOR Logical xor (r1^r2)
            4'b1000 : o_result = ~(i_a | i_b);      // NOR Logical nor ~(r1|r2)
            4'b1001 : o_result =   i_a < i_b;       // SLT Compare (r1<r2)
            4'b1101 : o_result =   i_a << 16;       // SLL16
            4'b1110 : o_result =   i_a == i_b;      // EQ
            4'b1111 : o_result =   i_a != i_b;      // NEQ   
            default : o_result =  {NB_REG{1'b0}}; 
        endcase
    end
    
    assign o_zero = o_result == 0; // Si o_result es igual a 0 se asigna un uno a o_zero
       
endmodule