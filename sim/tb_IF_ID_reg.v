`timescale 1ns / 1ps

module IF_ID_reg_tb;

  // Parameters
  localparam  NB_PC = 32;
  localparam  NB_INSTRUCTION = 32;

  // Ports
  reg i_clock = 0;
  reg [NB_PC-1:0] IF_adder_result;
  reg [NB_INSTRUCTION-1:0] IF_new_instruction;
  wire [NB_PC-1:0] ID_adder_result;
  wire [NB_INSTRUCTION-1:0] ID_new_instruction;

  IF_ID_reg 
  #(
    .NB_PC(NB_PC ),
    .NB_INSTRUCTION (
        NB_INSTRUCTION )
  )
  IF_ID_reg_dut (
    .i_clock (i_clock ),
    .IF_adder_result (IF_adder_result ),
    .IF_new_instruction (IF_new_instruction ),
    .ID_adder_result (ID_adder_result ),
    .ID_new_instruction  ( ID_new_instruction)
  );

  initial begin
    begin
      $finish;
    end
  end

  always
    #5  i_clock = ! i_clock ;

endmodule
