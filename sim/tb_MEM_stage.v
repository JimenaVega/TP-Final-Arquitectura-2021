module tb_MEM_stage;

  // Parameters
  localparam  NB_ADDR = 32;
  localparam  NB_DATA = 32;
  localparam  NB_PC = 32;
  localparam  NB_REG = 5;

  // Ports
  reg clock = 0;
  reg i_reset = 0;
  reg i_MEM_reg_write = 0;
  reg i_MEM_mem_to_reg = 0;
  reg i_MEM_mem_read = 0;
  reg i_MEM_mem_write = 0;
  reg i_MEM_branch = 0;
  reg i_MEM_zero = 0;
  reg [NB_PC-1:0] i_MEM_branch_addr;
  reg [NB_ADDR-1:0] i_MEM_alu_result;
  reg [NB_DATA-1:0] i_MEM_write_data;
  reg [NB_REG-1:0] i_MEM_selected_reg;
  wire [NB_DATA-1:0] o_MEM_mem_data;
  wire [NB_REG-1:0] o_MEM_selected_reg;
  wire [NB_ADDR-1:0] o_MEM_alu_result;
  wire [NB_PC-1:0] o_MEM_branch_address;
  wire o_branch_zero;
  wire o_MEM_reg_write;
  wire o_MEM_mem_to_reg;

  MEM_stage 
  #(
    .NB_ADDR(NB_ADDR),
    .NB_DATA(NB_DATA),
    .NB_PC(NB_PC),
    .NB_REG (NB_REG)
  )
  MEM_stage_dut (
    .i_clock (clock ),
    .i_reset (i_reset ),
    .i_MEM_reg_write (i_MEM_reg_write ),
    .i_MEM_mem_to_reg (i_MEM_mem_to_reg ),
    .i_MEM_mem_read (i_MEM_mem_read ),
    .i_MEM_mem_write (i_MEM_mem_write ),
    .i_MEM_branch (i_MEM_branch ),
    .i_MEM_zero (i_MEM_zero ),
    .i_MEM_branch_addr (i_MEM_branch_addr ),
    .i_MEM_alu_result (i_MEM_alu_result ),
    .i_MEM_write_data (i_MEM_write_data ),
    .i_MEM_selected_reg (i_MEM_selected_reg ),
    .o_MEM_mem_data (o_MEM_mem_data ),
    .o_MEM_selected_reg (o_MEM_selected_reg ),
    .o_MEM_alu_result (o_MEM_alu_result ),
    .o_MEM_branch_address (o_MEM_branch_address ),
    .o_branch_zero (o_branch_zero ),
    .o_MEM_reg_write (o_MEM_reg_write ),
    .o_MEM_mem_to_reg (o_MEM_mem_to_reg ),
  );

  initial begin
    i_clock = 0;
    i_reset = 0;
    i_MEM_reg_write = 1'b0;
    i_MEM_mem_to_reg  = 1'b0;
    i_mem_read_flag = 1'b0;
    i_MEM_mem_write = 1'b0;
    i_MEM_branch = 1'b0;
    i_MEM_zero = 1'b0;

    #40
    i_MEM_branch = 1'b0;
    i_MEM_zero = 1'b1;
    i_MEM_branch_addr = 32'hf;
    $display("[$display]time=%0t ->  i_MEM_branch=%b, i_MEM_zero=%b, i_MEM_branch_addr=%b, o_branch_zero=%b, o_MEM_branch_address=%b",
                         $time, i_MEM_branch, i_MEM_zero, i_MEM_branch_addr, o_branch_zero, o_MEM_branch_address);
    $strobe("[$strobe]time=%0t ->  i_MEM_branch=%b, i_MEM_zero=%b, i_MEM_branch_addr=%b, o_branch_zero=%b, o_MEM_branch_address=%b",
                         $time, i_MEM_branch, i_MEM_zero, i_MEM_branch_addr, o_branch_zero, o_MEM_branch_address);
    #40
    i_MEM_branch = 1'b1;
    i_MEM_zero = 1'b1;
    i_MEM_branch_addr = 32'hf;
    $display("[$display]time=%0t ->  i_MEM_branch=%b, i_MEM_zero=%b, i_MEM_branch_addr=%b, o_branch_zero=%b, o_MEM_branch_address=%b",
                         $time, i_MEM_branch, i_MEM_zero, i_MEM_branch_addr, o_branch_zero, o_MEM_branch_address);
    $strobe("[$strobe]time=%0t ->  i_MEM_branch=%b, i_MEM_zero=%b, i_MEM_branch_addr=%b, o_branch_zero=%b, o_MEM_branch_address=%b",
                         $time, i_MEM_branch, i_MEM_zero, i_MEM_branch_addr, o_branch_zero, o_MEM_branch_address);
    #40
    $display("Testing WRITING memory data");
    i_MEM_alu_result = 32'h4; // Address 4
    i_MEM_mem_write = 1'b1;   // flag de escritura
    i_write_data = 32'bf0f0;  // Data que se escribe
    
    $display("[$display]time=%0t -> i_MEM_alu_result=%b, i_MEM_mem_write=%b, i_write_data=%b, o_MEM_mem_data=%b, o_MEM_alu_result=%b",
                         $time, i_MEM_alu_result, i_MEM_mem_write, i_write_data, o_MEM_mem_data, o_MEM_alu_result);
    $strobe("[$strobe]time=%0t -> i_MEM_alu_result=%b, i_MEM_mem_write=%b, i_write_data=%b, o_MEM_mem_data=%b, o_MEM_alu_result=%b",
                         $time, i_MEM_alu_result, i_MEM_mem_write, i_write_data, o_MEM_mem_data, o_MEM_alu_result);                     

    $40
    $display("Testing READING memory data");
    i_MEM_alu_result = 32'h4; // Address 4
    i_MEM_mem_write = 1'b0;
    i_mem_read_flag = 1'b1; 
    $display("[$display]time=%0t -> i_MEM_alu_result=%b, i_MEM_mem_write=%b, i_write_data=%b, o_MEM_mem_data=%b, o_MEM_alu_result=%b",
                        $time, i_MEM_alu_result, i_MEM_mem_write, i_write_data, o_MEM_mem_data, o_MEM_alu_result);
    $strobe("[$strobe]time=%0t -> i_MEM_alu_result=%b, i_MEM_mem_write=%b, i_write_data=%b, o_MEM_mem_data=%b, o_MEM_alu_result=%b",
                      $time, i_MEM_alu_result, i_MEM_mem_write, i_write_data, o_MEM_mem_data, o_MEM_alu_result);                     
    
    #40
    i_MEM_selected_reg = 5'b4;
    $display("Selected reg");
    $display("[$display]time=%0t -> i_MEM_selected_reg=%b, o_MEM_selected_reg=%b", i_MEM_selected_reg, o_MEM_selected_reg);
    $strobe("[$display]time=%0t -> i_MEM_selected_reg=%b, o_MEM_selected_reg=%b", i_MEM_selected_reg, o_MEM_selected_reg);

    $finish;
  end

  always #10 clock = ~clock;

endmodule
