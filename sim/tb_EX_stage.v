module EX_stage_tb;

  // Parameters
  localparam  INIT_FILE ="/home/jime/Documents/UNC/aquitectura_de_computadoras/TP-Final-Arquitectura-2021/translator/output_r.mem";
  localparam  N_TESTS = 2;
  localparam  NB_ALU_OP   = 6;
  localparam  NB_ALU_CTRL = 4;
  localparam  NB_IMM      = 32;
  localparam  NB_PC       = 32;
  localparam  NB_DATA     = 32;
  localparam  NB_REG      = 5;
  localparam  NB_FCODE    = 6;
  localparam  N_OP        = 9;

  // Ports
  reg                 i_clock;
  reg                 i_EX_reg_write;
  reg                 i_EX_mem_to_reg;
  reg                 i_EX_mem_read;
  reg                 i_EX_mem_write;
  reg                 i_EX_branch;
  reg                 i_EX_alu_src;
  reg                 i_EX_reg_dst;
  reg [NB_ALU_OP-1:0] i_EX_alu_op;
  reg [NB_PC-1:0]     i_EX_pc;
  reg [NB_DATA-1:0]   i_EX_data_a;
  reg [NB_DATA-1:0]   i_EX_data_b;
  reg [NB_IMM-1:0]    i_EX_immediate;
  reg [NB_DATA-1:0]   i_EX_shamt;
  reg [NB_REG-1:0]    i_EX_rt;
  reg [NB_REG-1:0]    i_EX_rd;
  reg                 i_EX_byte_en      = 0;
  reg                 i_EX_halfword_en  = 0;
  reg                 i_EX_word_en      = 0;

  wire                o_EX_reg_write;
  wire                o_EX_mem_to_reg;
  wire                o_EX_mem_read;
  wire                o_EX_mem_write;
  wire                o_EX_branch;
  wire [NB_PC-1:0]    o_EX_branch_addr;
  wire                o_EX_zero;
  wire [NB_DATA-1:0]  o_EX_alu_result;
  wire [NB_DATA-1:0]  o_EX_data_a;
  wire [NB_REG-1:0]   o_EX_selected_reg;
  wire                o_EX_byte_en;
  wire                o_EX_halfword_en;
  wire                o_EX_word_en;

  integer             op_counter;
  integer             tests_counter;

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
    .i_EX_reg_dest(i_EX_reg_dest),
    .i_EX_alu_op(i_EX_alu_op),
    .i_EX_pc(i_EX_pc),
    .i_EX_data_a(i_EX_data_a),
    .i_EX_data_b(i_EX_data_b),
    .i_EX_immediate(i_EX_immediate),
    .i_EX_shamt(i_EX_shamt),
    .i_EX_rt(i_EX_rt),
    .i_EX_rd(i_EX_rd),
    .i_EX_byte_en(i_EX_byte_en),
    .i_EX_halfword_en(i_EX_halfword_en),
    .i_EX_word_en(i_EX_word_en),
    .o_EX_reg_write(o_EX_reg_write),
    .o_EX_mem_to_reg(o_EX_mem_to_reg),
    .o_EX_mem_read(o_EX_mem_read),
    .o_EX_mem_write(o_EX_mem_write),
    .o_EX_branch(o_EX_branch),
    .o_EX_branch_addr(o_EX_branch_addr),
    .o_EX_zero(o_EX_zero),
    .o_EX_alu_result(o_EX_alu_result),
    .o_EX_data_a(o_EX_data_a),
    .o_EX_selected_reg( o_EX_selected_reg),
    .o_EX_byte_en(o_EX_byte_en),
    .o_EX_halfword_en(o_EX_halfword_en),
    .o_EX_word_en(o_EX_word_en)
  );
  
  reg [31:0] instruction [N_OP-1:0];

  generate
    if (INIT_FILE != "") begin 
      initial
        $readmemb(INIT_FILE, instruction, 0, N_OP-1);
    end else begin 
      integer i;
      initial
        for (i = 0; i < N_OP; i = i + 1)
          instruction[i] = {32{1'b0}};
    end
  endgenerate

  initial begin

    $display("--------------------------------------");
    $display("Starting Tests for R inst");
    
    // valores hardcodeados
    i_clock = 1'b0;
    op_counter = 0;
    tests_counter = 0;
    i_EX_pc = 32'b0; // PC
    i_EX_alu_src = 1'b0; // Se prueban operaciones tipo R, esta flag siempre a a ser 0
    i_EX_reg_dst = 1'b1; // La salida del MUX siempre va a ser rd

    // flags no usadas en este stage
    i_EX_reg_write = 1'b0;
    i_EX_mem_to_reg = 1'b0;
    i_EX_mem_read = 1'b0;
    i_EX_mem_write = 1'b0;
    i_EX_branch = 1'b0;

    for(op_counter = 0; op_counter < N_OP; op_counter = op_counter+1)begin
    
     $display("--------------------------------------------------------");
     $display("op_counter=%0d, instruction=%b", op_counter, instruction[op_counter]);
     $display("--------------------------------------------------------");
           
      for(tests_counter = 0; tests_counter <= N_TESTS; tests_counter = tests_counter+1)begin
          #40
          i_EX_data_a = $urandom;
         
          #40
          i_EX_data_b = $urandom;
       
          #40
          i_EX_immediate = {16'b0, instruction[op_counter][16:0]}; // immediate incluido funct_code
          i_EX_rt = instruction[op_counter][20:16];
          i_EX_rd = instruction[op_counter][15:11];
          
          #40
          i_EX_alu_op = instruction[op_counter][31:26];
         
          #40
          if(!instruction[op_counter][31:26]) begin //R-type
            
            case(instruction[op_counter][6:0]) // funct
              6'b100000: begin // add
                if(i_EX_data_a + i_EX_data_b !== o_EX_alu_result) begin
                  $display("%0d + %0d = %0d", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                  $display("Error en add");
                end
                else begin
                    $display("R-TYPE: add OPCODE:%b FUNCT:%b paso test [%0d]", instruction[op_counter][31:26], instruction[op_counter][6:0], tests_counter);
                end
              end
              6'b100001: begin // addu
                if(i_EX_data_a + i_EX_data_b !== o_EX_alu_result) begin
                  $display("%d + %d = %d", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                  $display("Error en addu");
                end
                else begin
                    $display("R-TYPE: addu OPCODE:%b FUNCT:%b paso test [%0d]", instruction[op_counter][31:26], instruction[op_counter][6:0], tests_counter);
                end
              end
              6'b100010: begin // sub
                if(i_EX_data_a - i_EX_data_b !== o_EX_alu_result) begin
                  $display("%b - %b = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                  $display("Error en la sub");
                end
                else begin
                    $display("R-TYPE: sub OPCODE:%b FUNCT:%b paso test [%0d]", instruction[op_counter][31:26], instruction[op_counter][6:0], tests_counter);
                end
              end
              6'b100011: begin  // subu
                if(i_EX_data_a - i_EX_data_b !== o_EX_alu_result) begin
                  $display("%b - %b = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                  $display("Error en la subu");
                end
                else begin
                    $display("R-TYPE: subu OPCODE:%b FUNCT:%b paso test [%0d]", instruction[op_counter][31:26], instruction[op_counter][6:0], tests_counter);
                end
              end
              6'b100100: begin // and
                if((i_EX_data_a & i_EX_data_b) !== o_EX_alu_result) begin
                  $display("%b & %b = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                  $display("Error en la and");
                end
                else begin
                    $display("R-TYPE: and OPCODE:%b FUNCT:%b paso test [%0d]", instruction[op_counter][31:26], instruction[op_counter][6:0], tests_counter);
                end
              end
              6'b100111: begin //nor
                if((~(i_EX_data_a | i_EX_data_b)) != o_EX_alu_result) begin
                  $display("~(%b | %b) = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                  $display("Error en la nor");
                end
                else begin
                    $display("R-TYPE: nor OPCODE:%b FUNCT:%b paso test [%0d]", instruction[op_counter][31:26], instruction[op_counter][6:0], tests_counter);
                end
              end
              6'b100101: begin // or
                if((i_EX_data_a | i_EX_data_b) !== o_EX_alu_result) begin
                  $display("%b | %b = %b)", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                  $display("Error en la or");
                end
                else begin
                    $display("R-TYPE: or OPCODE:%b FUNCT:%b paso test [%0d]", instruction[op_counter][31:26], instruction[op_counter][6:0], tests_counter);
                end
              end
              6'b100110: begin // xor
                if((i_EX_data_a ^ i_EX_data_b) !== o_EX_alu_result) begin
                  $display("%b ^ %b = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                  $display("Error en la xor");
                end
                else begin
                    $display("R-TYPE: xor OPCODE:%b FUNCT:%b paso test [%0d]", instruction[op_counter][31:26], instruction[op_counter][6:0], tests_counter);
                end
              end
              6'b101010: begin // slt
                if(i_EX_data_a < i_EX_data_b != o_EX_alu_result) begin
                  $display("%b < %b = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                  $display("Error en slti");
                end
              end
              // TODO: Agregar shifts
              6'b000000: begin // sll
                if((i_EX_data_b << i_EX_shamt) !== o_EX_alu_result) begin
                  $display("%b << %0d = %b", i_EX_data_b, i_EX_shamt, o_EX_alu_result);
                  $display("Error en sll");
                end
                else begin
                  $display("R-TYPE: sll OPCODE:%b FUNCT:%b paso test [%0d]", instruction[op_counter][31:26], instruction[op_counter][6:0], tests_counter);
                end
              end
              6'b000010: begin // srl
                if((i_EX_data_b >> i_EX_shamt) !== o_EX_alu_result) begin
                  $display("%b >> %0d = %b", i_EX_data_b, i_EX_shamt, o_EX_alu_result);
                  $display("Error en srl");
                end
                else begin
                  $display("R-TYPE: srl OPCODE:%b FUNCT:%b paso test [%0d]", instruction[op_counter][31:26], instruction[op_counter][6:0], tests_counter);
                end
              end
              6'b000011: begin // sra
                if((i_EX_data_b >>> i_EX_shamt) !== o_EX_alu_result) begin
                  $display("%b >>> %0d = %b", i_EX_data_b, i_EX_shamt, o_EX_alu_result);
                  $display("Error en sra");
                end
                else begin
                  $display("R-TYPE: sra OPCODE:%b FUNCT:%b paso test [%0d]", instruction[op_counter][31:26], instruction[op_counter][6:0], tests_counter);
                end
              end
              6'b000100: begin // sllv
                if((i_EX_data_b << i_EX_data_a) !== o_EX_alu_result) begin
                  $display("%b << %0d = %b", i_EX_data_b, i_EX_data_a, o_EX_alu_result);
                  $display("Error en sllv");
                end
                else begin
                  $display("R-TYPE: sllv OPCODE:%b FUNCT:%b paso test [%0d]", instruction[op_counter][31:26], instruction[op_counter][6:0], tests_counter);
                end
              end
              6'b000110: begin // srlv
                if((i_EX_data_b >> i_EX_data_a) !== o_EX_alu_result) begin
                  $display("%b >> %0d = %b", i_EX_data_b, i_EX_data_a, o_EX_alu_result);
                  $display("Error en srlv");
                end
                else begin
                  $display("R-TYPE: srlv OPCODE:%b FUNCT:%b paso test [%0d]", instruction[op_counter][31:26], instruction[op_counter][6:0], tests_counter);
                end
              end
              6'b000111: begin //srav
                if((i_EX_data_b >>> i_EX_data_a) !== o_EX_alu_result) begin
                  $display("%b >>> %0d = %b", i_EX_data_b, i_EX_data_a, o_EX_alu_result);
                  $display("Error en srav");
                end
                else begin
                  $display("R-TYPE: srav OPCODE:%b FUNCT:%b paso test [%0d]", instruction[op_counter][31:26], instruction[op_counter][6:0], tests_counter);
                end
              end

            endcase
          end
          else if(instruction[op_counter][31:26]) begin // I-type
          $display("I-TYPE: OPCODE:%b FUNCT:%b", instruction[op_counter][31:26], instruction[op_counter][6:0]);
          case(instruction[op_counter][31:26])
              6'b100000: begin
                if(i_EX_data_a + i_EX_immediate !== o_EX_alu_result) begin // lb
                  $display("%b + %b = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                  $display("Error en lb");
                end
              end
              6'b100001: begin // lh
                if(i_EX_data_a + i_EX_immediate !== o_EX_alu_result) begin // lb
                  $display("%b + %b = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                  $display("Error en lh");
                end
              end
              6'b100010: begin // lhu
                if(i_EX_data_a + i_EX_immediate !== o_EX_alu_result) begin // lb
                  $display("%b + %b = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                  $display("Error en lhu");
                end
              end
              6'b100011: begin // lw
                if(i_EX_data_a + i_EX_immediate !== o_EX_alu_result) begin // lb
                  $display("%b + %b = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                  $display("Error en lw");
                end
              end
              6'b100100: begin // lwu
                if(i_EX_data_a + i_EX_immediate !== o_EX_alu_result) begin // lb
                  $display("%b + %b = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                  $display("Error en lwu");
                end
              end
              6'b100101: begin // lbu
                if(i_EX_data_a + i_EX_immediate !== o_EX_alu_result) begin // lb
                  $display("%b + %b = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                  $display("Error en lbu");
                end
              end
              6'b101000: begin // sb
                if(i_EX_data_a + i_EX_immediate !== o_EX_alu_result) begin // lb
                  $display("%b + %b = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                  $display("Error en sb");
                end
              end
              6'b101001: begin // sh
                if(i_EX_data_a + i_EX_immediate !== o_EX_alu_result) begin // lb
                  $display("%b + %b = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                  $display("Error en sw");
                end
              end
              6'b101011: begin // sw
                if(i_EX_data_a + i_EX_immediate !== o_EX_alu_result) begin // lb
                  $display("%b + %b = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                  $display("Error en sw");
                end
              end
              6'b001000: begin // addi
                if(i_EX_data_a + i_EX_immediate !== o_EX_alu_result) begin // lb
                  $display("%b + %b = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                  $display("Error en addi");
                end
              end
              6'b001101: begin // andi
                if((i_EX_data_a & i_EX_immediate) !== o_EX_alu_result) begin
                  $display("%b & %b = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                  $display("Error en andi");
                end
              end
              6'b001101: begin // ori
                if((i_EX_data_a | i_EX_immediate) !== o_EX_alu_result) begin
                  $display("%b | %b = %b)", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                  $display("Error en la or");
                end
              end
              6'b001111: begin // lui
                if((i_EX_data_a << 16) !== o_EX_alu_result) begin
                  $display("%b << 16 = %b", i_EX_data_a, o_EX_alu_result);
                  $display("Error en lui");
                end
              end
              6'b001010: begin // slti
                if(i_EX_data_a < i_EX_immediate != o_EX_alu_result) begin
                  $display("%b < %b = %b", i_EX_data_a, i_EX_data_b, o_EX_alu_result);
                  $display("Error en slti");
                end
              end
          endcase
          end
      end // inner for
      $display("Test %0d terminado", op_counter);
   end // outer for  
    #40
    $finish;
  end

  always #10 clock = ~clock;

endmodule
