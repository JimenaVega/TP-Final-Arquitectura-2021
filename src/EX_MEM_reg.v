`timescale 1ns / 1ps

module EX_MEM_reg#(
        parameter NB_PC       = 32,
        parameter NB_REG      = 5
    )
    (
        input                   i_clock,
        input                   EX_reg_write,
        input                   EX_mem_to_reg,
        input                   EX_mem_read,
        input                   EX_mem_write,
        input                   EX_branch,
        input [NB_PC-1:0]       EX_branch_addr,
        input                   EX_zero,
        input [NB_PC-1:0]       EX_alu_result,
        input [NB_PC-1:0]       EX_data_a,
        input [NB_REG-1:0]      EX_selected_reg,
        input                   EX_byte_en,
        input                   EX_halfword_en,
        input                   EX_word_en,
        input                   EX_r31_ctrl,
        input [NB_PC-1:0]       EX_pc,
        
        output                  MEM_reg_write,
        output                  MEM_mem_to_reg,
        output                  MEM_mem_read,
        output                  MEM_mem_write,
        output                  MEM_branch,
        output [NB_PC-1:0]      MEM_branch_addr,
        output                  MEM_zero,
        output [NB_PC-1:0]      MEM_alu_result,
        output [NB_PC-1:0]      MEM_data_a,
        output [NB_REG-1:0]     MEM_selected_reg,
        output                  MEM_byte_en,
        output                  MEM_halfword_en,
        output                  MEM_word_en,
        output                  MEM_r31_ctrl,
        output [NB_PC-1:0]      MEM_pc
    );
    
    reg                 reg_write;
    reg                 mem_to_reg;
    reg                 mem_read;
    reg                 mem_write;
    reg                 branch;
    reg [NB_PC-1:0]     branch_addr;
    reg                 zero;
    reg [NB_PC-1:0]     alu_result;
    reg [NB_PC-1:0]     data_a;
    reg [NB_REG-1:0]    selected_reg;
    reg                 byte_en;
    reg                 halfword_en;
    reg                 word_en;
    reg                 r31_ctrl;
    reg [NB_PC-1:0]     pc;  

    always @(negedge i_clock) begin
        reg_write       <= EX_reg_write;
        mem_to_reg      <= EX_mem_to_reg;
        mem_read        <= EX_mem_read;
        mem_write       <= EX_mem_write;
        branch          <= EX_branch;
        branch_addr     <= EX_branch_addr;
        zero            <= EX_zero;
        alu_result      <= EX_alu_result;
        data_a          <= EX_data_a;
        selected_reg    <= EX_selected_reg;
        byte_en         <= EX_byte_en;
        halfword_en     <= EX_halfword_en;
        word_en         <= EX_word_en;
        r31_ctrl        <= EX_r31_ctrl;
        pc              <= EX_pc;
    end

    assign MEM_reg_write    = reg_write;
    assign MEM_mem_to_reg   = mem_to_reg;
    assign MEM_mem_read     = mem_read;
    assign MEM_mem_write    = mem_write;
    assign MEM_branch       = branch;
    assign MEM_branch_addr  = branch_addr;
    assign MEM_zero         = zero;
    assign MEM_alu_result   = alu_result;
    assign MEM_data_a       = data_a;
    assign MEM_selected_reg = selected_reg;
    assign MEM_byte_en      = byte_en;
    assign MEM_halfword_en  = halfword_en;
    assign MEM_word_en      = word_en;
    assign MEM_r31_ctrl     = r31_ctrl;
    assign MEM_pc           = pc;
    
endmodule
