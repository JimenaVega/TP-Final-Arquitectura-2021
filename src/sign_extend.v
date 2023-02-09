`timescale 1ns / 1ps

module sign_extend#(
        parameter NB_IN = 16,
        parameter NB_OUT = 32
    )
    (
        input  [NB_IN-1:0]  i_data,
        output [NB_OUT-1:0] o_data
    );

    assign o_data = i_data;
    
endmodule
