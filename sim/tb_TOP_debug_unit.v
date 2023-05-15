module tb_TOP_debug_unit;

  // Parameters
  localparam  BYTE = 8;
  localparam  ADDR = 6;

  // Ports
  reg               i_clock;
  reg               i_reset;
  reg [BYTE-1:0]    command;
  reg               send = 0;

  TOP_debug_unit #( .BYTE(BYTE),
                    .ADDR(ADDR))
  TOP_debug_unit_dut (.i_clock(i_clock),
                      .i_reset(i_reset),
                      .command(command),
                      .send (send));

  initial begin
    i_clock = 1'b0;
    i_reset = 1'b1;
    command = 8'd0;
    send    = 1'b0;

    #40
    i_reset = 1'b0;
    command = 8'd8;
    send    = 1'b1;

    #500
    
    $finish;
  end

  always
    #5  i_clock = ! i_clock ;

endmodule
