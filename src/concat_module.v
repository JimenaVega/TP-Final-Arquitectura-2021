`timescale 1ns / 1ps

module concat_module#(
    parameter NB_ADDR       = 26,    // Jump address in J type instructions          
    parameter NB_PC         = 32,            
    parameter NB_UPPER_PC   = 4,     // Number of bits of upper PC+1
    parameter NB_LOWER_BITS = 2
  ) 
  ( 
    input i_clock,
    input [NB_ADDR-1:0]     i_inst,                           
    input [NB_UPPER_PC-1:0] i_next_pc,   // PC+1[31:28]                
    output reg [NB_PC-1:0]  o_jump_addr         
  );

    // always@(i_inst, i_next_pc) begin
    always@(posedge i_clock) begin  
        o_jump_addr[NB_LOWER_BITS-1:0] <= 2'b00; // [1:0]
        o_jump_addr[NB_ADDR+1:NB_LOWER_BITS] <= i_inst; // [27:2]
        o_jump_addr[NB_PC-1:NB_ADDR+2] <= i_next_pc; // [31:28]
    end
endmodule