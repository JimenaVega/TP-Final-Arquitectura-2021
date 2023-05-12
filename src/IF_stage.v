`timescale 1ns / 1ps

module IF_stage#(
        parameter NB_PC             = 32,
        parameter NB_INSTRUCTION    = 32,
        parameter NB_MEM_WIDTH      = 8
    )
    (
        input                       i_clock,
        input                       i_IF_branch,       // 1 -> Hay branch, 0 -> No hay branch
        input                       i_IF_j_jal,        // 1 -> Hay jump, 0 -> No hay jump
        input                       i_IF_jr_jalr,      // 1 -> Hay jump, 0 -> No hay jump
        input                       i_IF_pc_enable,
        input                       i_IF_pc_reset,
        input                       i_IF_read_enable,
        input                       i_IF_im_enable,     // DEBUG_UNIT control
        input                       i_IF_write_enable,  // DEBUG_UNIT control
        input  [NB_MEM_WIDTH-1:0]   i_IF_write_data,    // DEBUG_UNIT control
        input  [NB_PC-1:0]          i_IF_write_addr,    // DEBUG_UNIT control
        input  [NB_PC-1:0]          i_IF_branch_addr,
        input  [NB_PC-1:0]          i_IF_jump_address,  // J y JAL
        input  [NB_PC-1:0]          i_IF_r31_data,      // JR y JALR
        
        output [NB_PC-1:0]          o_IF_adder_result,  // PC+1
        output [NB_INSTRUCTION-1:0] o_IF_new_instruction
    );
    
    wire [NB_PC-1:0]            new_pc_value;
    wire [NB_PC-1:0]            adder_result; // PC+1
    wire [NB_PC-1:0]            mux2_1_output;
    wire [NB_PC-1:0]            mux2_2_output;
    wire [NB_PC-1:0]            mux2_3_output;
    wire [NB_PC-1:0]            jump_address;
    wire [NB_INSTRUCTION-1:0]   new_instruction;
    
    reg [NB_PC-1:0]    pc_constant = 32'd4;
    
    program_counter program_counter_1(.i_enable(i_IF_pc_enable),
                                      .i_clock(i_clock),
                                      .i_reset(i_IF_pc_reset),
                                      .i_mux_pc(mux2_3_output),
                                      .o_pc_mem(new_pc_value));
    
    adder adder_1(.i_a(new_pc_value),
                  .i_b(pc_constant),
                  .o_result(adder_result));
    
    mux2 mux2_1(.i_select(i_IF_branch),
                .i_a(adder_result),     // PC+1
                .i_b(i_IF_branch_addr), // branch
                .o_data(mux2_1_output));
                
    mux2 mux2_2(.i_select(i_IF_j_jal),
                .i_a(mux2_1_output),
                .i_b(i_IF_jump_address),
                .o_data(mux2_2_output));

    mux2 mux2_3(.i_select(i_IF_jr_jalr),
                .i_a(mux2_2_output),
                .i_b(i_IF_r31_data),
                .o_data(mux2_3_output));            
    
    instruction_memory instruction_memory_1(.i_clock(i_clock),
                                            .i_enable(i_IF_im_enable),
                                            .i_write_enable(i_IF_write_enable),
                                            .i_read_enable(i_IF_read_enable),
                                            .i_write_data(i_IF_write_data),
                                            .i_write_addr(i_IF_write_addr),
                                            .i_addr(new_pc_value),
                                            .o_read_data(new_instruction));
    
    assign o_IF_adder_result    = adder_result;                   
    assign o_IF_new_instruction = new_instruction;
    
endmodule

