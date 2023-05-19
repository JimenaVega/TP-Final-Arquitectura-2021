`timescale 1ns / 1ps

module TOP_debug_unit#(
        parameter BYTE      = 8,
        parameter DWORD     = 32,
        parameter ADDR      = 7,
        parameter RB_ADDR   = 5
    )
    (
        input               i_clock,
        input               i_reset,
        input [BYTE-1:0]    command,
        input               send
    );
    
    wire                uart_du_rx_done;
    wire                uart_du_tx_done;
    wire                uart_du_rx;
    wire                uart_du_tx;
    wire                uart_du_tx_start;
    wire [BYTE-1:0]     uart_du_to_send;
    wire [BYTE-1:0]     uart_du_received;

    wire                mem_enable;
    wire                mem_read_enable;
    wire [BYTE-1:0]     mem_data;
    wire [ADDR-1:0]     mem_addr;

    wire                rb_enable;
    wire                rb_read_enable;
    wire [DWORD-1:0]    rb_data;
    wire [RB_ADDR-1:0]  rb_addr;

    reg             zero = 0;
    
    debug_unit debug_unit_1(.i_clock(i_clock),
                            .i_reset(i_reset),
                            .i_hlt(zero),
                            .i_rx_done(uart_du_rx_done),
                            .i_tx_done(uart_du_tx_done),
                            .i_rx_data(uart_du_received),
                            .i_pc_value(),
                            .i_dm_data(mem_data),
                            .i_br_data(rb_data),
                            .o_im_data(),
                            .o_im_addr(),
                            .o_rb_addr(rb_addr),
                            .o_dm_addr(mem_addr),
                            .o_tx_data(uart_du_to_send),
                            .o_tx_start(uart_du_tx_start),
                            .o_im_write_enable(),
                            .o_im_enable(),
                            .o_rb_read_enable(rb_read_enable),
                            .o_rb_enable(rb_enable),
                            .o_dm_enable(mem_enable),
                            .o_dm_read_enable(mem_read_enable),
                            .o_cu_enable());
    
    UART UART_debug_unit(.i_clock(i_clock),
                         .i_reset(i_reset),
                         .i_rx(uart_du_rx),
                         .i_tx(uart_du_to_send),
                         .i_tx_start(uart_du_tx_start),
                         .o_rx(uart_du_received),
                         .o_rx_done_tick(uart_du_rx_done),
                         .o_tx(uart_du_tx),
                         .o_tx_done_tick(uart_du_tx_done));
    
    UART UART_external(.i_clock(i_clock),
                         .i_reset(i_reset),
                         .i_rx(uart_du_tx),
                         .i_tx(command),
                         .i_tx_start(send),
                         .o_rx(),
                         .o_rx_done_tick(),
                         .o_tx(uart_du_rx),
                         .o_tx_done_tick());

    data_memory data_memory_1(.i_clock(i_clock),
                              .i_enable(mem_enable),
                              .i_read_enable(mem_read_enable),
                              .i_read_address(mem_addr),
                              .i_mem_write_flag(),
                              .i_mem_read_flag(),
                              .i_word_en(),
                              .i_halfword_en(),
                              .i_byte_en(),
                              .i_address(),
                              .i_write_data(),
                              .o_byte_data(mem_data),
                              .o_read_data());

    registers_bank registers_bank_1(.i_clock(i_clock),
                                    .i_enable(rb_enable), // Debug Unit
                                    .i_read_enable(rb_read_enable), // Debug Unit
                                    .i_read_address(rb_addr), // Debug Unit
                                    .i_reset(i_reset),
                                    .i_reg_write(),   // Señal de control RegWrite proveniente de WB
                                    .i_read_reg_a(),
                                    .i_read_reg_b(), 
                                    .i_write_reg(),   // Address 5b
                                    .i_write_data(), // Data 32b
                                    .o_data_a(rb_data),
                                    .o_data_b());
    
endmodule

