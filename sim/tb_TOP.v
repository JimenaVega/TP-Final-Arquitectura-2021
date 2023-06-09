module tb_TOP;

  // Parameters
  localparam  BYTE    = 8;
  localparam  DWORD   = 32;
  localparam  ADDR    = 7;
  localparam  RB_ADDR = 5;
  localparam  NB_DATA = 8;
  localparam  NB_OP   = 6;

  // Ports
  reg             i_clock       = 1'b0;
  reg             i_clock_reset = 1'b1;
  reg             i_reset       = 1'b1;
  reg [BYTE-1:0]  command       = 8'd0;
  reg             send          = 1'b0;

  wire uart_du_rx;

  TOP #(.BYTE(BYTE),
        .DWORD(DWORD),
        .ADDR(ADDR),
        .RB_ADDR(RB_ADDR))
  TOP_dut(.i_clock(i_clock),
          .i_reset(i_reset),
          .i_clock_reset(i_clock_reset),
          .i_uart_du_rx(uart_du_rx));

  UART #(.NB_DATA(NB_DATA),
         .NB_OP(NB_OP))
  UART_dut(.i_clock(i_clock),
           .i_reset(i_reset),
           .i_rx(),
           .i_tx(command),
           .i_tx_start(send),
           .o_rx(),
           .o_rx_done_tick(),
           .o_tx(uart_du_rx),
           .o_tx_done_tick());

  initial begin
    i_clock       = 1'b0;
    i_reset       = 1'b1;
    i_clock_reset = 1'b1;
    command       = 8'd0;
    send          = 1'b0;

    #100
    i_clock_reset = 1'b0;

    #650
    i_reset = 1'b0;
    
    #400
    command = 8'd3;
    send    = 1'b1;

    #20
    send    = 1'b0;

    #1200000
    command = 8'd7;
    send    = 1'b1;

    #20
    send    = 1'b0;
    
    #75000000
    command = 8'd8;
    send    = 1'b1;

    $finish;
  end

  always
    #5  i_clock = ! i_clock ;

endmodule
