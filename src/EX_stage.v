`timescale 1ns / 1ps

module EX_stage#(
        parameter NB_ALU_OP   = 6,
        parameter NB_ALU_CTRL = 4,
        parameter NB_IMM      = 32,
        parameter NB_PC       = 32, // TODO: estaba en 6
        parameter NB_DATA     = 32,
        parameter NB_REG      = 5,
        parameter NB_FCODE    = 6,
        parameter NB_SEL      = 2
    )
    (
        input                   i_EX_signed,
        input                   i_EX_reg_write,  // WB stage flag
        input                   i_EX_mem_to_reg, // WB stage flag
        input                   i_EX_mem_read,   // MEM stage flag
        input                   i_EX_mem_write,  // MEM stage flag
        input                   i_EX_branch,     // MEM stage flag
        input                   i_EX_alu_src,
        input                   i_EX_reg_dest,
        input [NB_ALU_OP-1:0]   i_EX_alu_op,
        input [NB_PC-1:0]       i_EX_pc,
        input [NB_DATA-1:0]     i_EX_data_a,
        input [NB_DATA-1:0]     i_EX_data_b,
        input [NB_IMM-1:0]      i_EX_immediate,
        input [NB_DATA-1:0]     i_EX_shamt,
        input [NB_REG-1:0]      i_EX_rt,
        input [NB_REG-1:0]      i_EX_rd,
        input                   i_EX_byte_en,
        input                   i_EX_halfword_en,
        input                   i_EX_word_en,
        input                   i_EX_hlt,
        input [NB_DATA-1:0]     i_EX_mem_fwd_data, // forwarding
        input [NB_DATA-1:0]     i_EX_wb_fwd_data,  // forwarding
        input [NB_SEL-1:0]      i_EX_fwd_a,        // FORWARDING UNIT
        input [NB_SEL-1:0]      i_EX_fwd_b,        // FORWARDING UNIT
        
        output                  o_EX_signed,
        output                  o_EX_reg_write,
        output                  o_EX_mem_to_reg,
        output                  o_EX_mem_read,
        output                  o_EX_mem_write,
        output                  o_EX_branch,
        output [NB_PC-1:0]      o_EX_branch_addr,
        output                  o_EX_zero,
        output [NB_DATA-1:0]    o_EX_alu_result,
        output [NB_DATA-1:0]    o_EX_data_b,
        output [NB_REG-1:0]     o_EX_selected_reg,
        output                  o_EX_byte_en,
        output                  o_EX_halfword_en,
        output                  o_EX_word_en,
        output                  o_EX_r31_ctrl,
        output [NB_PC-1:0]      o_EX_pc,
        output                  o_EX_hlt
    );
    
    wire [NB_IMM-1:0]       shifted_imm;
    wire [NB_PC-1:0]        branch_addr;
    wire [NB_DATA-1:0]      out_mux_6;
    wire [NB_DATA-1:0]      out_mux_7;
    wire [NB_DATA-1:0]      alu_data_a;
    wire [NB_DATA-1:0]      alu_data_b;
    wire                    zero;
    wire [NB_DATA-1:0]      alu_result;
    wire [NB_ALU_CTRL-1:0]  alu_ctrl;
    wire [NB_REG-1:0]       rt_rd;
    wire [NB_REG-1:0]       selected_reg;
    wire [NB_FCODE-1:0]     funct_code;
    
    wire                    select_shamt;
    wire                    r31_ctrl;

    reg [NB_REG-1:0]        r31 = 5'd31;
    
    assign funct_code = i_EX_immediate [NB_FCODE-1:0];
    
    adder adder_2(.i_a(i_EX_pc),
                  .i_b(shifted_imm),
                  .o_result(branch_addr));

    alu alu_1(.i_a(alu_data_a),
              .i_b(alu_data_b),
              .i_alu_ctrl(alu_ctrl),
              .o_zero(zero),
              .o_result(alu_result));

    alu_control alu_control_1(.i_funct_code(funct_code), //chequear esto
                              .i_alu_op(i_EX_alu_op),
                              .o_alu_ctrl(alu_ctrl),
                              .o_shamt_ctrl(select_shamt),
                              .o_r31_ctrl(r31_ctrl));

    shifter shifter_1(.i_data(i_EX_immediate),
                      .o_result(shifted_imm));

    mux2 mux2_7(.i_select(i_EX_alu_src),
                .i_a(i_EX_data_b),
                .i_b(i_EX_immediate),
                .o_data(out_mux_7));

    mux2 #(.NB(5)) mux2_4(.i_select(i_EX_reg_dest),
                .i_a(i_EX_rt),
                .i_b(i_EX_rd),
                .o_data(rt_rd));

    mux2 #(.NB(5)) mux2_5(.i_select(r31_ctrl),
                .i_a(rt_rd),
                .i_b(r31),
                .o_data(selected_reg));

    mux2 mux2_6(.i_select(select_shamt),
                .i_a(i_EX_shamt),
                .i_b(i_EX_data_a),
                .o_data(out_mux_6));
        
    mux4 mux4_8(.i_select(i_EX_fwd_a),
                .i_a(out_mux_6),          // 00
                .i_b(i_EX_mem_fwd_data),  // 01
                .i_c(i_EX_wb_fwd_data),   // 10
                .i_d(),
                .o_data(alu_data_a));

    mux4 mux4_9(.i_select(i_EX_fwd_b),
                .i_a(out_mux_7),          // 00
                .i_b(i_EX_mem_fwd_data),  // 01
                .i_c(i_EX_wb_fwd_data),   // 10
                .i_d(),
                .o_data(alu_data_b));

    assign o_EX_signed          = i_EX_signed;
    assign o_EX_reg_write       = i_EX_reg_write;
    assign o_EX_mem_to_reg      = i_EX_mem_to_reg;
    assign o_EX_mem_read        = i_EX_mem_read;
    assign o_EX_mem_write       = i_EX_mem_write;
    assign o_EX_branch          = i_EX_branch;
    assign o_EX_branch_addr     = branch_addr;
    assign o_EX_zero            = zero;
    assign o_EX_alu_result      = alu_result;
    assign o_EX_data_b          = i_EX_data_b; 
    assign o_EX_selected_reg    = selected_reg;
    assign o_EX_byte_en         = i_EX_byte_en;
    assign o_EX_halfword_en     = i_EX_halfword_en;
    assign o_EX_word_en         = i_EX_word_en;
    assign o_EX_r31_ctrl        = r31_ctrl;
    assign o_EX_pc              = i_EX_pc;
    assign o_EX_hlt             = i_EX_hlt;

endmodule
