`timescale 1ns / 1ps

module MEM_stage#(
        parameter NB_ADDR = 32,
        parameter NB_DATA = 32,
        parameter NB_PC   = 32,
        parameter NB_REG  = 5
    )
    (
        input i_clock,
        input i_reset,
        input i_MEM_reg_write,  // WB stage flag
        input i_MEM_mem_to_reg, // WB stage flag
        input i_MEM_mem_read,   // read data memory flag
        input i_MEM_mem_write,  // write data memory flag
        input i_MEM_word_en,
        input i_MEM_halfword_en,
        input i_MEM_byte_en,
        input i_MEM_branch,     // branch 
        input i_MEM_zero,       // zero flag 
        input [NB_PC-1:0]    i_MEM_branch_addr,  
        input [NB_ADDR-1:0]  i_MEM_alu_result,   // write and read address in data memory
        input [NB_DATA-1:0]  i_MEM_write_data,   // data to write in data memory - data A in EX
        input [NB_REG-1:0]   i_MEM_selected_reg, // WB register (rd or rt)

        output [NB_DATA-1:0] o_MEM_mem_data,
        output [NB_REG-1:0]  o_MEM_selected_reg,   // WB register (rd or rt)
        output [NB_ADDR-1:0] o_MEM_alu_result,     // only for R type and stores (never loads)
        output [NB_PC-1:0]   o_MEM_branch_addr, // PC = o_MEM_branch_addr
        output               o_MEM_branch_zero,        // IF mux selector
        output               o_MEM_reg_write,      // WB stage flag
        output               o_MEM_mem_to_reg     // WB stage flag
    );

    data_memory data_memory_1(.i_clock(i_clock),                           
                              .i_mem_write_flag(i_MEM_mem_write),                   
                              .i_mem_read_flag(i_MEM_mem_read),
                              .i_word_en(i_MEM_word_en),
                              .i_halfword_en(i_MEM_halfword_en),
                              .i_byte_en(i_MEM_byte_en),                           
                              .i_address(i_MEM_alu_result),   
                              .i_write_data(i_MEM_write_data),    
                              .o_read_data(o_MEM_mem_data)    
    );
    
    // IF
    assign o_MEM_branch_zero = i_MEM_zero & i_MEM_branch;
    assign o_MEM_branch_addr = i_MEM_branch_addr;

    // WB
    assign o_MEM_alu_result =  i_MEM_alu_result;
    assign o_MEM_selected_reg = i_MEM_selected_reg; 
    assign o_MEM_reg_write = i_MEM_reg_write;
    assign o_MEM_mem_to_reg = i_MEM_mem_to_reg;

endmodule