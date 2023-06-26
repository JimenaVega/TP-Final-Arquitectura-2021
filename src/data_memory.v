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
	// reg [MEMORY_WIDTH-1:0] byte_data = {MEMORY_WIDTH{1'b0}};

	generate
		integer ram_index;
		initial
			for (ram_index = 0; ram_index < MEMORY_DEPTH; ram_index = ram_index + 1)
				BRAM[ram_index] = {MEMORY_WIDTH{1'b0}};
	endgenerate


	always@(posedge i_clock) begin
	    // BRAM[0] <= 32'h8ff0ff01;
	    // BRAM[1] <= 32'h20;
	    // BRAM[2] <= 32'h100;
		BRAM[31] <= 32'haabbcc01;
		if(i_enable) begin
			// Escritura
			// BRAM[0] = 32'hff010203f; //BORRAR
			if(i_mem_write) begin
				BRAM[i_address] <= i_write_data;
			end	
			else begin
				BRAM[i_address] <= BRAM[i_address];
			end
			
			// Lectura
			if(i_mem_read) begin
				ram_data		<= BRAM[i_address];
			end
			else begin
				ram_data		<= 32'b0;
			end
		end
	end

	assign o_read_data = ram_data;

endmodule