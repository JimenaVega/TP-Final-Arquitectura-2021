`timescale 1ns / 1ps

module stall_unit #(
        parameter NB_DATA    = 32
    )    
    (   
        input                       i_reset,
        input                       i_ID_EX_mem_read, // Only load writes memory
        input       [NB_DATA-1 : 0] i_ID_EX_rt, // Load writing rt
        input       [NB_DATA-1 : 0] i_IF_ID_rt, // Next inst 
        input       [NB_DATA-1 : 0] i_IF_ID_rs, // Next inst
        output reg                  o_select_control_nop, // 0 -> i_control_signals 1 -> flush signals
        output reg                  o_enable_IF_ID_reg,   // 0 -> disable 1 -> enable
        output reg                  o_enable_pc          // 0 -> disable 1 -> enable
    );

    always@(*) begin
        if(i_reset)begin
            o_select_control_nop = 1'b0;
            o_enable_IF_ID_reg = 1'b1;
            o_enable_pc = 1'b1;
        end
        else begin
            if(!i_ID_EX_mem_read) begin
                o_select_control_nop = 1'b0;
                o_enable_IF_ID_reg = 1'b1;
                o_enable_pc = 1'b1;
            end
            else if((i_ID_EX_rt == i_IF_ID_rt) || (i_ID_EX_rt == i_IF_ID_rs)) begin
                o_select_control_nop = 1'b1; // flush signals
                o_enable_IF_ID_reg = 1'b0;   // disbale IF/ID pipeline register
                o_enable_pc = 1'b0;          // disable pc
            end
        end
    end
endmodule