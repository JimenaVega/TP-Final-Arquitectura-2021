`timescale 1ns / 1ps

module tb_data_path;

  // Parameters
  localparam  NB_PC = 32;
  localparam  NB_INSTRUCTION = 32;
  localparam  NB_DATA = 32;
  localparam  NB_REG = 5;
  localparam  NB_ADDR = 32;
  localparam  NB_DM_ADDR = 7;
  localparam  NB_OPCODE = 6;
  localparam  NB_MEM_WIDTH = 8;

  // Ports
  reg i_clock;
  reg i_clock_reset;
  reg i_pc_enable;
  reg i_pc_reset;
  reg i_read_enable;
  reg i_ID_stage_reset;
  reg i_ctrl_reset;

  reg 						i_im_enable;         // Debug Unit
  reg 						i_im_write_enable;   // Debug Unit
  reg [NB_MEM_WIDTH-1:0] 	i_im_data;           // Debug Unit
  reg [NB_ADDR-1:0]			i_im_address;        // Debug Unit
  reg 						i_rb_enable;         // Debug Unit
  reg 						i_rb_read_enable;    // Debug Unit
  reg [NB_REG-1:0]			i_rb_address;        // Debug Unit
  reg 						i_dm_enable;         // Debug Unit
  reg 						i_dm_read_enable;    // Debug Unit
  reg [NB_DM_ADDR-1:0]		i_dm_read_address;   // Debug Unit
  reg 						i_cu_enable;         // Debug Unit

  wire [NB_PC-1:0]			o_pc_value;          // Debug Unit
  wire [NB_DATA-1:0]		o_rb_data;           // Debug Unit
  wire [NB_MEM_WIDTH-1:0]	o_dm_data;           // Debug Unit
  wire 						o_hlt;               // Debug Unit

  data_path 
  #(.NB_PC(NB_PC),
    .NB_INSTRUCTION(NB_INSTRUCTION),
    .NB_DATA(NB_DATA),
    .NB_REG(NB_REG),
    .NB_ADDR(NB_ADDR),
    .NB_DM_ADDR(NB_DM_ADDR),
    .NB_OPCODE(NB_OPCODE),
    .NB_MEM_WIDTH(NB_MEM_WIDTH) // Todas las memorias, excepto bank register tienen WIDTH = 8
)
  data_path_1 (.i_clock(i_clock),
         .i_clock_reset(i_clock_reset),
         .i_pc_enable(i_pc_enable),
         .i_pc_reset(i_pc_reset),
         .i_ctrl_reset(i_ctrl_reset),
         .i_read_enable( i_read_enable),
         .i_ID_stage_reset(i_ID_stage_reset),
         .i_im_enable(i_im_enable),             // Debug Unit
         .i_im_write_enable(i_im_write_enable), // Debug Unit
         .i_im_data(i_im_data),                 // Debug Unit
         .i_im_address(i_im_address),           // Debug Unit
         .i_rb_enable(i_rb_enable),             // Debug Unit
         .i_rb_read_enable(i_rb_read_enable),   // Debug Unit
         .i_rb_address(i_rb_address),           // Debug Unit
         .i_dm_enable(i_dm_enable),             // Debug Unit
         .i_dm_read_enable(i_dm_read_enable),   // Debug Unit
         .i_dm_read_address(i_dm_read_address), // Debug Unit
         .i_cu_enable(i_cu_enable),             // Debug Unit
         .o_pc_value(o_pc_value),               // Debug Unit
         .o_rb_data(o_rb_data),                 // Debug Unit
         .o_dm_data(o_dm_data),                 // Debug Unit
         .o_hlt(o_hlt));                        // Debug Unit

  initial begin
    i_clock 			= 1'b0;
    i_clock_reset 		= 1'b0;
    i_pc_enable 		= 1'b0;
    i_pc_reset 			= 1'b1;
    i_ctrl_reset        = 1'b1;
    i_read_enable 		= 1'b0;
    i_ID_stage_reset 	= 1'b1;

    i_im_enable 		= 1'b0;
    i_im_write_enable 	= 1'b0;
    i_im_data 			= 8'd0;
    i_im_address 		= 32'd0;

    i_rb_enable 		= 1'b0;
    i_rb_read_enable 	= 1'b0;
    i_rb_address 		= 5'd0;

    i_dm_enable 		= 1'b0;
    i_dm_read_enable 	= 1'b0;
    i_dm_read_address 	= 7'd0;

    i_cu_enable = 0;

	#20
	i_pc_enable         = 1'b1;
	i_ctrl_reset        = 1'b0;
	i_pc_reset          = 1'b0;
	i_ID_stage_reset    = 1'b0;
	i_read_enable       = 1'b1;

	i_im_enable 		= 1'b1;
	i_rb_enable 		= 1'b1;
	i_dm_enable 		= 1'b1;
	i_cu_enable 		= 1'b1;
      
	#700
	$finish;
  end

  always
    #5  i_clock = ! i_clock ;

endmodule
