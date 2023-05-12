`timescale 1ns / 1ps

module TOP#(
        parameter NB_PC             = 32,
        parameter NB_INSTRUCTION    = 32,
        parameter NB_DATA           = 32,
        parameter NB_REG            = 5, 
        parameter NB_ADDR           = 32,
        parameter NB_DM_ADDR        = 7,
        parameter NB_OPCODE         = 6,
        parameter NB_MEM_WIDTH      = 8  // Todas las memorias, excepto bank register tienen WIDTH = 8
    )
    (
        input                       i_clock,
        input                       i_clock_reset,
        input                       i_pc_enable,
        input                       i_pc_reset,
        input                       i_read_enable,
        input                       i_ID_stage_reset,

        input                       i_im_enable,          // DEBUG UNIT
        input                       i_im_write_enable,    // DEBUG UNIT
        input [NB_MEM_WIDTH-1:0]    i_im_data,            // DEBUG UNIT
        input [NB_ADDR-1:0]         i_im_address,         // DEBUG UNIT

        input                       i_rb_enable,          // DEBUG UNIT
        input                       i_rb_read_enable,     // DEBUG UNIT
        input [NB_REG-1:0]          i_rb_address,         // DEBUG UNIT

        input                       i_dm_enable,          // DEBUG UNIT
        input                       i_dm_read_enable,     // DEBUG UNIT
        input [NB_DM_ADDR-1:0]      i_dm_read_address,    // DEBUG UNIT

        input                       i_cu_enable,          // DEBUG UNIT

        output                      o_hlt,                // DEBUG UNIT
        output [NB_PC-1:0]          o_pc_value,           // DEBUG UNIT
        output [NB_DATA-1:0]        o_rb_data,            // DEBUG UNIT
        output [NB_MEM_WIDTH-1:0]   o_dm_data             // DEBUG UNIT
    );

    assign o_pc_value = IF_adder_result;
    assign o_rb_data  = ID_data_a;
    
    wire clk_wiz;
    
    clk_wiz_0 inst
      (
      // Clock out ports  
      .clk_out1(clk_wiz),
      // Status and control signals               
      .reset(i_clock_reset), 
      .locked(locked),
     // Clock in ports
      .clk_in1(i_clock)
      );
    
    // IF_stage to IF_ID_reg
    wire [NB_PC-1:0]            IF_adder_result;
    wire [NB_INSTRUCTION-1:0]   IF_new_instruction;
    
    // IF_ID_reg to ID_stage
    wire [NB_PC-1:0]            ID_adder_result;
    wire [NB_INSTRUCTION-1:0]   ID_new_instruction;
    
    // ID_stage to ID_EX_reg
    wire                        ID_reg_dest;
    wire [NB_OPCODE-1:0]        ID_alu_op;
    wire                        ID_alu_src;
    wire                        ID_mem_read;
    wire                        ID_mem_write;
    wire                        ID_branch;
    wire                        ID_reg_write;
    wire                        ID_mem_to_reg;
    wire [NB_DATA-1:0]          ID_data_a;
    wire [NB_DATA-1:0]          ID_data_b;
    wire [NB_PC-1:0]            ID_immediate;
    wire [NB_DATA-1:0]          ID_shamt;
    wire [NB_REG-1:0]           ID_rt;
    wire [NB_REG-1:0]           ID_rd;
    wire [NB_PC-1:0]            ID_pc;
    wire                        ID_byte_en;
    wire                        ID_halfword_en;
    wire                        ID_word_en;
    
    // ID_stage to IF_stage
    wire                        ID_jump;
    wire                        ID_hlt;
    wire                        ID_jr_jalr;
    wire [NB_PC-1:0]            ID_jump_address;
    wire [NB_PC-1:0]            ID_r31_data;
    
    // ID_EX_reg to EX_stage
    wire                        EX_reg_dest;
    wire [NB_OPCODE-1:0]        EX_alu_op;
    wire                        EX_alu_src;
    wire                        EX_mem_read;
    wire                        EX_mem_write;
    wire                        EX_branch;
    wire                        EX_reg_write;
    wire                        EX_mem_to_reg;
    wire [NB_DATA-1:0]          EX_data_a;
    wire [NB_DATA-1:0]          EX_data_b;
    wire [NB_PC-1:0]            EX_immediate;
    wire [NB_DATA-1:0]          EX_shamt;
    wire [NB_REG-1:0]           EX_rt;
    wire [NB_REG-1:0]           EX_rd;
    wire [NB_PC-1:0]            EX_pc;
    wire                        EX_byte_en;
    wire                        EX_halfword_en;
    wire                        EX_word_en;
    wire                        EX_hlt;
    
    // EX_stage to EX_MEM_reg
    wire                        o_EX_reg_write;     // Se les agrega el "o_" para diferenciar de
    wire                        o_EX_mem_to_reg;    // las se�ales de entrada, que son las mismas
    wire                        o_EX_mem_read;      // (declaradas en el bloque anterior)
    wire                        o_EX_mem_write;
    wire                        o_EX_branch;
    wire [NB_PC-1:0]            EX_branch_addr;
    wire                        EX_zero;
    wire [NB_DATA-1:0]          EX_alu_result;
    wire [NB_DATA-1:0]          o_EX_data_b;
    wire [NB_REG-1:0]           EX_selected_reg;
    wire                        o_EX_byte_en;
    wire                        o_EX_halfword_en;
    wire                        o_EX_word_en;
    wire                        EX_r31_ctrl;
    wire [NB_PC-1:0]            o_EX_pc;
    wire                        o_EX_hlt;
    
    // EX_MEM_reg to MEM_stage
    wire                        MEM_reg_write;
    wire                        MEM_mem_to_reg;
    wire                        MEM_mem_read;
    wire                        MEM_mem_write;
    wire                        MEM_branch;
    wire [NB_PC-1:0]            MEM_branch_addr;
    wire                        MEM_zero;
    wire [NB_DATA-1:0]          MEM_alu_result;
    wire [NB_DATA-1:0]          MEM_data_b;
    wire [NB_REG-1:0]           MEM_selected_reg;
    wire                        MEM_byte_en;
    wire                        MEM_halfword_en;
    wire                        MEM_word_en;
    wire                        MEM_r31_ctrl;
    wire [NB_PC-1:0]            MEM_pc;
    wire                        MEM_hlt;

    // MEM_stage to MEM_WB_reg
    wire [NB_DATA-1:0]          MEM_mem_data;
    wire [NB_REG-1:0]           o_MEM_selected_reg;
    wire [NB_ADDR-1:0]          o_MEM_alu_result;
    wire                        o_MEM_reg_write;
    wire                        o_MEM_mem_to_reg;
    wire                        o_MEM_r31_ctrl;
    wire [NB_PC-1:0]            o_MEM_pc;
    wire                        o_MEM_hlt;

    // MEM_stage to IF_stage
    wire [NB_PC-1:0]            o_MEM_branch_addr;
    wire                        MEM_branch_zero;

    // MEM_WB_reg to WB_stage
    wire                        WB_reg_write;
    wire                        WB_mem_to_reg;
    wire [NB_DATA-1:0]          WB_mem_data;
    wire [NB_DATA-1:0]          WB_alu_result;
    wire [NB_REG-1:0]           WB_selected_reg;
    wire                        WB_r31_ctrl;
    wire [NB_PC-1:0]            WB_pc;

    // WB_stage to ID_stage
    wire                        o_WB_reg_write;
    wire [NB_DATA-1:0]          WB_selected_data;
    wire [NB_REG-1:0]           o_WB_selected_reg;


    
    IF_stage IF_stage_1(.i_clock(i_clock),
                        .i_IF_im_enable(i_im_enable),
                        .i_IF_branch(MEM_branch_zero),
                        .i_IF_j_jal(ID_jump),
                        .i_IF_jr_jalr(ID_jr_jalr),
                        .i_IF_pc_enable(i_pc_enable),
                        .i_IF_pc_reset(i_pc_reset),
                        .i_IF_read_enable(i_read_enable),
                        .i_IF_write_enable(i_im_write_enable),
                        .i_IF_write_data(i_im_data),
                        .i_IF_write_addr(i_im_address),
                        .i_IF_branch_addr(o_MEM_branch_addr),
                        .i_IF_jump_address(ID_jump_address),
                        .i_IF_r31_data(ID_r31_data),
                        .o_IF_adder_result(IF_adder_result),
                        .o_IF_new_instruction(IF_new_instruction));
                        
    IF_ID_reg IF_ID_reg_1(.i_clock(i_clock),
                          .IF_adder_result(IF_adder_result),
                          .IF_new_instruction(IF_new_instruction),
                          .ID_adder_result(ID_adder_result),
                          .ID_new_instruction(ID_new_instruction));
    
    ID_stage ID_stage_1(.i_clock(i_clock),
                        .i_ID_reset(i_ID_stage_reset),
                        .i_ID_rb_enable(i_rb_enable), // Debug Unit
                        .i_ID_rb_read_enable(i_rb_read_enable), // Debug Unit
                        .i_ID_rb_read_address(i_rb_address), // Debug Unit
                        .i_ID_cu_enable(i_cu_enable),  // Debug Unit
                        .i_ID_inst(ID_new_instruction),
                        .i_ID_pc(ID_adder_result),
                        .i_ID_write_data(WB_selected_data),
                        .i_ID_write_reg(o_WB_selected_reg),
                        .i_ID_reg_write(o_WB_reg_write),
                        .o_ID_reg_dest(ID_reg_dest),
                        .o_ID_alu_op(ID_alu_op),
                        .o_ID_alu_src(ID_alu_src),
                        .o_ID_mem_read(ID_mem_read),
                        .o_ID_mem_write(ID_mem_write),
                        .o_ID_branch(ID_branch),
                        .o_ID_reg_write(ID_reg_write),
                        .o_ID_mem_to_reg(ID_mem_to_reg),
                        .o_ID_jump(ID_jump),
                        .o_ID_hlt(ID_hlt),
                        .o_ID_jr_jalr(ID_jr_jalr),
                        .o_ID_jump_address(ID_jump_address),
                        .o_ID_data_a(ID_data_a),
                        .o_ID_data_b(ID_data_b),
                        .o_ID_immediate(ID_immediate),
                        .o_ID_shamt(ID_shamt),
                        .o_ID_rt(ID_rt),
                        .o_ID_rd(ID_rd),
                        .o_ID_pc(ID_pc),
                        .o_ID_byte_en(ID_byte_en),
                        .o_ID_halfword_en(ID_halfword_en),
                        .o_ID_word_en(ID_word_en),
                        .o_ID_r31_data(ID_r31_data));
                        
    ID_EX_reg ID_EX_reg_1(.i_clock(i_clock),
                          .ID_reg_write(ID_reg_write),
                          .ID_mem_to_reg(ID_mem_to_reg),
                          .ID_mem_read(ID_mem_read),
                          .ID_mem_write(ID_mem_write),
                          .ID_branch(ID_branch),
                          .ID_alu_src(ID_alu_src),
                          .ID_reg_dest(ID_reg_dest),
                          .ID_alu_op(ID_alu_op),
                          .ID_pc(ID_pc),
                          .ID_data_a(ID_data_a),
                          .ID_data_b(ID_data_b),
                          .ID_immediate(ID_immediate),
                          .ID_shamt(ID_shamt),
                          .ID_rt(ID_rt),
                          .ID_rd(ID_rd),
                          .ID_byte_en(ID_byte_en),
                          .ID_halfword_en(ID_halfword_en),
                          .ID_word_en(ID_word_en),
                          .ID_hlt(ID_hlt),
                          .EX_reg_write(EX_reg_write),
                          .EX_mem_to_reg(EX_mem_to_reg),
                          .EX_mem_read(EX_mem_read),
                          .EX_mem_write(EX_mem_write),
                          .EX_branch(EX_branch),
                          .EX_alu_src(EX_alu_src),
                          .EX_reg_dest(EX_reg_dest),
                          .EX_alu_op(EX_alu_op),
                          .EX_pc(EX_pc),
                          .EX_data_a(EX_data_a),
                          .EX_data_b(EX_data_b),
                          .EX_immediate(EX_immediate),
                          .EX_shamt(EX_shamt),
                          .EX_rt(EX_rt),
                          .EX_rd(EX_rd),
                          .EX_byte_en(EX_byte_en),
                          .EX_halfword_en(EX_halfword_en),
                          .EX_word_en(EX_word_en),
                          .EX_hlt(EX_hlt));
    
    EX_stage EX_stage_1(.i_EX_reg_write(EX_reg_write),
                        .i_EX_mem_to_reg(EX_mem_to_reg),
                        .i_EX_mem_read(EX_mem_read),
                        .i_EX_mem_write(EX_mem_write),
                        .i_EX_branch(EX_branch),
                        .i_EX_alu_src(EX_alu_src),
                        .i_EX_reg_dest(EX_reg_dest),
                        .i_EX_alu_op(EX_alu_op),
                        .i_EX_pc(EX_pc),
                        .i_EX_data_a(EX_data_a),
                        .i_EX_data_b(EX_data_b),
                        .i_EX_immediate(EX_immediate),
                        .i_EX_shamt(EX_shamt),
                        .i_EX_rt(EX_rt),
                        .i_EX_rd(EX_rd),
                        .i_EX_byte_en(EX_byte_en),
                        .i_EX_halfword_en(EX_halfword_en),
                        .i_EX_word_en(EX_word_en),
                        .i_EX_hlt(EX_hlt),
                        .o_EX_reg_write(o_EX_reg_write),
                        .o_EX_mem_to_reg(o_EX_mem_to_reg),
                        .o_EX_mem_read(o_EX_mem_read),
                        .o_EX_mem_write(o_EX_mem_write),
                        .o_EX_branch(o_EX_branch),
                        .o_EX_branch_addr(EX_branch_addr),
                        .o_EX_zero(EX_zero),
                        .o_EX_alu_result(EX_alu_result),
                        .o_EX_data_b(o_EX_data_b),
                        .o_EX_selected_reg(EX_selected_reg),
                        .o_EX_byte_en(o_EX_byte_en),
                        .o_EX_halfword_en(o_EX_halfword_en),
                        .o_EX_word_en(o_EX_word_en),
                        .o_EX_r31_ctrl(EX_r31_ctrl),
                        .o_EX_pc(o_EX_pc),
                        .o_EX_hlt(o_EX_hlt));
                        
    EX_MEM_reg EX_MEM_reg_1(.i_clock(i_clock),
                            .EX_reg_write(o_EX_reg_write),
                            .EX_mem_to_reg(o_EX_mem_to_reg),
                            .EX_mem_read(o_EX_mem_read),
                            .EX_mem_write(o_EX_mem_write),
                            .EX_branch(o_EX_branch),
                            .EX_branch_addr(EX_branch_addr),
                            .EX_zero(EX_zero),
                            .EX_alu_result(EX_alu_result),
                            .EX_data_b(o_EX_data_b),
                            .EX_selected_reg(EX_selected_reg),
                            .EX_byte_en(o_EX_byte_en),
                            .EX_halfword_en(o_EX_halfword_en),
                            .EX_word_en(o_EX_word_en),
                            .EX_r31_ctrl(EX_r31_ctrl),
                            .EX_pc(o_EX_pc),
                            .EX_hlt(o_EX_hlt),
                            .MEM_reg_write(MEM_reg_write),
                            .MEM_mem_to_reg(MEM_mem_to_reg),
                            .MEM_mem_read(MEM_mem_read),
                            .MEM_mem_write(MEM_mem_write),
                            .MEM_branch(MEM_branch),
                            .MEM_branch_addr(MEM_branch_addr),
                            .MEM_zero(MEM_zero),
                            .MEM_alu_result(MEM_alu_result),
                            .MEM_data_b(MEM_data_b),
                            .MEM_selected_reg(MEM_selected_reg),
                            .MEM_byte_en(MEM_byte_en),
                            .MEM_halfword_en(MEM_halfword_en),
                            .MEM_word_en(MEM_word_en),
                            .MEM_r31_ctrl(MEM_r31_ctrl),
                            .MEM_pc(MEM_pc),
                            .MEM_hlt(MEM_hlt));
                
    MEM_stage MEM_stage_1(.i_clock(i_clock),
                          .i_MEM_dm_enable(i_dm_enable),  // Debug Unit
                          .i_MEM_dm_read_enable(i_dm_read_enable),  // Debug Unit
                          .i_MEM_dm_read_address(i_dm_read_address),  // Debug Unit
                          .i_MEM_reg_write(MEM_reg_write),
                          .i_MEM_mem_to_reg(MEM_mem_to_reg),
                          .i_MEM_mem_read(MEM_mem_read),
                          .i_MEM_mem_write(MEM_mem_write),
                          .i_MEM_word_en(MEM_word_en),
                          .i_MEM_halfword_en(MEM_halfword_en),
                          .i_MEM_byte_en(MEM_byte_en),
                          .i_MEM_branch(MEM_branch),
                          .i_MEM_zero(MEM_zero),
                          .i_MEM_branch_addr(MEM_branch_addr),
                          .i_MEM_alu_result(MEM_alu_result),
                          .i_MEM_write_data(MEM_data_b),
                          .i_MEM_selected_reg(MEM_selected_reg),
                          .i_MEM_r31_ctrl(MEM_r31_ctrl),
                          .i_MEM_pc(MEM_pc),
                          .i_MEM_hlt(MEM_hlt),
                          .o_MEM_mem_data(MEM_mem_data),
                          .o_MEM_selected_reg(o_MEM_selected_reg),
                          .o_MEM_alu_result(o_MEM_alu_result),
                          .o_MEM_branch_addr(o_MEM_branch_addr),
                          .o_MEM_branch_zero(MEM_branch_zero),
                          .o_MEM_reg_write(o_MEM_reg_write),
                          .o_MEM_mem_to_reg(o_MEM_mem_to_reg),
                          .o_MEM_r31_ctrl(o_MEM_r31_ctrl),
                          .o_MEM_pc(o_MEM_pc),
                          .o_MEM_byte_data(o_dm_data),  // Debug Unit
                          .o_MEM_hlt(o_MEM_hlt));
                         
    MEM_WB_reg MEM_WB_reg_1(.i_clock(i_clock),
                            .i_MEM_reg_write(o_MEM_reg_write),
                            .i_MEM_mem_to_reg(o_MEM_mem_to_reg),
                            .i_MEM_mem_data(MEM_mem_data),
                            .i_MEM_alu_result(MEM_alu_result),
                            .i_MEM_selected_reg(o_MEM_selected_reg),
                            .i_MEM_r31_ctrl(o_MEM_r31_ctrl),
                            .i_MEM_pc(o_MEM_pc),
                            .i_MEM_hlt(MEM_hlt),
                            .o_WB_reg_write(WB_reg_write),
                            .o_WB_mem_to_reg(WB_mem_to_reg),
                            .o_WB_mem_data(WB_mem_data),
                            .o_WB_alu_result(WB_alu_result),
                            .o_WB_selected_reg(WB_selected_reg),
                            .o_WB_r31_ctrl(WB_r31_ctrl),
                            .o_WB_pc(WB_pc),
                            .o_WB_hlt(WB_hlt));
                          
    WB_stage WB_stage_1(.i_WB_reg_write(WB_reg_write),
                        .i_WB_mem_to_reg(WB_mem_to_reg),
                        .i_WB_mem_data(WB_mem_data),
                        .i_WB_alu_result(WB_alu_result),
                        .i_WB_selected_reg(WB_selected_reg),
                        .i_WB_r31_ctrl(WB_r31_ctrl),
                        .i_WB_pc(WB_pc),
                        .i_WB_hlt(WB_hlt),
                        .o_WB_reg_write(o_WB_reg_write),
                        .o_WB_selected_data(WB_selected_data),
                        .o_WB_selected_reg(o_WB_selected_reg),
                        .o_WB_hlt(o_hlt));

endmodule
