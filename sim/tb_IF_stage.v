`timescale 1ns / 1ps

module tb_IF_stage;

  // Parameters
  localparam  NB_PC_CONSTANT = 3;
  localparam  NB_PC          = 32;
  localparam  NB_INSTRUCTION = 32;
  localparam  NB_MEM_WIDTH   = 8;


  // Ports
  reg i_clock;
  reg i_IF_branch;
  reg i_IF_j_jal;
  reg i_IF_jr_jalr;
  reg i_IF_pc_enable;
  reg i_IF_pc_reset;
  reg i_IF_read_enable;
  reg i_IF_write_enable;                      // DEBUG_UNIT control 
  reg [NB_MEM_WIDTH-1:0] i_IF_write_data;   // DEBUG_UNIT control 
  reg [NB_PC-1:0] i_IF_branch_addr;
  reg [NB_PC-1:0] i_IF_jump_address;
  reg [NB_PC-1:0] i_IF_r31_data;
  wire [NB_PC-1:0] o_IF_adder_result;
  wire [NB_INSTRUCTION-1:0] o_IF_new_instruction;

  IF_stage 
  #(
    .NB_PC_CONSTANT(NB_PC_CONSTANT ),
    .NB_PC(NB_PC),
    .NB_INSTRUCTION(NB_INSTRUCTION )
  )
  IF_stage_1 (
    .i_clock (i_clock ),
    .i_IF_branch (i_IF_branch ),
    .i_IF_j_jal (i_IF_j_jal),
    .i_IF_jr_jalr(i_IF_jr_jalr),
    .i_IF_pc_enable (i_IF_pc_enable),
    .i_IF_pc_reset (i_IF_pc_reset ),
    .i_IF_read_enable (i_IF_read_enable ),
    .i_IF_write_enable(i_IF_write_enable),
    .i_IF_write_data(i_IF_write_data),
    .i_IF_branch_addr (i_IF_branch_addr ),
    .i_IF_jump_address (i_IF_jump_address ),
    .i_IF_r31_data(i_IF_r31_data),
    .o_IF_adder_result (o_IF_adder_result ),
    .o_IF_new_instruction  ( o_IF_new_instruction)
  );

  initial begin
    begin
      i_clock           = 0;
      i_IF_pc_reset     = 1'b1;
      i_IF_branch       = 1'b0;
      i_IF_j_jal        = 1'b0;
      i_IF_jr_jalr      = 1'b0;
      i_IF_write_enable = 1'b0;
      i_IF_write_data   = {NB_MEM_WIDTH{1'b0}}; // DEBUG UNIT
      i_IF_branch_addr  = 32'h4;
      i_IF_jump_address = 32'h3;
      i_IF_r31_data     = 32'h2;
      
      #40
      i_IF_read_enable = 1'b1;
      // PC + 1
      #40
      i_IF_pc_reset = 1'b0;
      i_IF_pc_enable = 1'b1;
      // branch address
      #40
      i_IF_branch = 1'b1;
      
      // j/jal address
      #40
      i_IF_j_jal = 1'b1;

      // jr/jalrl address
      #40
      i_IF_jr_jalr = 1'b1;

      #1000

      $finish;
    end
  end

  always
    #5  i_clock = ! i_clock ;

endmodule
