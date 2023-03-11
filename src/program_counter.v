`timescale 1ns / 1ps

module program_counter#(
        parameter NB = 32
    )    
    (
        input               i_enable,
        input               i_clock,
        input               i_reset,
        input   [NB-1:0]    i_mux_pc,
        
        output  [NB-1:0]    o_pc_mem
    );
    
    reg     [NB-1:0] pc;
    
    assign o_pc_mem = pc;
    
    initial begin
        pc = {NB{1'b0}};
    end
    
    always@(posedge i_clock)
        if(i_reset) begin
            pc <= {NB{1'b0}};
        end
        else if(i_enable) begin
            pc <= i_mux_pc;
        end
        else begin
            pc <= pc;
        end
       
endmodule