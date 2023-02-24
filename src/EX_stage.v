`timescale 1ns / 1ps

module EX_stage#(
        parameter NB_ALU_OP   = 3,
        parameter NB_ALU_CTRL = 4
        parameter NB_IMM      = 32,
        parameter NB_PC       = 6,
        parameter NB_DATA     = 32,
        parameter NB_REG      = 5
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
        output [NB_REG-1:0]     o_EX_selected_reg
        
    );
    
    wire [NB_IMM-1:0]       shifted_imm;
    wire [NB_PC-1:0]        branch_address;
    wire [NB_DATA-1:0]      alu_data_b;
    wire                    zero;
    wire [NB_DATA-1:0]      alu_result;
    wire [NB_ALU_CTRL-1:0]  alu_ctrl;
    wire [NB_REG-1:0]       selected_reg;
    
    adder adder_2(.i_a(i_EX_pc),
                  .i_b(shifted_imm),
                  .o_result(branch_address));

    alu alu_1(.i_a(i_EX_data_a),
              .i_b(alu_data_b),
              .i_alu_ctrl(alu_ctrl),
              .o_zero(zero),
              .o_result(alu_result));

    alu_control alu_control_1(.i_funct_code([5:0]i_EX_immediate), //chequear esto
                              .i_alu_op(i_EX_alu_op),
                              .o_alu_ctrl(alu_ctrl));

    shifter shifter_1(.i_data(i_EX_immediate),
                      .o_result(shifted_imm));

    mux2 mux2_3(.i_select(i_EX_alu_src),
                .i_a(i_EX_data_b),
                .i_b(i_EX_immediate),
                .o_data(alu_data_b));

    mux2 mux2_4(.i_select(i_EX_reg_dst),
                .i_a(i_EX_rt),
                .i_b(i_EX_rd),
                .o_data(selected_reg));

    assign o_EX_reg_write = i_EX_reg_write;
    assign o_EX_mem_to_reg = i_EX_mem_to_reg;
    assign o_EX_mem_read = i_EX_mem_read;
    assign o_EX_mem_write = i_EX_mem_write;
    assign o_EX_branch = i_EX_branch;
    assign o_EX_branch_address = branch_address;
    assign o_EX_zero = zero;
    assign o_EX_alu_result = alu_result;
    assign o_EX_data_a = i_EX_data_a;
    assign o_EX_selected_reg = selected_reg;

endmodule
