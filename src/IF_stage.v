`timescale 1ns / 1ps

module IF_stage#(
        parameter NB_PC_CONSTANT    = 3,
        parameter NB_PC             = 32
    )
    (
        input               i_clock,
        input [NB_PC-1:0]   i_b_mux
    );
    
    wire [NB_PC-1:0] new_pc_value;
    wire [NB_PC-1:0] adder_result;
    
    reg [NB_PC_CONSTANT-1:0] pc_constant = 3'h04;
    
    program_counter program_counter_1(.i_enable(),
                                      .i_clock(i_clock),
                                      .i_reset(),
                                      .i_mux_pc(),
                                      .o_pc_mem(new_pc_value));
    
    adder adder_1(.i_a(new_pc_value),
                  .i_b(pc_constant),
                  .o_result(adder_result));
    
    mux2 mux2_1(.i_select(),
                .i_a(adder_result),
                .i_b(i_b_mux),
                .o_data());
    
    instruction_memory(.i_clock(i_clock),
                       .i_write_enable(),
                       .i_read_enable(new_pc_value),
                       .i_rstb(),
                       .i_regceb(),
                       .i_write_addr(),
                       .i_read_addr(),
                       .i_write_data(),
                       .o_read_data());
    
endmodule

