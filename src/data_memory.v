`timescale 1ns / 1ps

module data_memory#(
  parameter MEMORY_WIDTH = 32,              // RAM data width
  parameter MEMORY_DEPTH = 32,              // RAM depth (number of entries)
  parameter NB_ADDR = 5,
  parameter NB_DATA = 32
) 
(
  input                 	i_clock,        // Clock
  input                 	i_enable,       // Mem enable
  input                 	i_mem_write, 	// Write enable
  input                 	i_mem_read,  	// Read enable
  input  [NB_ADDR-1:0]  	i_address,   	// Write and read address bus
  input  [NB_DATA-1:0]  	i_write_data,   // RAM input data
  output [NB_DATA-1:0]  	o_read_data     // RAM output data
);

	reg [MEMORY_WIDTH-1:0] BRAM [MEMORY_DEPTH-1:0];
	reg [NB_DATA-1:0] ram_data = {NB_DATA{1'b0}};
	reg [MEMORY_WIDTH-1:0] byte_data = {MEMORY_WIDTH{1'b0}};

	generate
		integer ram_index;
		initial
			for (ram_index = 0; ram_index < MEMORY_DEPTH; ram_index = ram_index + 1)
				BRAM[ram_index] = {MEMORY_WIDTH{1'b0}};
	endgenerate


	always @(posedge i_clock) begin
		if(i_enable) begin
			if(i_mem_write)
				BRAM[i_address] <= i_write_data;
			else
				BRAM[i_address] <= BRAM[i_address];

			if(i_mem_read)
				o_read_data		<= BRAM[i_address];
			else
				o_read_data		<= 32'b0;
		end
	end

	assign o_read_data = ram_data;

endmodule