`timescale 1ns / 1ps

module IF_stage#(
        parameter NB_PC_CONSTANT    = 3,
        parameter NB_PC             = 6,
        parameter NB_INSTRUCTION    = 32
    )
    (
        input                       i_clock,
        input                       i_branch, // 1 -> Hay branch, 0 -> No hay branch
        input                       i_jump,   // 1 -> Hay jump, 0 -> No hay jump
        input                       i_pc_enable,
        input                       i_pc_reset,
        input                       i_read_enable,
        input  [NB_PC-1:0]          i_branch_address,
        input  [NB_PC-1:0]          i_jump_address,
        
        output [NB_PC:0]            o_adder_result,
        output [NB_INSTRUCTION-1:0] o_new_instruction
    );
    
    wire [NB_PC-1:0]            new_pc_value;
    wire [NB_PC-1:0]            adder_result; // PC+1
    wire [NB_PC-1:0]            mux2_1_output;
    wire [NB_PC-1:0]            mux2_2_output;
    wire [NB_PC-1:0]            jump_address;
    wire [NB_INSTRUCTION-1:0]   new_instruction;
    
    reg [NB_PC_CONSTANT-1:0]    pc_constant = 3'h04;
    
    program_counter program_counter_1(.i_enable(i_pc_enable),
                                      .i_clock(i_clock),
                                      .i_reset(i_pc_reset),
                                      .i_mux_pc(mux2_2_output),
                                      .o_pc_mem(new_pc_value));
    
    adder adder_1(.i_a(new_pc_value),
                  .i_b(pc_constant),
                  .o_result(adder_result));
    
    mux2 mux2_1(.i_select(i_branch),
                .i_a(adder_result),
                .i_b(i_branch_address),
                .o_data(mux2_1_output));
                
    mux2 mux2_2(.i_select(i_jump),
                .i_a(mux2_1_output),
                .i_b(i_jump_address),
                .o_data(mux2_2_output));
    
    instruction_memory(.i_clock(i_clock),
                       .i_write_enable(),
                       .i_read_enable(i_read_enable),
                       .i_rstb(),
                       .i_regceb(),
                       .i_write_addr(),
                       .i_read_addr(new_pc_value),
                       .i_write_data(),
                       .o_read_data(new_instruction));
    
    assign o_adder_result    = adder_result;                   
    assign o_new_instruction = new_instruction;
    
endmodule

