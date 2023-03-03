`timescale 1ns / 1ps

module EX_MEM_reg#(
        parameter NB_PC       = 32,
        parameter NB_REG      = 5
    )
    (
        input                    i_clock,
        input                  EX_reg_write,
        input                  EX_mem_to_reg,
        input                  EX_mem_read,
        input                  EX_mem_write,
        input                  EX_branch,
        input [NB_PC-1:0]      EX_branch_address,
        input                  EX_zero,
        input                  EX_alu_result,
        input                  EX_data_a,
        input [NB_REG-1:0]     EX_selected_reg,
        
        output                  MEM_reg_write,
        output                  MEM_mem_to_reg,
        output                  MEM_mem_read,
        output                  MEM_mem_write,
        output                  MEM_branch,
        output [NB_PC-1:0]      MEM_branch_address,
        output                  MEM_zero,
        output                  MEM_alu_result,
        output                  MEM_data_a,
        output [NB_REG-1:0]     MEM_selected_reg
    );
    
    reg                  reg_write;
    reg                  mem_to_reg;
    reg                  mem_read;
    reg                  mem_write;
    reg                  branch;
    reg [NB_PC-1:0]      branch_address;
    reg                  zero;
    reg                  alu_result;
    reg                  data_a;
    reg [NB_REG-1:0]     selected_reg;

    always @(posedge i_clock) begin
        reg_write       <= EX_reg_write;
        mem_to_reg      <= EX_mem_to_reg;
        mem_read        <= EX_mem_read;
        mem_write       <= EX_mem_write;
        branch          <= EX_branch;
        branch_address  <= EX_branch_address;
        zero            <= EX_zero;
        alu_result      <= EX_alu_result;
        data_a          <= EX_data_a;
        selected_reg    <= EX_selected_reg;
    end

    assign MEM_reg_write      = reg_write;
    assign MEM_mem_to_reg     = mem_to_reg;
    assign MEM_mem_read       = mem_read;
    assign MEM_mem_write      = mem_write;
    assign MEM_branch         = branch;
    assign MEM_branch_address = branch_address;
    assign MEM_zero           = zero;
    assign MEM_alu_result     = alu_result;
    assign MEM_data_a         = data_a;
    assign MEM_selected_reg   = selected_reg;
    
endmodule
