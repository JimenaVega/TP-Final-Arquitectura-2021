`timescale 1ns / 1ps

module IF_ID_reg#(
        parameter NB_PC             = 32,
        parameter NB_INSTRUCTION    = 32
    )
    (
        input                       i_clock,
        input                       i_reset,
        input                       i_pipeline_enable,  // DEBUG UNIT
        input                       i_enable_IF_ID_reg, // STALL UNIT: 1 -> data hazard (stall) 0 -> !data_hazard
        input                       i_flush,            // STALL UNIT: 1 -> control hazards     0 -> !control_hazard
        input [NB_PC-1:0]           IF_adder_result,
        input [NB_INSTRUCTION-1:0]  IF_new_instruction,
        
        output [NB_PC-1:0]          ID_adder_result,
        output [NB_INSTRUCTION-1:0] ID_new_instruction
    );
    
    reg [NB_PC-1:0]             adder_result;
    reg [NB_INSTRUCTION-1:0]    new_instruction;

    always @(negedge i_clock) begin
        if(i_reset)begin
            adder_result    <= {32{1'b0}};
            new_instruction <= {32{1'b0}};;
        end
        else begin
            if(i_pipeline_enable) begin
                if(i_enable_IF_ID_reg) begin
                    if(i_flush) begin
                        adder_result    <= IF_adder_result;
                        new_instruction <= {32{1'b0}};
                    end
                    else begin
                        adder_result    <= IF_adder_result;
                        new_instruction <= IF_new_instruction;
                    end
                end
                else begin
                    adder_result    <= adder_result;
                    new_instruction <= new_instruction;
                end
            end
            else begin
                adder_result    <= adder_result;
                new_instruction <= new_instruction;
            end
        end    
    end

    assign ID_adder_result      = adder_result;
    assign ID_new_instruction   = new_instruction;
    
endmodule
