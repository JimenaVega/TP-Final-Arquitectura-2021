`timescale 1ns / 1ps

module tb_TOP;

  // Parameters
  localparam  NB_PC = 32;
  localparam  NB_INSTRUCTION = 32;
  localparam  NB_DATA = 32;
  localparam  NB_REG = 5;
  localparam  NB_ADDR = 32;
  localparam  NB_OPCODE = 6;

  // Ports
  reg i_clock;
  reg i_pc_enable;
  reg i_pc_reset;
  reg i_read_enable;
  reg i_ID_stage_reset;
  reg i_control_unit_enable;

  TOP 
  #(.NB_PC(NB_PC),
    .NB_INSTRUCTION(NB_INSTRUCTION),
    .NB_DATA(NB_DATA),
    .NB_REG(NB_REG),
    .NB_ADDR(NB_ADDR),
    .NB_OPCODE(NB_OPCODE))
  TOP_1 (.i_clock(i_clock),
         .i_pc_enable(i_pc_enable),
         .i_pc_reset(i_pc_reset),
         .i_read_enable( i_read_enable),
         .i_ID_stage_reset(i_ID_stage_reset),
         .i_control_unit_enable(i_control_unit_enable));

  initial begin
    begin
      i_clock               = 1'b0;
      i_pc_enable           = 1'b0;
      i_read_enable         = 1'b0;
      i_pc_reset            = 1'b1;
      i_ID_stage_reset      = 1'b1;
      i_control_unit_enable = 1'b0;
      
      #20
      i_pc_enable           = 1'b1;
      i_read_enable         = 1'b1;
      i_pc_reset            = 1'b0;
      i_ID_stage_reset      = 1'b0;
      i_control_unit_enable = 1'b1;
      
      #500
      $finish;
    end
  end

  always
    #5  i_clock = ! i_clock ;

endmodule