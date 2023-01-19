`timescale 1ns / 1ps

module mux4#(
        parameter   NB = 32,
        parameter   NB_SELECT = 2   
    )
    (
        input   wire    [NB_SELECT-1:0]     i_select,
        input   wire    [NB-1:0]            i_a,
        input   wire    [NB-1:0]            i_b,
        input   wire    [NB-1:0]            i_c,
        input   wire    [NB-1:0]            i_d,
        output  wire    [NB-1:0]            o_data
    
    );
    
    reg [NB-1:0] aux_reg;
    
    always @ (*) begin
        case (i_select)
            2'b00 : aux_reg <= i_a;
            2'b01 : aux_reg <= i_b;
            2'b10 : aux_reg <= i_c;
            2'b11 : aux_reg <= i_d;    
        endcase
    end
    
    assign o_data = aux_reg;

endmodule