`timescale 1ns / 1ps

module MEM_WB_reg#(
        parameter NB_DATA = 32,
        parameter NB_REG  = 5,
        parameter NB_PC   = 32
    )
    (   
        input                   i_clock,
        input                   i_MEM_reg_write,
        input                   i_MEM_mem_to_reg,                 // MUX selector
        input [NB_DATA-1:0]     i_MEM_mem_data,     // i_WB_mem_to_reg = 1
        input [NB_DATA-1:0]     i_MEM_alu_result,   // i_WB_mem_to_reg = 0
        input [NB_REG-1:0]      i_MEM_selected_reg,
        input                   i_MEM_r31_ctrl,
        input [NB_PC-1:0]       i_MEM_pc,

        output                  o_WB_reg_write,
        output                  o_WB_mem_to_reg,                 // MUX selector
        output [NB_DATA-1:0]    o_WB_mem_data,     // i_WB_mem_to_reg = 1
        output [NB_DATA-1:0]    o_WB_alu_result,   // i_WB_mem_to_reg = 0
        output [NB_REG-1:0]     o_WB_selected_reg,
        output                  o_WB_r31_ctrl,
        output [NB_PC-1:0]      o_WB_pc
    );

    reg                 reg_write;
    reg                 mem_to_reg; // MUX selector
    reg                 mem_data;   // i_WB_mem_to_reg = 1
    reg [NB_DATA-1:0]   alu_result; // i_WB_mem_to_reg = 0
    reg [NB_REG-1:0]    selected_reg;
    reg                 r31_ctrl;
    reg [NB_PC-1:0]     pc;

    always@(negedge i_clock) begin
        reg_write       <= i_MEM_reg_write;
        mem_to_reg      <= i_MEM_mem_to_reg;
        mem_data        <= i_MEM_mem_data;
        alu_result      <= i_MEM_alu_result;
        selected_reg    <= i_MEM_selected_reg;
        r31_ctrl        <= i_MEM_r31_ctrl;
        pc              <= i_MEM_pc;
    end

    assign o_WB_reg_write       = reg_write;
    assign o_WB_mem_to_reg      = mem_to_reg;
    assign o_WB_mem_data        = mem_data;
    assign o_WB_alu_result      = alu_result;
    assign o_WB_selected_reg    = selected_reg;
    assign o_WB_r31_ctrl        = r31_ctrl;
    assign o_WB_pc              = pc;

endmodule