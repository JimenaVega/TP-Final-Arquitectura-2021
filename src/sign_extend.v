`timescale 1ns / 1ps

module sign_extend#(
        parameter NB_IN = 16,
        parameter NB_OUT = 32
    )
    (
        input [NB_IN-1:0]  i_data,
        output reg [NB_OUT-1:0] o_data
    );

    // assign o_data = i_data;
    always@(i_data) begin
        o_data[NB_IN-1:0] = i_data[NB_IN-1:0];
        o_data[NB_OUT-1:0] = {NB_IN-1{i_data[NB_IN-1]}}; // se extiende el signo de i_data[15]
    end
    
endmodule
