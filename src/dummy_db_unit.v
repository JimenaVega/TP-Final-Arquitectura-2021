`timescale 1ns / 1ps

module dummy_db_unit#(
    parameter NB_STATE    = 4,
    parameter NB_DATA     = 8,
    parameter NB_SIZE     = 16, // 2B x 8 b, el tamaño de los datos a recibir en bits
    parameter N_SIZE      = 2,  // 2B de frame para obtener el total de los datos (size)
    parameter NB_ADDR     = 32,
    parameter NB_ADDR_RB  = 5,
    parameter NB_BYTE_CTR = 2,
    parameter NB_ADDR_DM  = 5, 
    parameter BR_SIZE     = 32,
    parameter DM_DEPTH    = 32,
    parameter DM_WIDTH    = 32,
    parameter RB_DEPTH    = 32,
    parameter IM_DEPTH    = 256,
    parameter NB_PC_CTR   = 2
)    
(
    input                   i_clock,
    input                   i_reset,

    input                   i_rx_done,      // meaning: RX tiene un byte listo para ser leido - UART
    input  [NB_DATA-1:0]    i_rx_data,      // from RX - UART

    output [NB_DATA-1:0]    o_im_data,      // *  data to write in INSTRUCTION MEMORY
    output [NB_ADDR-1:0]    o_im_addr,      //  * address to write INSTRUCTION MEMORY
    output                  o_im_write_enable, //*
    output                  o_im_enable, //*
    output                  o_cu_enable,
    output [NB_STATE-1:0]   o_state
);

// States
localparam [NB_STATE-1:0] IDLE         = 4'd1;
localparam [NB_STATE-1:0] WRITE_IM     = 4'd2;
localparam [NB_STATE-1:0] READY        = 4'd4;
localparam [NB_STATE-1:0] START        = 4'd5;
localparam [NB_STATE-1:0] STEP_BY_STEP = 4'd6;
localparam [NB_STATE-1:0] SEND_BR      = 4'd7;
localparam [NB_STATE-1:0] SEND_MEM     = 4'd8;
localparam [NB_STATE-1:0] SEND_PC      = 4'd9;
localparam [NB_STATE-1:0] START_WRITE_IM = 4'd10;

// External commands
localparam [NB_DATA-1:0] CMD_WRITE_IM       = 8'd1; // Escribir programa
localparam [NB_DATA-1:0] CMD_START          = 8'd2; // Ejecucion continua
localparam [NB_DATA-1:0] CMD_STEP_BY_STEP   = 8'd3; // Step-by-step
localparam [NB_DATA-1:0] CMD_SEND_BR        = 8'd4; // Leer bank register
localparam [NB_DATA-1:0] CMD_SEND_MEM       = 8'd5; // Leer data memory
localparam [NB_DATA-1:0] CMD_SEND_PC        = 8'd6; // Leer PC
localparam [NB_DATA-1:0] CMD_STEP           = 8'd7; // Send step
localparam [NB_DATA-1:0] CMD_CONTINUE       = 8'd8; // Continue execution >>


// FSM logic
reg [NB_STATE-1:0]      state,              next_state,     prev_state;

// INSTRUCTION MEMORY
reg [NB_ADDR-1:0]       im_count,           next_im_count;          // Address a escribir
reg                     im_write_enable,    next_im_write_enable;   // Flag que habilita la escritura del IM
reg                     im_enable,          next_im_enable;

// CONTROL UNIT
reg                     cu_enable,          next_cu_enable;

// Memory
always @(posedge i_clock) begin
    if(i_reset) begin
        state                   <= IDLE;
        next_state              <= IDLE;

        // INSTRUCTION MEMORY 
        im_write_enable         <= 1'b0;
        next_im_write_enable    <= 1'b0;
        im_enable               <= 1'b0;
        next_im_enable          <= 1'b0;
        im_count                <= 32'hfffffff;
        next_im_count           <= 32'hfffffff;

        // CONTROL UNIT
        cu_enable               <= 1'b0;
        next_cu_enable          <= 1'b0;
        
    end
    else begin
        state               <= next_state;
        // INSTRUCTION MEMORY
        im_write_enable     <= next_im_write_enable;
        im_enable           <= next_im_enable;
        im_count            <= next_im_count;
     
        // CONTROL UNIT
        cu_enable           <= next_cu_enable;
   
    end
end

// Next sate logic
always @(*) begin
    next_state              = state;



    // next_count_pc           = count_pc;
    // next_pc_enable          = pc_enable;

    next_im_enable          = im_enable;
    next_im_write_enable    = im_write_enable;
    next_im_count           = im_count;

    // next_send_data          = send_data;
    next_cu_enable          = cu_enable;


    prev_state              = IDLE;

    case(state)
        IDLE: begin


            next_im_enable       = 1'b0;
            next_im_write_enable = 1'b0;


            next_cu_enable       = 1'b0;
            // next_pc_enable       = 1'b0;

            // next_send_data      = 8'b0;

            if(i_rx_done) begin
                case (i_rx_data)
                    CMD_WRITE_IM:       next_state = START_WRITE_IM;
                    // CMD_STEP_BY_STEP:   next_state = STEP_BY_STEP; // borrar
                    // CMD_SEND_BR:begin
                    //     next_state = SEND_BR;
                    //     prev_state = IDLE;
                    // end
                    // CMD_SEND_PC:begin
                    //     next_state = SEND_PC;
                    //     prev_state = IDLE;
                    // end
                    // CMD_SEND_MEM:begin
                    //     next_state = SEND_MEM;
                    //     prev_state = IDLE;
                    // end
                    default: begin
                        next_state = IDLE;
                    end
                endcase
            end
            else begin
                next_state = IDLE;
            end
        end
        READY: begin
//            next_step = 1'b0;
            if(i_rx_done)begin
                case(i_rx_data)
                    CMD_STEP_BY_STEP:   next_state = STEP_BY_STEP;
                    CMD_START:          next_state = START;
                    default:            next_state = READY;
                endcase
            end
            else begin
                next_state = IDLE;
            end
        end

        START_WRITE_IM: begin
//            next_step   = 1'b0;
            next_state  = WRITE_IM;
        end
        WRITE_IM: begin
//            next_step = 1'b0;
            if(im_count == 32'd256)begin
                next_state              = READY;
                next_im_enable          = 1'b0;
                next_im_write_enable    = 1'b0;
                next_im_count           = 32'hfffffff;
            end
            else begin
                if(i_rx_done)begin
                    next_im_enable          = 1'b1;
                    next_im_write_enable    = 1'b1;
                    next_im_count           = im_count + 1;
                    next_state              = START_WRITE_IM;
                end
                else begin
                    next_im_enable          = 1'b0;
                    next_im_write_enable    = 1'b0;
                end
            end
        end

        default: begin
            next_state = IDLE;
        end
    endcase
end

// INSTRUCTION MEMORY
assign o_im_data            = i_rx_data;
assign o_im_write_enable    = im_write_enable;
assign o_im_addr            = im_count;
assign o_im_enable          = im_enable;

// STATE
assign o_state              = state;
// CONTROL UNIT
assign o_cu_enable          = cu_enable;

endmodule