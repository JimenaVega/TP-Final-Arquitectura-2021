//`timescale 1ns / 1ps

//module dummy_db_unit#(
//    parameter NB_STATE    = 4,
//    parameter N_BYTES     = 4, // Cantidad de bytes de una sola instruccion
//    parameter NB_DATA     = 8,
//    parameter NB_SIZE     = 16, // 2B x 8 b, el tamaño de los datos a recibir en bits
//    parameter N_SIZE      = 2,  // 2B de frame para obtener el total de los datos (size)
//    parameter NB_ADDR     = 32,
//    parameter NB_ADDR_RB  = 5,
//    parameter NB_BYTE_CTR = 2,
//    parameter NB_ADDR_DM  = 5, 
//    parameter BR_SIZE     = 32,
//    parameter DM_DEPTH    = 32,
//    parameter DM_WIDTH    = 32,
//    parameter RB_DEPTH    = 32,
//    parameter IM_DEPTH    = 256,
//    parameter IM_WIDTH    = 32, // TODO: change IM width
//    parameter NB_PC_CTR   = 2
//)    
//(
//    input                   i_clock,
//    input                   i_reset,

//    input                   i_rx_done,      // meaning: RX tiene un byte listo para ser leido - UART
//    input  [NB_DATA-1:0]    i_rx_data,      // from RX - UART

//    output [IM_WIDTH-1:0]   o_im_data,      // *  data to write in INSTRUCTION MEMORY
//    output [NB_ADDR-1:0]    o_im_addr,      //  * address to write INSTRUCTION MEMORY
//    output                  o_im_write_enable, //*
//    output                  o_im_enable, //*
//    output                  o_cu_enable,
//    output [NB_STATE-1:0]   o_state
//);

//// States
//localparam [NB_STATE-1:0] IDLE         = 4'd1;
//localparam [NB_STATE-1:0] RECEIVE_INST = 4'd2; // new
//localparam [NB_STATE-1:0] WRITE_IM     = 4'd3; // new
//localparam [NB_STATE-1:0] READY        = 4'd4;
//// localparam [NB_STATE-1:0] START        = 4'd5;
//// localparam [NB_STATE-1:0] STEP_BY_STEP = 4'd6;
//// localparam [NB_STATE-1:0] SEND_BR      = 4'd7;
//// localparam [NB_STATE-1:0] SEND_MEM     = 4'd8;
//// localparam [NB_STATE-1:0] SEND_PC      = 4'd9;
//// localparam [NB_STATE-1:0] START_WRITE_IM = 4'd10;

//// External commands
//localparam [NB_DATA-1:0] CMD_WRITE_IM       = 8'd1; // Escribir programa
//localparam [NB_DATA-1:0] CMD_START          = 8'd2; // Ejecucion continua
//localparam [NB_DATA-1:0] CMD_STEP_BY_STEP   = 8'd3; // Step-by-step
//localparam [NB_DATA-1:0] CMD_SEND_BR        = 8'd4; // Leer bank register
//localparam [NB_DATA-1:0] CMD_SEND_MEM       = 8'd5; // Leer data memory
//localparam [NB_DATA-1:0] CMD_SEND_PC        = 8'd6; // Leer PC
//localparam [NB_DATA-1:0] CMD_STEP           = 8'd7; // Send step
//localparam [NB_DATA-1:0] CMD_CONTINUE       = 8'd8; // Continue execution >>


//// FSM logic
//reg [NB_STATE-1:0]      state,              next_state;

//// INSTRUCTION MEMORY
//reg [NB_ADDR-1:0]       im_count,           next_im_count;          // Address a escribir
//reg                     im_write_enable,    next_im_write_enable;   // Flag que habilita la escritura del IM
//reg                     im_enable,          next_im_enable;
//// new
//reg read_byte_en, received_full_inst, send_inst_en;
//reg [IM_WIDTH-1:0] instruction;
//reg [NB_DATA-1:0] count_bytes;
//// CONTROL UNIT
//reg                     cu_enable,          next_cu_enable;

//// Memory
//always @(posedge i_clock) begin
//    if(i_reset) begin
//        state                   <= IDLE;
//        next_state              <= IDLE;
        
//    end
//    else begin
//        state               <= next_state;

   
//    end
//end

//// Next sate logic
//always @(*) begin
//    next_state              = state;


//    case(state)
//        IDLE: begin
//            if(i_rx_done) begin
//                case (i_rx_data)
//                    CMD_WRITE_IM:       next_state = RECEIVE_INST;
//                    // CMD_STEP_BY_STEP:   next_state = STEP_BY_STEP; // borrar
//                    // CMD_SEND_BR:begin
//                    //     next_state = SEND_BR;
//                    //     prev_state = IDLE;
//                    // end
//                    // CMD_SEND_PC:begin
//                    //     next_state = SEND_PC;
//                    //     prev_state = IDLE;
//                    // end
//                    // CMD_SEND_MEM:begin
//                    //     next_state = SEND_MEM;
//                    //     prev_state = IDLE;
//                    // end
//                    default: begin
//                        next_state = IDLE;
//                    end
//                endcase
//            end
//            else begin
//                next_state = IDLE;
//            end
//        end

//        RECEIVE_INST: begin
//            next_state   = RECEIVE_INST;
//            // read_byte_en = 1'b1;

//            if(received_full_inst) begin // 4bytes ready
//                next_state = WRITE_IM;
//                send_inst_en = 1'b1;
//                im_write_enable = 1'b1; // ver de usar next
//                im_enable = 1'b1;     // ver de usar next
//            end
//        end
//        WRITE_IM: begin
//            send_inst_en = 1'b0;
//            if(bit_finish) begin
//                next_state = IDLE; // TODO: Cambiar a READY
//            end
//            else begin
//                // ack_debug_o = 1'b1; // ver
//                next_state = RECEIVE_INST;
//            end
//         end


//        default: begin
//            next_state = IDLE;
//        end
//    endcase
//end

///* +++++++++++++++ LOAD INSTRUCTION MEMORY +++++++++++++++ */
//always @(posedge clock_i)
//begin
//    if (i_reset)
//        instruction <= 0;
//        received_full_inst <= 1'b0;
//        count_bytes <= 8'b0;

//        im_count <= 0; // Para IM address
//        bit_finish <= 1'b0;
   

//    else begin
//        // Guardado 
//        if (i_rx_done) begin

//            instruction <= { i_rx_data, instruction[31:8]};
            
//            if(count_bytes == N_BYTES-1) begin
//                count_bytes <= 8'b0;
//                received_full_inst <= 1'b1;
//            end
//            else begin
//                count_bytes <= count_bytes + 1;
//                received_full_inst <= 1'b0;
//            end
//        end
//        else begin 
//            instruction <= instruction;
//            count_bytes <= count_bytes;
//            received_full_inst <= 1'b0;
//        end    
        
//        // Contador que determina la direccion a escribir de IM
//        if(send_inst_en)begin
//           if (im_count == 32) begin // TODO: CAMBIAR PROFUNDIDAD DE IM Y CAMBIARLA A 32B de WIDTH
//                bit_finish <= 1'b1;
//                im_count <= 0;
//           end
//           else begin
//                bit_finish <= 1'b0;
//                im_count <= im_count + 1;
//           end
//        end
//        else begin
//            bit_finish <= bit_finish;
//            im_count <= im_count;
//        end
//    end    			



            
//            // if(send_inst_en) begin
//            //     if(im_count == 255) begin
//            //         bit_finish <= 1'b1;
//            //     end
//            // end    

//        end
//end

//// INSTRUCTION MEMORY
//assign o_im_data            = instruction; //new
//assign o_im_write_enable    = im_write_enable;
//assign o_im_enable          = im_enable;
//assign o_im_addr            = im_count;


//// STATE
//assign o_state              = state;
//// CONTROL UNIT
//assign o_cu_enable          = cu_enable;

//endmodule