`timescale 1ns / 1ps

module debug_unit#(
    parameter NB_STATE    = 5,
    parameter NB_DATA     = 8,
    parameter NB_SIZE     = 16, // 2B x 8 b, el tamaño de los datos a recibir en bits
    parameter N_SIZE      = 2,  // 2B de frame para obtener el total de los datos (size)
    parameter NB_ADDR     = 32,
    parameter NB_ADDR_RB  = 4,
    parameter BYTES_IN_32 = 4,
    parameter NB_ADDR_DM  = 6, 
    parameter BR_SIZE     = 32,
    parameter MEM_SIZE    = 256
)    
(
    input                i_clock,
    input                i_reset,
    input                i_hlt,        // proveniente del DATAPATH
    input                i_rx_done,    // meaning: RX tiene un byte listo para ser leido - UART
    input                i_tx_done,    // meaning: TX ya envio el byte - UART
    input  [NB_DATA-1:0] i_rx_data,    // from RX - UART

    input  [NB_ADDR-1:0] i_pc_value,   // data read from PC 
    input  [NB_DATA-1:0] i_dm_data,    // data read from DATA MEMORY
    input  [NB_ADDR-1:0] i_br_data,    // data read from BANK REGISTER
    output [NB_DATA-1:0] o_im_data,    // data to write in INSTRUCTION MEMORY

    output [NB_ADDR-1:0]    o_im_addr, // address to write INSTRUCTION MEMORY
    output [NB_ADDR_RB-1:0] o_rb_addr, // address to read BANK REGISTER
    output [NB_ADDR_DM-1:0] o_dm_addr, // address to read DATA MEMORY

    output [NB_DATA-1:0] o_tx_data,    // to TX - UART
    output o_tx_start,                 // to TX - UART

    output o_im_write_enable,
    output o_im_enable,
    output o_rb_read_enable,
    output o_rb_enable,
    output o_dm_enable,
    output o_dm_read_enable,
    output o_cu_enable
);

// States
localparam [NB_STATE-1:0] IDLE         = 5'd1;
localparam [NB_STATE-1:0] SIZE         = 5'd2;
localparam [NB_STATE-1:0] DATA         = 5'd3;
localparam [NB_STATE-1:0] READY        = 5'd4;
localparam [NB_STATE-1:0] START        = 5'd5;
localparam [NB_STATE-1:0] STEP_BY_STEP = 5'd6;
localparam [NB_STATE-1:0] SEND_BR      = 5'd7;
localparam [NB_STATE-1:0] SEND_MEM     = 5'd8;
localparam [NB_STATE-1:0] SEND_PC      = 5'd9;

// External commands
localparam [NB_DATA-1:0] COMMAND_A = 8'd1;
localparam [NB_DATA-1:0] COMMAND_B = 8'd2;
localparam [NB_DATA-1:0] COMMAND_C = 8'd3;
localparam [NB_DATA-1:0] COMMAND_D = 8'd4;
localparam [NB_DATA-1:0] COMMAND_E = 8'd5;
localparam [NB_DATA-1:0] COMMAND_F = 8'd6;
localparam [NB_DATA-1:0] COMMAND_G = 8'd7;

// FSM logic
reg [NB_STATE-1:0] state, next_state;

// INSTRUCTION MEMORY
reg [NB_SIZE-1:0] im_size, next_im_size;             // Cantidad de bytes a recibir para guardar en INSTRUCTION MEMORY
reg [NB_SIZE-1:0] im_count, next_im_count;           // Indica la espera de 2 bytes para obtener el SIZE total
// reg [NB_DATA-1:0] im_data, next_im_data;
reg [N_SIZE-1:0] im_data_count, next_im_data_count;  // Address a escribir
reg im_write, next_im_write;                         // Flag que habilita la escritura del IM

// DATA MEMORY
reg [NB_ADDR_DM-1:0] count_dm_tx_done, next_count_dm_tx_done; // Address

// BANK REGISTER
reg [NB_ADDR_RB-1:0] count_br_tx_done, next_count_br_tx_done; 
reg [NB_ADDR_RB-1:0] count_br_byte, next_count_br_byte; // cuenta hasta BYTES_IN_32 (4 bytes)

// TX
reg [NB_DATA-1:0] send_data, send_data_next; // DM & BR -> TX

// Memory
always @(posedge i_clock) begin
    if(i_reset) begin
        state <= IDLE;
        // INSTRUCTION MEMORY 
        im_size <= 0;
        im_count <= 0;
        im_data_count <= 0;
        im_data <= 0;
        im_write <= 0;
        // DATA MEMORY
        count_dm_tx_done <= 0;
        // TX
        send_data <= 0;

    end
    else begin
        state <= next_state;
        // INSTRUCTION MEMORY
        im_size <= next_im_size;    
        im_count <= next_im_count;
        im_data <= next_im_data;
        im_data_count <= next_im_data_count;
        im_write <= next_im_write;
        // DATA MEMORY
        count_dm_tx_done <= count_dm_tx_done_next;
        // TX
        send_data <= send_data_next;
    end
end

// Next sate logic
always @(*) begin
    next_state = state;
    next_im_size = im_size;

    case (state)
        IDLE: begin
            if(i_rx_done) begin
                if(i_rx_data == COMMAND_A) begin
                    next_state = SIZE;
                end
                else if(i_rx_data == COMMAND_F) begin
                    next_state = SEND_BR;
                end
                else if (i_rx_data == COMMAND_G) begin
                    next_state = SEND_PC;
                end
                else if (i_rx_data == COMMAND_H) begin
                    next_state = SEND_MEM;

                    o_dm_enable = 1;
                    o_dm_read_enable = 1;
                    send_data_next = i_dm_data; // TODO: Ver si Delay en i_dm_data de 1 clock

                    o_tx_start = 1; // TODO: Ver si sta bien mandarlo de una sin esperar un clock?

                end
            end
        end
        SIZE: begin
            if(i_rx_done) begin
                if(im_count == N_SIZE) begin
                    next_state = DATA;
                    next_im_count = 0;
                end
                else begin
                    next_im_size = {i_rx_data, next_im_size[NB_SIZE-1:NB_DATA]};//  Primero mandar el LSB
                    next_im_count = im_count + 1;
                end
            end
        end
        DATA: begin
            if(i_rx_done) begin
                if(im_data_count == im_count) begin
                    next_state = READY;
                    next_im_data_count = 0; // INSTRUCTION MEMORY write address
                    next_im_write = 0;
                end
                else begin
                    next_im_data_count = im_data_count + 1;
                    next_im_write = 1;  // enable escritura en INSTRUCTION MEMORY
                end
            end
        end
        READY: begin
            if(i_rx_done) begin
                if(i_rx_data == COMMAND_D) begin // Modo continuo
                    next_state = START;
                end
                else if (i_rx_data == COMMAND_E) begin // Modo step by step
                    next_state = STEP_BY_STEP;
                end
            end
        end
        START: begin // Modo continuo
            if(i_hlt) begin
                next_state = IDLE;
                // TODO: Agregar LED de fin de ejecucion.
            end
            else begin


                // TODO: COMPLETAR

            end
        end
        STEP_BY_STEP: begin // Modo step by step


            // TODO: COMPLETAR


        end
        SEND_BR: begin
            if(count_dm_tx_done_next == 0) begin
                
            end
            else begin
                if(i_tx_done) begin
                    if (count_dm_tx_done == )
                    count_dm_tx_done_next = count_dm_tx_done + 1;

                    // TODO: COMPLETAR

                end
            end
            
        end
        SEND_MEM: begin
            // TODO: VER COMO ENVIAR EL PRIMER DATO (TX_DONE=0)
            if(i_tx_done) begin
                if (count_dm_tx_done == (MEM_SIZE-1)) begin
                    next_state = IDLE;

                    count_dm_tx_done_next = 0;
                    o_dm_enable = 0;
                    o_dm_read_enable = 0;
                    
                    o_tx_start = 0;
                end
                else begin
                    o_tx_start = 1;
                    count_dm_tx_done_next = count_dm_tx_done + 1; // address
                    o_dm_enable = 1;
                    o_dm_read_enable = 1;
                    send_data_next = i_dm_data; // TODO: VER Delay en i_dm_data de 1 clock
                end
            end
        end
        SEND_PC: begin
            
        end

    endcase
end

// INSTRUCTION MEMORY
assign o_im_data = i_rx_data;
assign o_im_write_enable = im_write;
assign o_im_addr = im_data_count;

// DATA MEMORY
assign o_dm_addr = count_dm_tx_done; // Cada vez que haya un tx_done, se avanza +1 address

// TX
assign o_tx_data = send_data;

endmodule