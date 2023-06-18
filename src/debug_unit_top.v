`timescale 1ns / 1ps
// Este modulo es solo de prueba y debe borrarse
module debug_unit_top#(
        parameter BYTE      = 8,
        parameter DWORD     = 32,
        parameter ADDR      = 7,
        parameter NB_MEM_DEPTH = 8,
        parameter RB_ADDR   = 5,
        parameter NB_STATE  = 4
    )
    (
        input                 i_clock,
        input                 i_reset,
        input                 i_clock_reset,
        input                 i_uart_du_rx,
        // input                 i_halt,

        // output                o_uart_du_tx,
        output [NB_STATE-1:0] o_state,
        output                o_led_rx_done, //borrar

        // suponiendo que despues de debug unit no hay nada
        output               o_im_data,
        output               o_im_addr,
        // output               o_rb_address,
        // output               o_dm_address,
        output               o_im_write_enable, //T
        output               o_im_enable, //T
        // output               o_rb_read_enable, // T
        // output               o_rb_enable, //T
        // output               o_dm_enable, //  T
        // output               o_dm_read_enable, // T*2?
        output               o_cu_enable //T
        // output               o_pc_enable, // T
        // output               o_step_flag, // T
        // output               o_step //T
    );

    wire clk_wiz;
    
    clk_wiz_0 inst
      (
      // Clock out ports  
      .clk_out1(clk_wiz),
      // Status and control signals               
      .reset(i_clock_reset), 
      .locked(),
     // Clock in ports
      .clk_in1(i_clock)
      );

    // reg                 data_path_clk;
    // reg                 im_read_enable = 1'b1;

   

    wire                uart_du_rx_done;

    wire                uart_du_tx_done;
    wire [BYTE-1:0]     uart_du_received;


    wire                im_enable;
    wire                im_write_enable;
    wire [DWORD-1:0]    im_addr;
    wire [BYTE-1:0]     im_data;

    wire                cu_enable;


    wire [NB_STATE-1:0] state;


    // always@(*)begin
    //     if(step_flag)begin
    //       data_path_clk = step;
    //     end
    //     else begin
    //       data_path_clk = clk_wiz;
    //     end
    // end
    
    dummy_db_unit debug_unit_1(.i_clock(clk_wiz), // 50 MHz
                            .i_reset(i_reset),
                            .i_rx_done(uart_du_rx_done),
                            .i_rx_data(uart_du_received),
                         
                            .o_im_data(im_data),
                            .o_im_addr(im_addr),
                          
                            .o_im_write_enable(im_write_enable),
                            .o_im_enable(im_enable),
                           
                            .o_cu_enable(cu_enable),

                            .o_state(state));
    
    dummy_uart UART_debug_unit(.i_clock(clk_wiz), // 50 MHz
                         .i_reset(i_reset),
                         .i_rx(i_uart_du_rx),
                        //  .i_tx(uart_du_to_send),
                        //  .i_tx_start(uart_du_tx_start),
                         .o_rx(uart_du_received),
                         .o_rx_done_tick(uart_du_rx_done)
                        //  .o_tx(uart_du_tx),
                        //  .o_tx_done_tick(uart_du_tx_done)
                         );

    // data_path data_path_1(.i_clock(clk_wiz), // 50 MHz o Steps
    //                       .i_pc_enable(pc_enable),
    //                       .i_pc_reset(i_reset),
    //                       .i_read_enable(im_read_enable),
    //                       .i_ID_stage_reset(i_reset),
    //                       .i_ctrl_reset(i_reset),
    //                       .i_im_enable(im_enable),
    //                       .i_im_write_enable(im_write_enable),
    //                       .i_im_data(im_data),
    //                       .i_im_address(im_addr[7:0]),
    //                       .i_rb_enable(rb_enable),
    //                       .i_rb_read_enable(rb_read_enable),
    //                       .i_rb_address(rb_addr),
    //                       .i_dm_enable(mem_enable),
    //                       .i_dm_read_enable(mem_read_enable),
    //                       .i_dm_read_address(mem_addr),
    //                       .i_cu_enable(cu_enable),
    //                       .o_hlt(halt),
    //                       .o_pc_value(pc),
    //                       .o_rb_data(rb_data),
    //                       .o_dm_data(mem_data));
    
    assign o_state      = state;
    // assign o_uart_du_tx = uart_du_tx;
    // assign o_hlt        = halt;
    // assign o_clk        = clk_wiz; // borrar
    assign o_led_rx_done = uart_du_rx_done;
    // assign o_pc_value = pc[0];

    assign               o_im_data = im_data[0];
    assign               o_im_addr = im_addr[0];
    // assign               o_rb_address = rb_addr[0];
    // assign               o_dm_address = mem_addr[0];
  
    assign               o_im_write_enable = im_write_enable;
    assign               o_im_enable = im_enable;
    // assign               o_rb_read_enable = rb_read_enable;
    // assign               o_rb_enable = rb_enable;
    // assign               o_dm_enable = mem_enable;
    // assign               o_dm_read_enable = mem_read_enable;
    assign               o_cu_enable = cu_enable;
    // assign               o_pc_enable = pc_enable;
    // assign               o_step_flag = step_flag;
    // assign               o_step = step;
 
    
endmodule

