	`timescale 1ns / 1ps

	module UART
			#(parameter NB_DATA = 8,
			parameter NB_OP =6
			)
			(
			input wire i_clock,
			input wire i_reset,
			input wire i_rx,
			input wire [NB_DATA-1:0] i_tx, //from ALU:
			input wire i_tx_start,
			output wire [NB_DATA-1:0] o_rx,
			output wire o_rx_done_tick,
			output wire o_tx,
			output wire o_tx_done_tick
			);

	wire s_tick_wire;

	baudrate_generator bg_instance(.i_clock(i_clock),
								   .i_reset(i_reset),
								   .o_br_clock(s_tick_wire));

	rx_uart rx_uart_instance(.i_clock(i_clock),
							 .i_s_tick(s_tick_wire),
							 .i_reset(i_reset),
							 .i_rx(i_rx),
							 .o_rx_done_tick(o_rx_done_tick),
							 .o_data(o_rx));

	tx_uart tx_uart_instance_2(.i_clock(i_clock),
							   .i_reset(i_reset),
							   .i_tx_start(i_tx_start),
							   .i_s_tick(s_tick_wire),
							   .i_data(i_tx),
							   .o_tx_done_tick(o_tx_done_tick),
							   .o_tx(o_tx));    

	endmodule