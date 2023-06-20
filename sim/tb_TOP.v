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
  reg i_rx_done;
  reg i_tx_done;
  reg [BYTE-1:0] i_rx_data;


  wire [BYTE-1:0] o_state;
  wire [BYTE-1:0] o_tx_data;
  wire o_tx_start;

  TOP_of_tops #(.BYTE(BYTE),
        .DWORD(DWORD),
        .ADDR(ADDR),
        .RB_ADDR(RB_ADDR))
  TOP_dut(.i_clock(i_clock),
          .i_reset(i_reset),
          .i_rx_done(i_rx_done),
          .i_tx_done(i_tx_done),
          .i_rx_data(i_rx_data),
          .i_clock_reset(i_clock_reset),
          .o_state(o_state),
          .o_tx_data(o_tx_data),
          .o_tx_start(o_tx_start)); 


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
    command = 8'd1;
    send    = 1'b1;

    #20
    send    = 1'b0;

    #4000000
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
