`timescale 1ns / 1ps

module TOP_of_tops#(
        parameter BYTE      = 8,
        parameter DWORD     = 32,
        parameter ADDR      = 5,
        parameter NB_MEM_DEPTH = 8,
        parameter RB_ADDR   = 5,
        parameter NB_STATE  = 4
    )
    (
        input                 i_clock,
        input                 i_reset,
        input                 i_clock_reset,
        input                 i_rx_done,
        input                 i_tx_done,
        input   [BYTE-1:0]    i_rx_data,

        // output                o_hlt,
        output [NB_STATE-1:0] o_state,
        // output                o_led_rx_done, //borrar
        // output                o_pc_value,
        output [BYTE-1:0]     o_tx_data,
        output                o_tx_start
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

    reg                 data_path_clk;
    reg                 im_read_enable = 1'b1;

    wire                step_flag;
    wire                step;

    wire                halt;

    wire                mem_enable;
    wire                read_dm_from_du;
    wire                mem_read_enable;
    wire [DWORD-1:0]    mem_data;
    wire [ADDR-1:0]     mem_addr;
  

    wire                rb_enable;
    wire                rb_read_enable;
    wire [DWORD-1:0]    rb_data;
    wire [RB_ADDR-1:0]  rb_addr;

    wire                im_enable;
    wire                im_write_enable;
    wire [BYTE-1:0]     im_addr;
    wire [BYTE-1:0]     im_data;

    wire                cu_enable;
    wire                pc_enable;

    wire [DWORD-1:0]    pc;

    wire [NB_STATE-1:0] state;


    always@(*)begin
        if(step_flag)begin
          data_path_clk = step;
        end
        else begin
          data_path_clk = clk_wiz;
        end
    end
    
    debug_unit debug_unit_1(.i_clock(clk_wiz), // 50 MHz
                            .i_reset(i_reset),
                            .i_hlt(halt),
                            .i_rx_done(i_rx_done),
                            .i_tx_done(i_tx_done),
                            .i_rx_data(i_rx_data),
                            .i_pc_value(pc),
                            .i_dm_data(mem_data),
                            .i_br_data(rb_data),
                            .o_im_data(im_data),
                            .o_im_addr(im_addr),
                            .o_rb_addr(rb_addr),
                            .o_dm_addr(mem_addr),
                            .o_tx_data(o_tx_data),
                            .o_tx_start(o_tx_start),
                            .o_im_write_enable(im_write_enable),
                            .o_im_enable(im_enable),
                            .o_rb_read_enable(rb_read_enable),
                            .o_rb_enable(rb_enable),
                            .o_dm_enable(mem_enable),
                            .o_dm_read_enable(mem_read_enable),
                            .o_dm_du_flag(read_dm_from_du),
                            .o_cu_enable(cu_enable),
                            .o_pc_enable(pc_enable),
                            .o_step_flag(step_flag),
                            .o_step(step),
                            .o_state(state));
    

    data_path data_path_1(.i_clock(clk_wiz), // 50 MHz o Steps
                          .i_pc_enable(pc_enable),
                          .i_pc_reset(i_reset),
                          .i_read_enable(im_read_enable),
                          .i_ID_stage_reset(i_reset),
                          .i_ctrl_reset(i_reset),
                          .i_du_flag(read_dm_from_du),
                          .i_im_enable(im_enable),
                          .i_im_write_enable(im_write_enable),
                          .i_im_data(im_data),
                          .i_im_address(im_addr),
                          .i_rb_enable(rb_enable),
                          .i_rb_read_enable(rb_read_enable),
                          .i_rb_address(rb_addr),
                          .i_dm_enable(mem_enable),
                          .i_dm_read_enable(mem_read_enable),
                          .i_dm_read_address(mem_addr),
                          .i_cu_enable(cu_enable),
                          .o_hlt(halt),
                          // .o_pc_value(pc),
                          .o_rb_data(rb_data),
                          .o_dm_data(mem_data),
                          .o_last_pc(pc));
    
    assign o_state      = state;
    // assign o_hlt        = halt;
    // assign o_led_rx_done = uart_du_rx_done;
    // assign o_pc_value = pc[0];
    
endmodule

