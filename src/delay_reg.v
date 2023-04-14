`timescale 1ns / 1ps

module delay_reg#(
        parameter NB_INST           = 32
    )
    (
        input [NB_INST-1:0]     i_inst,
        
        output [NB_INST-1:0]    o_delayed_inst
    );
    
    reg [NB_INST-1:0] inst;

    always @(posedge i_clock) begin
        inst    <= i_inst;
    end

    assign o_delayed_inst = inst;
    
endmodule
