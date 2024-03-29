`timescale 1ns / 1ps

module instruction_memory#(
  parameter MEMORY_WIDTH = 8,              // Specify RAM data width
  parameter MEMORY_DEPTH = 256,              // Specify RAM depth (number of entries)
  parameter NB_ADDR_DEPTH = 8,
  parameter NB_ADDR = 32,
  parameter NB_INSTRUCTION = 32,
  parameter RAM_PERFORMANCE = "LOW_LATENCY",// Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
//  parameter INIT_FILE = "C:/Users/alejo/OneDrive/Documents/GitHub/TP-Final-Arquitectura-2021/translator/instructions.mem"
  parameter INIT_FILE = ""
  ) 
(
  input                       i_clock,
  input                       i_enable,       // Debug Unit Control                            
  input                       i_read_enable,  
  input                       i_write_enable, // Debug Unit Control   
  input  [MEMORY_WIDTH-1:0]   i_write_data,   // Debug Unit Control
  input  [NB_ADDR_DEPTH-1:0]  i_write_addr,   // Debug Unit Control
  input  [NB_ADDR-1:0]        i_addr,         // Read address bus, width determined from RAM_DEPTH
  output [NB_INSTRUCTION-1:0] o_read_data     // RAM output data
);

  reg [MEMORY_WIDTH-1:0] BRAM [MEMORY_DEPTH-1:0];
  reg [NB_INSTRUCTION-1:0] ram_data = {NB_INSTRUCTION{1'b0}};

  generate
    if (INIT_FILE != "") begin: use_init_file
      initial
        $readmemb(INIT_FILE, BRAM, 0, MEMORY_DEPTH-1);
    end else begin: init_bram_to_zero
      integer ram_index;
      initial
        for (ram_index = 0; ram_index < MEMORY_DEPTH; ram_index = ram_index + 1)
          BRAM[ram_index] = {MEMORY_WIDTH{1'b0}};
    end
  endgenerate

  always @(posedge i_clock) begin
    if(i_enable) begin
		if (i_read_enable) begin
			ram_data[31:24] <= BRAM[i_addr];
			ram_data[23:16] <= BRAM[i_addr+1];
			ram_data[15:8]  <= BRAM[i_addr+2];
			ram_data[7:0]   <= BRAM[i_addr+3];
		end
		else begin
			ram_data <= {NB_INSTRUCTION{1'b0}};
		end
		
		if(i_write_enable) begin
			// Solo usado desde debug unit
			BRAM[i_write_addr]   <= i_write_data;
		end
    end
  end

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign o_read_data = ram_data;
    end
  endgenerate
endmodule						