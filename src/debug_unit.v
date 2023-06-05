`timescale 1ns / 1ps

module debug_unit#(
    parameter NB_STATE    = 5,
    parameter NB_DATA     = 8,
    parameter NB_SIZE     = 16, // 2B x 8 b, el tamaño de los datos a recibir en bits
    parameter N_SIZE      = 2,  // 2B de frame para obtener el total de los datos (size)
    parameter NB_ADDR     = 32,
    parameter NB_ADDR_RB  = 5,
    parameter NB_BYTE_CTR = 2,
    parameter NB_ADDR_DM  = 7, 
    parameter BR_SIZE     = 32,
    parameter DM_DEPTH    = 128,
    parameter RB_DEPTH    = 32,
    parameter IM_DEPTH    = 256,
    parameter NB_PC_CTR   = 2
)    
(
    input                   i_clock,
    input                   i_reset,
    input                   i_hlt,          // proveniente del DATAPATH
    input                   i_rx_done,      // meaning: RX tiene un byte listo para ser leido - UART
    input                   i_tx_done,      // meaning: TX ya envio el byte - UART
    input  [NB_DATA-1:0]    i_rx_data,      // from RX - UART

    input  [NB_ADDR-1:0]    i_pc_value,     // data read from PC 
    input  [NB_DATA-1:0]    i_dm_data,      // data read from DATA MEMORY
    input  [NB_ADDR-1:0]    i_br_data,      // data read from BANK REGISTER
    output [NB_DATA-1:0]    o_im_data,      // data to write in INSTRUCTION MEMORY

    output [NB_ADDR-1:0]    o_im_addr,      // address to write INSTRUCTION MEMORY
    output [NB_ADDR_RB-1:0] o_rb_addr,      // address to read BANK REGISTER
    output [NB_ADDR_DM-1:0] o_dm_addr,      // address to read DATA MEMORY

    output [NB_DATA-1:0]    o_tx_data,      // to TX - UART
    output                  o_tx_start,     // to TX - UART

    output                  o_im_write_enable,
    output                  o_im_enable,
    output                  o_rb_read_enable,
    output                  o_rb_enable,
    output                  o_dm_enable,
    output                  o_dm_read_enable,
    output                  o_cu_enable,
    output                  o_pc_enable,

    output                  o_step_flag,
    output                  o_step
);

// States
localparam [NB_STATE-1:0] IDLE         = 5'd1;
localparam [NB_STATE-1:0] WRITE_IM     = 5'd2;
localparam [NB_STATE-1:0] READY        = 5'd4;
localparam [NB_STATE-1:0] START        = 5'd5;
localparam [NB_STATE-1:0] STEP_BY_STEP = 5'd6;
localparam [NB_STATE-1:0] SEND_BR      = 5'd7;
localparam [NB_STATE-1:0] SEND_MEM     = 5'd8;
localparam [NB_STATE-1:0] SEND_PC      = 5'd9;
localparam [NB_STATE-1:0] START_WRITE_IM = 5'd10;

// External commands
localparam [NB_DATA-1:0] CMD_WRITE_IM       = 8'd1;
localparam [NB_DATA-1:0] CMD_START          = 8'd2; // Ejecucion continua
localparam [NB_DATA-1:0] CMD_STEP_BY_STEP   = 8'd3;
localparam [NB_DATA-1:0] CMD_SEND_BR        = 8'd4;
localparam [NB_DATA-1:0] CMD_SEND_MEM       = 8'd5;
localparam [NB_DATA-1:0] CMD_SEND_PC        = 8'd6;
localparam [NB_DATA-1:0] CMD_STEP           = 8'd7;

localparam [NB_DATA-1:0] CMD_CONTINUE       = 8'd8;


// FSM logic
reg [NB_STATE-1:0]      state,              next_state,     prev_state;

// INSTRUCTION MEMORY
reg [NB_ADDR-1:0]       im_count,           next_im_count;          // Address a escribir
reg                     im_write_enable,    next_im_write_enable;   // Flag que habilita la escritura del IM
reg                     im_enable,          next_im_enable;

// DATA MEMORY
reg [NB_ADDR_DM-1:0]    count_dm_tx_done,   count_dm_tx_done_next;  // Address
reg                     dm_read_enable;
reg                     dm_enable;

// BANK REGISTER
reg [NB_ADDR_RB-1:0]    count_br_tx_done,   next_count_br_tx_done; 
reg [NB_BYTE_CTR-1:0]   count_br_byte,      next_count_br_byte;     // cuenta hasta 4 bytes
reg                     rb_read_enable;
reg                     rb_enable;

// PC
reg [NB_PC_CTR-1:0]     count_pc,           next_count_pc;
reg                     pc_enable;

// CONTROL UNIT
reg                     cu_enable;

// TX
reg [NB_DATA-1:0]       send_data;         // DM & BR -> TX
reg                     tx_start,           tx_start_next;

// STEPPER
reg                     step_flag;
reg                     step;

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
        im_count                <= 32'hffffffff;
        next_im_count           <= 32'hffffffff;

        // DATA MEMORY
        count_dm_tx_done        <= 7'b0;
        count_dm_tx_done_next   <= 7'b0;
        dm_enable               <= 1'b0;
        dm_read_enable          <= 1'b0;

        // REGISTERS BANK
        count_br_tx_done        <= 5'b0;
        next_count_br_tx_done   <= 5'b0;
        count_br_byte           <= 2'b0;
        next_count_br_byte      <= 2'b0;
        rb_enable               <= 1'b0;
        rb_read_enable          <= 1'b0;

        // PC
        count_pc                <= 2'b0;
        next_count_pc           <= 2'b0;
        
        // TX
        send_data               <= 1'b0;
        tx_start                <= 1'b0;
        tx_start_next           <= 1'b0;

        // STEPPER
        step_flag               <= 1'b0;
        step                    <= 1'b0;
    end
    else begin
        state               <= next_state;
        // INSTRUCTION MEMORY
        im_write_enable     <= next_im_write_enable;
        im_enable           <= next_im_enable;
        im_count            <= next_im_count;
        // DATA MEMORY
        count_dm_tx_done    <= count_dm_tx_done_next;
        // REGISTERS BANK
        count_br_byte       <= next_count_br_byte;
        count_br_tx_done    <= next_count_br_tx_done;
        tx_start            <= tx_start_next;
        // PC
        count_pc            <= next_count_pc;
        step_flag           <= step_flag;
        step                <= step;
    end
end

// Next sate logic
always @(*) begin
    next_state              = state;
    count_dm_tx_done_next   = count_dm_tx_done;
    next_count_br_byte      = count_br_byte;
    next_count_br_tx_done   = count_br_tx_done;
    next_count_pc           = count_pc;
    next_im_enable          = im_enable;
    next_im_write_enable    = im_write_enable;

    case(state)
        IDLE: begin
            step_flag   = 1'b0;
            step        = 1'b0;

            im_enable       = 1'b0;
            im_write_enable = 1'b0;
            rb_enable       = 1'b0;
            rb_read_enable   = 1'b0;
            dm_enable       = 1'b0;
            dm_read_enable  = 1'b0;
            cu_enable       = 1'b0;
            pc_enable       = 1'b0;

            if(i_rx_done) begin
                case (i_rx_data)
                    CMD_WRITE_IM:       next_state = START_WRITE_IM;
                    CMD_STEP_BY_STEP:   next_state = STEP_BY_STEP; // borrar
                    CMD_SEND_BR:begin
                        next_state = SEND_BR;
                        prev_state = IDLE;
                    end
                    CMD_SEND_PC:begin
                        next_state = SEND_PC;
                        prev_state = IDLE;
                    end
                    CMD_SEND_MEM:begin
                        next_state = SEND_MEM;
                        prev_state = IDLE;
                    end
                endcase
            end
        end
        READY: begin
            step = 1'b0;
            if(i_rx_done)begin
                case(i_rx_data)
                    CMD_STEP_BY_STEP:   next_state = STEP_BY_STEP;
                    CMD_START:          next_state = START;
                endcase
            end
        end
        START: begin
            step_flag       = 1'b0;
            step            = 1'b0;

            im_enable       = 1'b1;
            im_write_enable = 1'b0;
            rb_enable       = 1'b1;
            rb_read_enable   = 1'b1;
            dm_enable       = 1'b1;
            dm_read_enable  = 1'b1;
            cu_enable       = 1'b1;
            pc_enable       = 1'b1;

            if(i_hlt)begin
                next_state = IDLE;
            end
        end
        STEP_BY_STEP: begin
            step_flag   = 1'b1;
            step        = 1'b0;

            im_enable       = 1'b1;
            im_write_enable = 1'b0;
            rb_enable       = 1'b1;
            rb_read_enable   = 1'b1;
            dm_enable       = 1'b1;
            dm_read_enable  = 1'b1;
            cu_enable       = 1'b1;
            pc_enable       = 1'b1;

            if(i_rx_done)begin
                case (i_rx_data)
                    CMD_STEP: begin
                        next_state  = SEND_PC;
                        prev_state  = STEP_BY_STEP;
                        step        = 1'b1;
                    end       
                    CMD_CONTINUE: next_state = START;
                endcase
            end

            if(i_hlt)begin
                next_state = IDLE;
            end
        end
        START_WRITE_IM: begin
            step        = 1'b0;
            next_state  = WRITE_IM;
        end
        WRITE_IM: begin
            step = 1'b0;
            if(im_count == 32'd256)begin
                next_state              = READY;
                next_im_enable          = 1'b0;
                next_im_write_enable    = 1'b0;
                next_im_count           = 32'hffffffff;
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
        SEND_PC: begin
            tx_start_next   = 1'b1;
            step            = 1'b0;
            case(count_pc)
                2'd0:   send_data = i_pc_value[31:24];
                2'd1:   send_data = i_pc_value[23:16];
                2'd2:   send_data = i_pc_value[15:8];
                2'd3:   send_data = i_pc_value[7:0];
            endcase

            if(i_tx_done)begin
                next_count_pc = count_pc + 1;

                if(count_pc == 2'd3)begin
                    tx_start_next   = 1'b0;
                    if(prev_state == STEP_BY_STEP)begin
                        next_state = SEND_MEM;
                    end
                    else begin
                        next_state = IDLE;
                    end
                end
            end
        end
        SEND_BR: begin
            rb_read_enable  = 1'b1;
            rb_enable       = 1'b0;
            tx_start_next   = 1'b1;
            step            = 1'b0;
            case(next_count_br_byte)
                2'd0:   send_data = i_br_data[31:24];
                2'd1:   send_data = i_br_data[23:16];
                2'd2:   send_data = i_br_data[15:8];
                2'd3:   send_data = i_br_data[7:0];
            endcase

            if(i_tx_done)begin
                next_count_br_byte = count_br_byte + 1;

                if(count_br_byte == 2'd3)begin
                    next_count_br_tx_done   = count_br_tx_done + 1;
                    next_count_br_byte      = 2'd0;

                    if(count_br_tx_done == RB_DEPTH-1)begin
                        rb_read_enable  = 1'b0;
                        rb_enable       = 1'b0;
                        tx_start_next   = 1'b0;

                        next_state      = prev_state;
                    end
                end
            end
        end
        SEND_MEM: begin
            dm_read_enable  = 1'b1;
            dm_enable       = 1'b1;
            tx_start_next   = 1'b1;
            send_data       = i_dm_data;
            step            = 1'b0;

            if(i_tx_done)begin
                count_dm_tx_done_next = count_dm_tx_done + 1;

                if(count_dm_tx_done == DM_DEPTH-1)begin
                    dm_read_enable  = 1'b0;
                    dm_enable       = 1'b0;
                    tx_start_next   = 1'b0;
                    if(prev_state == STEP_BY_STEP) begin
                        next_state = SEND_BR;
                    end
                    else begin
                        next_state      = IDLE;
                    end
                end
            end
        end
    endcase
end

// INSTRUCTION MEMORY
assign o_im_data            = i_rx_data;
assign o_im_write_enable    = im_write_enable;
assign o_im_addr            = im_count;
assign o_im_enable          = im_enable;

// DATA MEMORY
assign o_dm_addr            = count_dm_tx_done; // Cada vez que haya un tx_done, se avanza +1 address
assign o_dm_enable          = dm_enable;
assign o_dm_read_enable     = dm_read_enable;

// REGISTER BANK
assign o_rb_addr            = count_br_tx_done;
assign o_rb_enable          = rb_enable;
assign o_rb_read_enable     = rb_read_enable;

// PC
assign o_pc_enable          = pc_enable;

// CONTROL UNIT
assign o_cu_enable          = cu_enable;

// TX
assign o_tx_data            = send_data;
assign o_tx_start           = tx_start;

// STEPPER
assign o_step_flag          = step_flag;
assign o_step               = step;

endmodule