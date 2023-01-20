`timescale 1ns / 1ps

module registers_bank#(
        parameter   NB_DATA     =   32,
        parameter   NB_ADDR     =   5,
        parameter   BANK_DEPTH  =   32
    )
    (
        input               i_clock,
        input               i_reset,
        input               i_reg_write,
        input [NB_ADDR-1:0] i_read_reg_a,
        input [NB_ADDR-1:0] i_read_reg_b,
        input [NB_ADDR-1:0] i_write_reg,
        input [NB_DATA-1:0] i_write_data,
              
        output [NB_DATA-1:0] o_data_a,
        output [NB_DATA-1:0] o_data_b 
    );
    
    reg [NB_DATA-1:0] o_data_a_next;
    reg [NB_DATA-1:0] o_data_b_next;
    
    reg [NB_DATA-1:0]  registers [BANK_DEPTH-1:0];
    
    always@(posedge i_clock)begin
        if(i_reset)begin:reset
            integer reg_index;
            
            for (reg_index = 0; reg_index < BANK_DEPTH; reg_index = reg_index + 1)
              registers[reg_index] = {NB_DATA{1'b0}};
              
            o_data_a_next  =  {NB_DATA{1'b0}};
            o_data_b_next  =  {NB_DATA{1'b0}};
        end 
        else begin
            o_data_a_next <= registers[i_read_reg_a];
            o_data_b_next <= registers[i_read_reg_b];
            
            if(i_reg_write)
                registers[i_write_reg] <= i_write_data;
        end
    end
    
    assign o_data_a = o_data_a_next;
    assign o_data_b = o_data_b_next;
    
endmodule