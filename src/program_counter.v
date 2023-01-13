`timescale 1ns / 1ps

module program_counter#(
        parameter    N_BITS = 32
    )    
    (
        input                       i_enable    ,
        input                       i_clock     ,
        input                       i_reset     ,
        input   [N_BITS - 1 : 0]    i_mux_pc    ,
        
        output  [N_BITS - 1 : 0]    o_pc_mem
    );
    
    reg     [N_BITS - 1 : 0]    pc;
    
    assign o_pc_mem = pc;
    
    always@(posedge i_clock)
        if(i_reset) begin
            pc <= 0;
        end
        else if(i_enable) begin
            pc <= i_mux_pc;
        end
        else begin
            pc <= pc;
        end
       
endmodule