`timescale 1ns / 1ps

module ID_EX_reg#(
        parameter NB_ALU_OP   = 3,
        parameter NB_IMM      = 32,
        parameter NB_PC       = 32,
        parameter NB_DATA     = 32,
        parameter NB_REG      = 5
    )
    (
        input                    i_clock,
        input                    ID_reg_write,
        input                    ID_mem_to_reg,
        input                    ID_mem_read,
        input                    ID_mem_write,
        input                    ID_branch,
        input                    ID_alu_src,
        input                    ID_reg_dest,
        input  [NB_ALU_OP-1:0]   ID_alu_op,
        input  [NB_PC-1:0]       ID_pc,
        input  [NB_DATA-1:0]     ID_data_a,
        input  [NB_DATA-1:0]     ID_data_b,
        input  [NB_IMM-1:0]      ID_immediate,
        input  [NB_REG-1:0]      ID_rt,
        input  [NB_REG-1:0]      ID_rd,
        
        output                   EX_reg_write,
        output                   EX_mem_to_reg,
        output                   EX_mem_read,
        output                   EX_mem_write,
        output                   EX_branch,
        output                   EX_alu_src,
        output                   EX_reg_dest,
        output [NB_ALU_OP-1:0]   EX_alu_op,
        output [NB_PC-1:0]       EX_pc,
        output [NB_DATA-1:0]     EX_data_a,
        output [NB_DATA-1:0]     EX_data_b,
        output [NB_IMM-1:0]      EX_immediate,
        output [NB_REG-1:0]      EX_rt,
        output [NB_REG-1:0]      EX_rd
    );
    
    reg                 reg_write;
    reg                 mem_to_reg;
    reg                 mem_read;
    reg                 mem_write;
    reg                 branch;
    reg                 alu_src;
    reg                 reg_dest;
    reg [NB_ALU_OP-1:0] alu_op;
    reg [NB_PC-1:0]     pc;
    reg [NB_DATA-1:0]   data_a;
    reg [NB_DATA-1:0]   data_b;
    reg [NB_IMM-1:0]    immediate;
    reg [NB_REG-1:0]    rt;
    reg [NB_REG-1:0]    rd;

    always @(posedge i_clock) begin
        reg_write   <= ID_reg_write;
        mem_to_reg  <= ID_mem_to_reg;
        mem_read    <= ID_mem_read;
        mem_write   <= ID_mem_write;
        branch      <= ID_branch;
        alu_src     <= ID_alu_src;
        reg_dest     <= ID_reg_dest;
        alu_op      <= ID_alu_op;
        pc          <= ID_pc;
        data_a      <= ID_data_a;
        data_b      <= ID_data_b;
        immediate   <= ID_immediate;
        rt          <= ID_rt;
        rd          <= ID_rd;
    end

    assign EX_reg_write  = reg_write;
    assign EX_mem_to_reg = mem_to_reg;
    assign EX_mem_read   = mem_read;
    assign EX_mem_write  = mem_write;
    assign EX_branch     = branch;
    assign EX_alu_src    = alu_src;
    assign EX_reg_dest    = reg_dest;
    assign EX_alu_op     = alu_op;
    assign EX_pc         = pc;
    assign EX_data_a     = data_a;
    assign EX_data_b     = data_b;
    assign EX_immediate  = immediate;
    assign EX_rt         = rt;
    assign EX_rd         = rd;
    
endmodule
