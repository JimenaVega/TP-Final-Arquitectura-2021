`timescale 1ns / 1ps

module ID_stage#(
        parameter NB_PC_CONSTANT    = 3,
        parameter NB_INST           = 32,
        parameter NB_PC             = 32,
        parameter NB_DATA           = 32,
        parameter NB_REG            = 5, 
        parameter NB_OPCODE         = 6
    )
    (
        input                       i_clock,
        input                       i_pipeline_enable,
        input                       i_ID_reset,
        input                       i_ID_cu_enable,         // Debug Unit
        input                       i_ID_rb_enable,         // Debug Unit
        input                       i_ID_rb_read_enable,    // Debug Unit
        input [NB_REG-1:0]          i_ID_rb_read_address,   // Debug Unit
        input [NB_INST-1:0]         i_ID_inst,
        input [NB_PC-1:0]           i_ID_pc,
        input [NB_DATA-1:0]         i_ID_write_data,   // from WB, data to write
        input [NB_REG-1:0]          i_ID_write_reg,    // from WB, address to write
        input                       i_ID_reg_write,    // from control_unit, enable write reg
        input                       i_ID_ctrl_sel,
        output                      o_ID_signed,
        output                      o_ID_reg_dest,     // EX, signal
        output [NB_OPCODE-1:0]      o_ID_alu_op,       // EX, signal
        output                      o_ID_alu_src,      // EX, signal
        output                      o_ID_mem_read,     // MEM, signal
        output                      o_ID_mem_write,    // MEM, signal
        output                      o_ID_branch,       // MEM, signal
        output                      o_ID_reg_write,    // WB, signal
        output                      o_ID_mem_to_reg,   // WB, signal
        output                      o_ID_jump,         // ID, signal
        output                      o_ID_hlt,
        output                      o_ID_jr_jalr,      // IF
        output [NB_PC-1:0]          o_ID_jump_address,  
        output [NB_DATA-1:0]        o_ID_data_a,
        output [NB_DATA-1:0]        o_ID_data_b,
        output [NB_PC-1:0]          o_ID_immediate,    // immediate 32b / function code
        output [NB_DATA-1:0]        o_ID_shamt,
        output [NB_REG-1:0]         o_ID_rt,
        output [NB_REG-1:0]         o_ID_rd,
        output [NB_REG-1:0]         o_ID_rs,
        output [NB_PC-1:0]          o_ID_pc,
        output                      o_ID_byte_en,
        output                      o_ID_halfword_en,
        output                      o_ID_word_en
    );

    wire                jr_jalr; // Para que register bank lea el r31

    registers_bank registers_bank_1(.i_clock(i_clock),
                                    .i_enable(i_ID_rb_enable), // Debug Unit
                                    .i_read_enable(i_ID_rb_read_enable), // Debug Unit
                                    .i_read_address(i_ID_rb_read_address), // Debug Unit
                                    .i_reset(i_ID_reset),
                                    .i_reg_write(i_ID_reg_write),   // Señal de control RegWrite proveniente de WB
                                    .i_read_reg_a(i_ID_inst[25:21]),
                                    .i_read_reg_b(i_ID_inst[20:16]), 
                                    .i_write_reg(i_ID_write_reg),   // Address 5b
                                    .i_write_data(i_ID_write_data), // Data 32b
                                    .o_data_a(o_ID_data_a),
                                    .o_data_b(o_ID_data_b));


    control_unit control_unit_1(.i_clock(i_clock),
                                .i_enable(i_ID_cu_enable),      // Debug Unit
                                .i_reset(i_ID_reset),           // Necesario para flush en controls hazard
                                .i_opcode(i_ID_inst[31:26]),
                                .i_funct(i_ID_inst[5:0]),
                                .i_ctrl_sel(i_ID_ctrl_sel),     // STALL UNIT: 0 -> señales normales 1 -> flush
                                .o_reg_dest(o_ID_reg_dest),     // EX
                                .o_signed(o_ID_signed),
                                .o_alu_op(o_ID_alu_op),         // EX REG?
                                .o_alu_src(o_ID_alu_src),       // EX
                                .o_mem_read(o_ID_mem_read),     // MEM
                                .o_mem_write(o_ID_mem_write),   // MEM
                                .o_branch(o_ID_branch),         // MEM
                                .o_reg_write(o_ID_reg_write),   // WB
                                .o_mem_to_reg(o_ID_mem_to_reg), // WB
                                .o_jump(o_ID_jump),
                                .o_byte_en(o_ID_byte_en),
                                .o_halfword_en(o_ID_halfword_en),
                                .o_word_en(o_ID_word_en),
                                .o_jr_jalr(jr_jalr),             // IF
                                .o_hlt(o_ID_hlt));

    sign_extend sign_extend_1(.i_data(i_ID_inst[15:0]),
                              .o_data(o_ID_immediate));
    
    extend extend(.i_data(i_ID_inst[10:6]),
                  .o_data(o_ID_shamt));

    concat_module concat_module_1(.i_clock(i_clock),
                                  .i_reset(i_ID_reset),
                                  .i_enable(i_pipeline_enable),
                                  .i_inst(i_ID_inst[25:0]),                           
                                  .i_next_pc(i_ID_pc[31:28]),          // PC+1[31:28]                
                                  .o_jump_addr(o_ID_jump_address));
    
    // TODO: Agregar wires intermedios
    assign o_ID_rd = i_ID_inst[15:11];
    assign o_ID_rt = i_ID_inst[20:16];
    assign o_ID_rs = i_ID_inst[25:21];
    assign o_ID_pc = i_ID_pc;
    assign o_ID_jr_jalr = jr_jalr;

endmodule 