`timescale 1ns / 1ps

module concat_module#(
    parameter NB_ADDR = 25,    // Jump address in J type instructions          
    parameter NB_PC = 32,            
    parameter NB_UPPER_PC = 4, // Number of bits of upper PC+1
    parameter NB_LOWER_BITS = 2,
  ) 
  (
    input i_inst[NB_ADDR-1:0],                           
    input i_next_pc[NB_UPPER_PC-1:0],   // PC+1[31:28]                
    output reg [NB_PC-1:0] o_jump_addr         
  );

    always@(i_inst, i_next_pc) begin
        o_jump_addr[NB_LOWER_BITS-1:0] = 2'b00;
        o_jump_addr[NB_ADDR+2:NB_LOWER_BITS] = i_inst;
        o_jump_addr[NB_PC-1:NB_ADDR+1] = i_next_pc;
    end
endmodule