`timescale 1ns / 1ps

module WB_stage#(
        parameter NB_DATA = 32,
        parameter NB_REG  = 5,
        parameter NB_PC   = 32
    )
    (   input                   i_WB_reg_write,
        input                   i_WB_mem_to_reg,   // MUX selector
        input [NB_DATA-1:0]     i_WB_mem_data,     // i_WB_mem_to_reg = 1
        input [NB_DATA-1:0]     i_WB_alu_result,   // i_WB_mem_to_reg = 0
        input [NB_REG-1:0]      i_WB_selected_reg,
        input                   i_WB_r31_ctrl,
        input [NB_PC-1:0]       i_WB_pc,

        output                  o_WB_reg_write,
        output [NB_DATA-1:0]    o_WB_selected_data,
        output [NB_REG-1:0]     o_WB_selected_reg
    );

    wire [NB_DATA-1:0] mux2_5_data;

    mux2 mux2_5(.i_select(i_WB_mem_to_reg),
                .i_a(i_WB_alu_result),
                .i_b(i_WB_mem_data),
                .o_data(mux2_5_data));

    mux2 mux2_6(.i_select(i_WB_r31_ctrl),
                .i_a(mux2_5_data),
                .i_b(i_WB_pc),
                .o_data(o_WB_selected_data));
    
    assign o_WB_reg_write       = i_WB_reg_write;
    assign i_WB_selected_reg    = o_WB_selected_reg;

endmodule