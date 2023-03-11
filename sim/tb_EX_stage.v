module EX_stage_tb;

  // Parameters
  localparam  NB_ALU_OP = 6;
  localparam  NB_ALU_CTRL = 4;
  localparam  NB_IMM = 32;
  localparam  NB_PC = 32;
  localparam  NB_DATA = 32;
  localparam  NB_REG = 5;
  localparam  NB_FCODE = 6;
  localparam  N_OP = 30;

  // Ports
  reg i_clock = 0;
  reg i_EX_reg_write = 0;
  reg i_EX_mem_to_reg = 0;
  reg i_EX_mem_read = 0;
  reg i_EX_mem_write = 0;
  reg i_EX_branch = 0;
  reg i_EX_alu_src = 0;
  reg i_EX_reg_dst = 0;
  reg [NB_ALU_OP-1:0] i_EX_alu_op;
  reg [NB_PC-1:0] i_EX_pc;
  reg [NB_DATA-1:0] i_EX_data_a;
  reg [NB_DATA-1:0] i_EX_data_b;
  reg [NB_IMM-1:0] i_EX_immediate;
  reg [NB_REG-1:0] i_EX_rt;
  reg [NB_REG-1:0] i_EX_rd;
  wire o_EX_reg_write;
  wire o_EX_mem_to_reg;
  wire o_EX_mem_read;
  wire o_EX_mem_write;
  wire o_EX_branch;
  wire [NB_PC-1:0] o_EX_branch_address;
  wire o_EX_zero;
  wire [NB_DATA-1:0] o_EX_alu_result;
  wire [NB_DATA-1:0] o_EX_data_a;
  wire [NB_REG-1:0] o_EX_selected_reg;

  EX_stage 
  #(
    .NB_ALU_OP(NB_ALU_OP),
    .NB_ALU_CTRL(NB_ALU_CTRL),
    .NB_IMM(NB_IMM),
    .NB_PC(NB_PC),
    .NB_DATA(NB_DATA),
    .NB_REG(NB_REG),
    .NB_FCODE (NB_FCODE)
  )
  EX_stage_dut (
    .i_clock (i_clock),
    .i_EX_reg_write(i_EX_reg_write),
    .i_EX_mem_to_reg(i_EX_mem_to_reg),
    .i_EX_mem_read(i_EX_mem_read),
    .i_EX_mem_write(i_EX_mem_write),
    .i_EX_branch(i_EX_branch),
    .i_EX_alu_src(i_EX_alu_src),
    .i_EX_reg_dst(i_EX_reg_dst),
    .i_EX_alu_op(i_EX_alu_op),
    .i_EX_pc(i_EX_pc),
    .i_EX_data_a(i_EX_data_a),
    .i_EX_data_b(i_EX_data_b),
    .i_EX_immediate(i_EX_immediate),
    .i_EX_rt(i_EX_rt),
    .i_EX_rd(i_EX_rd),
    .o_EX_reg_write(o_EX_reg_write),
    .o_EX_mem_to_reg(o_EX_mem_to_reg),
    .o_EX_mem_read(o_EX_mem_read),
    .o_EX_mem_write(o_EX_mem_write),
    .o_EX_branch(o_EX_branch),
    .o_EX_branch_address(o_EX_branch_address),
    .o_EX_zero(o_EX_zero),
    .o_EX_alu_result(o_EX_alu_result),
    .o_EX_data_a(o_EX_data_a),
    .o_EX_selected_reg( o_EX_selected_reg)
  );
  
  reg [31:0] instruction [N_OP-1:0];

  generate
    if (INIT_FILE != "") begin: 
      initial
        $readmemb(INIT_FILE, instruction, 0, N_OP-1);
    end else begin: 
      integer i;
      initial
        for (i = 0; i < N_OP; i = i + 1)
          instruction[i] = {32{1'b0}};
    end
  endgenerate

  initial begin
    i_clock = 1'b0;
    op_counter = 0;
    tests_counter = 0;
    // i_EX_reg_write = 1'b0;
    // i_EX_mem_to_reg = 1'b0;
    // i_EX_mem_read = 1'b0;
    // i_EX_mem_write = 1'b0;
    // i_EX_branch = 1'b0;

    $display("--------------------------------------");
    $display("Starting Tests");
    #40
    // add $s0,$s1,$s2 -> 000000 10001 10010 10000 00000 100000
    i_EX_alu_src = 1'b0; // rt
    i_EX_reg_dst = 1'b1; // rd
    i_EX_alu_op = 6'b000000; // R-type
    i_EX_pc = 32'h0;
    i_EX_data_a = 32'he;
    i_EX_data_b = 32'hf;
    i_EX_immediate = 32'h20; // Se usa solo funct
    i_EX_rt = 5'b10010; // $s2 NO deberia usarse.
    i_EX_rd = 5'b10000; // $s0

    for(op_counter = 0; op_counter <= N_OP; op_counter = op_counter+1)begin
           
      for(tests_counter = 0; tests_counter <= N_tests; tests_counter = tests_counter+1)begin
          #100
          i_EX_data_a = $urandom;
          // switches = i_EX_data_a;
          // buttons = 3'd1;

          #100
          i_EX_data_b = $urandom;
          // switches = i_EX_data_b;
          // buttons = 3'd2;

          #100
          // TODO: completar
          i_EX_alu_op = instruction[op_counter][31:-6];
          buttons = 3'd4;
          
          #100
          case(instruction[op_counter])
              32: if(i_EX_data_a + i_EX_data_b !== o_EX_alu_result) begin
                      $display("%b + %b = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                      $display("Error en la suma");
                  end
              34: if(i_EX_data_a - i_EX_data_b !== o_EX_alu_result) begin
                      $display("%b - %b = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                      $display("Error en la resta");
                  end
              36: if((i_EX_data_a & i_EX_data_b) !== o_EX_alu_result) begin
                      $display("%b & %b = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                      $display("Error en la and");
                  end
              37: if((i_EX_data_a | i_EX_data_b) !== o_EX_alu_result) begin
                      $display("%b | %b = %b)", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                      $display("Error en la or");
                  end
              38: if((i_EX_data_a ^ i_EX_data_b) !== o_EX_alu_result) begin
                      $display("%b ^ %b = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                      $display("Error en la xor");
                  end
              3:  begin
                      i_EX_data_b[NB_INPUTS-1] = 1'b0; //Quitamos el signo al dato B que nos indica cuantas veces shifteamos el dato A.
                      
                      if((i_EX_data_a >>> i_EX_data_b) !== o_EX_alu_result) begin
                          $display("%b >>> %b = %b but expected: %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result, (i_EX_data_a >>> i_EX_data_b));
                          $display("Error en la sra");
                      end
                  end
              2:  if((i_EX_data_a >> i_EX_data_b) !== o_EX_alu_result) begin
                      $display("%b >> %b = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                      $display("Error en la srl");
                  end
              39: if((~(i_EX_data_a | i_EX_data_b)) != o_EX_alu_result) begin
                      $display("~(%b | %b) = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                      $display("Error en la nor");
                  end
          endcase
      end

      $display("Test %d terminado", op_counter);

    $finish;
  end

  always #10 clock = ~clock;

endmodule
