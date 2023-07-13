`timescale 1ns / 1ps

module stall_unit #(
        parameter NB_DATA    = 32,
        parameter NB_REG     = 5
    )    
    (   
        input                 i_reset,
        input                 i_branch_taken,
        input                 i_ID_EX_mem_read,     // Only load writes memory
        input                 i_EX_jump,
        input                 i_MEM_jump,
        input  [NB_REG-1 : 0] i_ID_EX_rt,           // Load writing rt
        input  [NB_REG-1 : 0] i_IF_ID_rt,           // Next inst 
        input  [NB_REG-1 : 0] i_IF_ID_rs,           // Next inst
        output reg            o_select_control_nop, // 0 -> control_signals ID  1 -> flush signals
        output reg            o_enable_IF_ID_reg,   // 0 -> disable             1 -> enable
        output reg            o_enable_pc,          // 0 -> disable             1 -> enable
        output reg            o_flush_IF,           // 0 -> o_instruction       1 -> flush instruction en IF
        output reg            o_flush_EX            // 0 -> control signals EX  1 -> flush signals
    ); 

    always@(*) begin
        if(i_reset)begin
            o_enable_IF_ID_reg = 1'b1;
            o_enable_pc = 1'b1;

            o_select_control_nop = 1'b0;
            o_flush_IF = 1'b0;           // No hay flush en IF
            o_flush_EX = 1'b0;           // No hay flush en IE
        end
        else if(i_branch_taken) begin // control hazards
            // Flush signal flags
            o_flush_IF = 1'b1;
            o_flush_EX = 1'b1;
            o_select_control_nop = 1'b1; // ID

            // No hay stall
            o_enable_IF_ID_reg = 1'b1;
            o_enable_pc = 1'b1;
        end
        else if(i_EX_jump || i_MEM_jump) begin
            // Se flushean las señales de ID cuando se detecta el jump en
            // EX y en MEM, es decir, se borran las 2 instrucciones invalidas
            // que entran despues de los jumps
            o_flush_IF              = 1'b0;
            o_flush_EX              = 1'b0;
            o_select_control_nop    = 1'b1;

            // No hay stall
            o_enable_IF_ID_reg      = 1'b1;
            o_enable_pc             = 1'b1;
        end
        else begin                  // data hazards (LOAD)
            
            if(((i_ID_EX_rt == i_IF_ID_rt) || (i_ID_EX_rt == i_IF_ID_rs)) && i_ID_EX_mem_read) begin
                o_flush_IF = 1'b0;           // No hay flush en IF
                o_flush_EX = 1'b0;           // No hay flush en IE
                o_select_control_nop = 1'b1; // Flush signals in ID
                
                o_enable_IF_ID_reg = 1'b0;   // disbale IF/ID pipeline register
                o_enable_pc = 1'b0;          // disable pc

            end
            else  begin
                o_flush_IF = 1'b0;           // No hay flush en IF
                o_flush_EX = 1'b0;           // No hay flush en IE
                o_select_control_nop = 1'b0;

                o_enable_IF_ID_reg = 1'b1;
                o_enable_pc = 1'b1;
            end
        end
    end
endmodule