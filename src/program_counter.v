`timescale 1ns / 1ps

module program_counter#(
        parameter NB = 32
    )    
    (
        input               i_enable,   // from PC
        input               i_clock,
        input               i_reset,
        input   [NB-1:0]    i_mux_pc,
        input               i_enable_pc, // from STALL UNIT 1 - > normal 0 - > stall pc
        
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
            
            if(!i_enable_pc)begin
                pc <= pc;
            end
            else begin
                pc <= i_mux_pc;
            end
        end
        else begin
            pc <= pc;
        end
       
endmodule