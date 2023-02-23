`timescale 1ns / 1ps

module EX_stage#(
        parameter NB_ALU_OP = 3,
        parameter NB_IMM    = 32,
        parameter NB_PC     = 6,
        parameter NB_DATA   = 32,
        parameter NB_REG    = 5
    )
    (
        input                   i_clock,
        input                   i_EX_reg_write,
        input                   i_EX_mem_to_reg,
        input                   i_EX_mem_read,
        input                   i_EX_mem_write,
        input                   i_EX_branch,
        input                   i_EX_alu_src,
        input                   i_EX_reg_dst,
        input [NB_ALU_OP-1:0]   i_EX_alu_op,
        input [NB_PC-1:0]       i_EX_pc,
        input [NB_DATA-1:0]     i_EX_data_a,
        input [NB_DATA-1:0]     i_EX_data_b,
        input [NB_IMM-1:0]      i_EX_immediate,
        input [NB_REG-1:0]      i_EX_rt,
        input [NB_REG-1:0]      i_EX_rd,
        
        output                  o_EX_reg_write,
        output                  o_EX_mem_to_reg,
        output                  o_EX_mem_read,
        output                  o_EX_mem_write,
        output                  o_EX_branch,
        output [NB_PC-1:0]      o_EX_branch_address,
        output                  o_EX_zero,
        output                  o_EX_alu_result,
        output                  o_EX_data_a,
        output                  o_EX_destiny
        
    );
    
    wire [NB_PC-1:0] new_pc_value;
    
    adder adder_1(.i_a(new_pc_value),
                  .i_b(pc_constant),
                  .o_result(adder_result));
    
    assign o_adder_result    = adder_result;

endmodule
