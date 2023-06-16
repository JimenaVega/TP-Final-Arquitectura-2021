`timescale 1ns / 1ps

module MEM_stage#(
        parameter NB_ADDR       = 32,
        parameter NB_DATA       = 32,
        parameter NB_PC         = 32,
        parameter NB_DM_ADDR    = 5,
        parameter MEMORY_WIDTH  = 32,
        parameter NB_REG        = 5
    )
    (
        input                   i_clock,
        input                   i_MEM_du_flag,          // Debug Unit
        input                   i_MEM_signed,
        input                   i_MEM_dm_enable,        // Debug Unit
        input                   i_MEM_dm_read_enable,   // Debug Unit
        input [NB_DM_ADDR-1:0]  i_MEM_dm_read_address,  // Debug Unit
        input                   i_MEM_reg_write,        // WB stage flag
        input                   i_MEM_mem_to_reg,       // WB stage flag
        input                   i_MEM_mem_read,         // read data memory flag
        input                   i_MEM_mem_write,        // write data memory flag
        input                   i_MEM_word_en,
        input                   i_MEM_halfword_en,
        input                   i_MEM_byte_en,
        input                   i_MEM_branch,           // branch 
        input                   i_MEM_zero,             // zero flag 
        input [NB_PC-1:0]       i_MEM_branch_addr,  
        input [NB_ADDR-1:0]     i_MEM_alu_result,       // write and read address in data memory
        input [NB_DATA-1:0]     i_MEM_write_data,       // data to write in data memory - data B in EX
        input [NB_REG-1:0]      i_MEM_selected_reg,     // WB register (rd or rt)
        input                   i_MEM_r31_ctrl,
        input [NB_PC-1:0]       i_MEM_pc,
        input                   i_MEM_hlt,

        output [NB_DATA-1:0]        o_MEM_mem_data,
        output [NB_REG-1:0]         o_MEM_selected_reg,     // WB register (rd or rt)
        output [NB_ADDR-1:0]        o_MEM_alu_result,       // only for R type and stores (never loads)
        output [NB_PC-1:0]          o_MEM_branch_addr,      // PC = o_MEM_branch_addr
        output                      o_MEM_branch_zero,      // IF mux selector
        output                      o_MEM_reg_write,        // WB stage flag
        output                      o_MEM_mem_to_reg,       // WB stage flag
        output                      o_MEM_r31_ctrl,
        output [NB_PC-1:0]          o_MEM_pc,
        output [MEMORY_WIDTH-1:0]   o_MEM_byte_data,
        output                      o_MEM_hlt);

    wire [NB_DATA-1:0]      write_data;
    wire [NB_DATA-1:0]      read_data;

    reg [NB_DM_ADDR-1:0]   address;
    reg                    mem_read;

    always@(*)begin
        if(i_MEM_du_flag)begin  // Flag de read y address provenientes de DU
            mem_read <= i_MEM_dm_read_enable;
            address  <= i_MEM_dm_read_address;
        end
        else begin              // Flag de read y address provenientes del datapath
            mem_read <= i_MEM_mem_read;
            address  <= i_MEM_alu_result[NB_DM_ADDR-1:0];
        end
    end

    data_mem_controller data_mem_controller_1(.i_signed(i_MEM_signed),
                                              .i_mem_write(mem_write),
                                              .i_mem_read(mem_read),
                                              .i_word_en(i_MEM_word_en),
                                              .i_halfword_en(i_MEM_halfword_en),
                                              .i_byte_en(i_MEM_byte_en),
                                              .i_write_data(i_MEM_write_data),
                                              .i_read_data(read_data),
                                              .o_write_data(write_data),
                                              .o_read_data(o_MEM_mem_data));

    data_memory data_memory_1(.i_clock(i_clock),
                              .i_enable(i_MEM_dm_enable),
                              .i_mem_write(mem_write),
                              .i_mem_read(mem_read),
                              .i_address(address),
                              .i_write_data(write_data),
                              .o_read_data(read_data));
    
    // IF
    assign o_MEM_branch_zero = i_MEM_zero & i_MEM_branch;
    assign o_MEM_branch_addr = i_MEM_branch_addr;

    // WB
    assign o_MEM_alu_result     = i_MEM_alu_result;
    assign o_MEM_selected_reg   = i_MEM_selected_reg; 
    assign o_MEM_reg_write      = i_MEM_reg_write;
    assign o_MEM_mem_to_reg     = i_MEM_mem_to_reg;
    assign o_MEM_r31_ctrl       = i_MEM_r31_ctrl;
    assign o_MEM_pc             = i_MEM_pc;
    assign o_MEM_hlt            = i_MEM_hlt;

endmodule