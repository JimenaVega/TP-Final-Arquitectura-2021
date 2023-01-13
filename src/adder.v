`timescale 1ns / 1ps

module adder#(
        parameter    N_BITS = 32
    )
    (
        input   [N_BITS - 1 : 0]    i_a,
        input   [N_BITS - 1 : 0]    i_b,
        
        output  [N_BITS - 1 : 0]    o_result
    );
    
    assign o_result = i_a + i_b;
    
endmodule