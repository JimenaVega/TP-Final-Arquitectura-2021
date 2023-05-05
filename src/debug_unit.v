`timescale 1ns / 1ps

module debug_unit#(
    parameter NB_STATE = 5,
    parameter NB_DATA  = 8
)    
(
    input i_clock,
    input i_reset,
    input [NB_DATA-1:0] i_rx_data,
    output [NB_DATA-1:0] o_tx_data
);

localparam [NB_STATE-1:0] IDLE = 5'd1;
localparam [NB_STATE-1:0] IM_SIZE = 5'd2;
localparam [NB_STATE-1:0] IM_DATA = 5'd3;
localparam [NB_STATE-1:0] BR_SIZE = 5'd4;
localparam [NB_STATE-1:0] BR_DATA = 5'd5;
localparam [NB_STATE-1:0]  = 5'd1;
localparam [NB_STATE-1:0] IDLE = 5'd1;
localparam [NB_STATE-1:0] IDLE = 5'd1;
localparam [NB_STATE-1:0] IDLE = 5'd1;
localparam [NB_STATE-1:0] IDLE = 5'd1;
localparam [NB_STATE-1:0] IDLE = 5'd1;
localparam [NB_STATE-1:0] IDLE = 5'd1;
localparam [NB_STATE-1:0] IDLE = 5'd1;
localparam [NB_STATE-1:0] IDLE = 5'd1;


endmodule