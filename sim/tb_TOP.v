`timescale 1ns / 1ps

module tb_TOP;

  // Parameters
  localparam  BYTE = 8;
  localparam  DWORD = 32;
  localparam  ADDR = 5;
  localparam  NB_MEM_DEPTH = 8;
  localparam  RB_ADDR = 5;
  localparam  NB_STATE = 9;
  localparam  NB_DATA = 8;
  localparam  NB_OP = 6;


  // Ports
  reg             i_clock       = 0;
  reg             i_reset       = 0;
  reg             i_clock_reset = 0;
  reg             i_uart_du_rx  = 0;
  reg [BYTE-1:0]  command       = 8'd0;
  reg             send          = 1'b0;

  wire uart_du_tx;
  wire uart_du_rx;
  wire clk_wzrd;  // Borrar

  wire o_hlt;
  wire [NB_STATE-1:0] o_state;
  
  // UART externa
  reg i_rx;
  wire o_rx;
  wire o_rx_done_tick;
  wire o_tx_done_tick;
  
  integer i;
  integer inst_counter;
  reg [NB_DATA-1:0] memory [255:0]; 

  TOP #(
    .BYTE(BYTE),
    .DWORD(DWORD),
    .ADDR(ADDR),
    .NB_MEM_DEPTH(NB_MEM_DEPTH),
    .RB_ADDR(RB_ADDR ),
    .NB_STATE (NB_STATE)
  )
  TOP_dut (.i_clock (i_clock),
            .i_reset (i_reset),
            .i_clock_reset (i_clock_reset),
            .i_uart_du_rx (uart_du_rx),
            .o_uart_du_tx (uart_du_tx),
            .o_hlt (o_hlt),
            .o_state (o_state),
            .o_clk(clk_wzrd)
        );

  UART #(.NB_DATA(NB_DATA),
         .NB_OP(NB_OP))
  UART_dut(.i_clock(clk_wzrd), // Cambiar
           .i_reset(i_reset),
           .i_rx(uart_du_tx),
           .i_tx(command),
           .i_tx_start(send),
           .o_rx(o_rx),
           .o_rx_done_tick(o_rx_done_tick),
           .o_tx(uart_du_rx),
           .o_tx_done_tick(o_tx_done_tick));       

  initial begin
    i_clock       = 1'b0;
    i_reset       = 1'b1;
    i_clock_reset = 1'b1;
    command       = 8'd0;
    send          = 1'b0;

    #100
    i_clock_reset = 1'b0;

    #600
    i_reset = 1'b0;
    // #400
    // $display("Write IM.");
    // command = 8'd1; // WRITE_IM
    // send    = 1'b1;

    // #20
    // send    = 1'b0;
    // $readmemb("/home/jime/Documents/UNC/aquitectura_de_computadoras/TP-Final-Arquitectura-2021/GUI/instructions.mem", memory, 0, 255);
    // 	// Se envia instruccion por instruccion, byte por byte
    // for (i=0; i<256; i=i+1) begin
    //     $display("instructions : ",inst_counter);
    //     inst_counter = inst_counter+1;
    // 	$display("valor: ", memory[i]);
	// 	#20
	// 	i_rx_data	= memory[i];
	// 	i_rx_done	= 1'b1;

	// 	#20
	// 	i_rx_done	= 1'b0;
    // end
   

    //#4000000
    #400
    $display("Display read BANK REGISTER.");
    command = 8'd4;
    send    = 1'b1;

    #20
    send    = 1'b0;
    
    #75000000
    // command = 8'd8;
    // send    = 1'b1;

    $finish;
  end

  always
    #5  i_clock = ! i_clock ;

endmodule
