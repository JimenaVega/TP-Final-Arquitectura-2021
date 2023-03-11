module tb_IF_stage;

  // Parameters
  localparam  NB_PC_CONSTANT = 3;
  localparam  NB_PC = 32;
  localparam  NB_INSTRUCTION = 32;

  // Ports
  reg i_clock = 0;
  reg i_IF_branch = 0;
  reg i_IF_jump = 0;
  reg i_IF_pc_enable = 0;
  reg i_IF_pc_reset = 0;
  reg i_IF_read_enable = 0;
  reg [NB_PC-1:0] i_IF_branch_address;
  reg [NB_PC-1:0] i_IF_jump_address;
  wire [NB_PC-1:0] o_IF_adder_result;
  wire [NB_INSTRUCTION-1:0] o_IF_new_instruction;

  IF_stage 
  #(
    .NB_PC_CONSTANT(NB_PC_CONSTANT ),
    .NB_PC(NB_PC ),
    .NB_INSTRUCTION (
        NB_INSTRUCTION )
  )
  IF_stage_1 (
    .i_clock (i_clock ),
    .i_IF_branch (i_IF_branch ),
    .i_IF_jump (i_IF_jump ),
    .i_IF_pc_enable (i_IF_pc_enable ),
    .i_IF_pc_reset (i_IF_pc_reset ),
    .i_IF_read_enable (i_IF_read_enable ),
    .i_IF_branch_address (i_IF_branch_address ),
    .i_IF_jump_address (i_IF_jump_address ),
    .o_IF_adder_result (o_IF_adder_result ),
    .o_IF_new_instruction  ( o_IF_new_instruction)
  );

  initial begin
    begin
      i_IF_pc_reset = 1'b1;
      
      #40
      
      i_IF_read_enable = 1'b1;

      #40
      
      i_IF_pc_reset = 1'b0;
      i_IF_pc_enable = 1'b1;

      #1000

      $finish;
    end
  end

  always
    #5  i_clock = ! i_clock ;

endmodule
