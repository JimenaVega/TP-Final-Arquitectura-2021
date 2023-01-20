`timescale 1ns / 1ps

module adder#(
        parameter NB = 32
    )
    (
        input   [NB-1:0] i_a,
        input   [NB-1:0] i_b,
        
        output  [NB-1:0] o_result
    );
    
    assign o_result = i_a + i_b;
    
endmodule