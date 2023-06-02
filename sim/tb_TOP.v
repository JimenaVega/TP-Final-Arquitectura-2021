module tb_TOP;

  // Parameters
  localparam  BYTE = 8;
  localparam  DWORD = 32;
  localparam  ADDR = 7;
  localparam  RB_ADDR = 5;

  // Ports
  reg i_clock = 0;
  reg i_reset = 0;
  reg uart_du_rx = 0;

  TOP 
  #(
    .BYTE(BYTE),
    .DWORD(DWORD),
    .ADDR(ADDR),
    .RB_ADDR(RB_ADDR)
  )
  TOP_dut(
    .i_clock(i_clock),
    .i_reset(i_reset),
    .uart_du_rx(uart_du_rx)
  );

  initial begin
    begin
      $finish;
    end
  end

  always
    #5  i_clock = ! i_clock ;

endmodule
