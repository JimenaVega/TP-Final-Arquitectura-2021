`timescale 1ns / 1ps


//  Xilinx Simple Dual Port Single Clock RAM
//  This code implements a parameterizable SDP single clock memory.
//  If a reset or enable is not necessary, it may be tied off or removed from the code.

module data_memory#(
  parameter MEMORY_WIDTH = 8,              // Specify RAM data width
  parameter MEMORY_DEPTH = 128,              // Specify RAM depth (number of entries)
  parameter NB_ADDR = 7,
  parameter NB_DATA = 32,
  parameter RAM_PERFORMANCE = "LOW_LATENCY",// Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
  parameter INIT_FILE = ""       // Specify name/location of RAM initialization file if using one (leave blank if not)
) 
(
  input  i_clock,                            // Clock
  input  i_mem_write_flag,                   // Write enable
  input  i_mem_read_flag,                    // Output register enable
  input  i_word_en,
  input  i_halfword_en,
  input  i_byte_en,
  input  [NB_ADDR-1:0] i_address,       // Write and read address bus, width determined from RAM_DEPTH
  input  [NB_DATA-1:0] i_write_data,    // RAM input data
  output [NB_DATA-1:0] o_read_data      // RAM output data
);

  reg [MEMORY_WIDTH-1:0] BRAM [MEMORY_DEPTH-1:0];
  reg [NB_DATA-1:0] ram_data = {NB_DATA{1'b0}};
  
  
  generate
  integer ram_index;
  initial
    for (ram_index = 0; ram_index < MEMORY_DEPTH; ram_index = ram_index + 1)
      BRAM[ram_index] = {MEMORY_WIDTH{1'b0}};
  endgenerate


  always @(posedge i_clock) begin
    BRAM[17]   <= 8'd7; // borrar
    BRAM[18]   <= 8'd8; // borrar
    if (i_mem_write_flag)
      case ({i_word_en, i_halfword_en, i_byte_en})
        3'b001:
            BRAM[i_address]   <= i_write_data[7:0];
        3'b010:begin
            BRAM[i_address]   <= i_write_data[15:8];
            BRAM[i_address+1] <= i_write_data[7:0];
        end
        3'b100:begin
            BRAM[i_address]   <= i_write_data[31:24];
            BRAM[i_address+1] <= i_write_data[23:16];
            BRAM[i_address+2] <= i_write_data[15:8];
            BRAM[i_address+3] <= i_write_data[7:0];
        end
        default: BRAM[i_address] <= i_write_data;
      endcase
    if (i_mem_read_flag)
      case ({i_word_en, i_halfword_en, i_byte_en})
        3'b001:begin
            ram_data[31:24] <= 8'b0;
            ram_data[23:16] <= 8'b0;
            ram_data[15:8]  <= 8'b0;
            ram_data[7:0]   <= BRAM[i_address];
        end      
        3'b010:begin
            ram_data[31:24] <= 8'b0;
            ram_data[23:16] <= 8'b0;
            ram_data[15:8]  <= BRAM[i_address];
            ram_data[7:0]   <= BRAM[i_address+1];
        end
        3'b100:begin
            ram_data[31:24] <= BRAM[i_address];
            ram_data[23:16] <= BRAM[i_address+1];
            ram_data[15:8]  <= BRAM[i_address+2];
            ram_data[7:0]   <= BRAM[i_address+3];
        end
        default: ram_data <= BRAM[i_address];
      endcase
  end

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign o_read_data = ram_data;

    end
  endgenerate


endmodule