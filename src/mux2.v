`timescale 1ns / 1ps

module mux2#(
        parameter   NB = 32
    )
    (
        input           i_select,
        input  [NB-1:0] i_a,
        input  [NB-1:0] i_b,
        output [NB-1:0] o_data
    
    );
    
    reg [NB-1:0] aux_reg;
    
    always @ (*) begin
        case (i_select)
            1'b0 : aux_reg <= i_a;
            1'b1 : aux_reg <= i_b;
        endcase
    end
    
    assign o_data = aux_reg;

endmodule