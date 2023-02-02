`timescale 1ns / 1ps


//  Xilinx Simple Dual Port Single Clock RAM
//  This code implements a parameterizable SDP single clock memory.
//  If a reset or enable is not necessary, it may be tied off or removed from the code.

module data_memory#(
  parameter MEMORY_WIDTH = 32,              // Specify RAM data width
  parameter MEMORY_DEPTH = 128,              // Specify RAM depth (number of entries)
  parameter NB_ADDR = 7,
  parameter RAM_PERFORMANCE = "LOW_LATENCY",// Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
  parameter INIT_FILE = "C:/Users/alejo/Downloads/data.mem"       // Specify name/location of RAM initialization file if using one (leave blank if not)
) 
(
  input [NB_ADDR-1:0] i_write_addr,         // Write address bus, width determined from RAM_DEPTH
  input [NB_ADDR-1:0] i_read_addr,          // Read address bus, width determined from RAM_DEPTH
  input [MEMORY_WIDTH-1:0] i_data,          // RAM input data
  input i_clock,                            // Clock
  input i_write_enable,                     // Write enable
  input i_read_enable,                      // Read Enable, for additional power savings, disable when not in use
  input rstb,                               // Output reset (does not affect memory contents)
  input regceb,                             // Output register enable
  output [MEMORY_WIDTH-1:0] o_data          // RAM output data
);

  reg [MEMORY_WIDTH-1:0] BRAM [MEMORY_DEPTH-1:0];
  reg [MEMORY_WIDTH-1:0] ram_data = {MEMORY_WIDTH{1'b0}};

  // The following code either initializes the memory values to a specified file or to all zeros to match hardware
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
    if (i_write_enable)
      BRAM[i_write_addr] <= i_data;
    if (i_read_enable)
      ram_data <= BRAM[i_read_addr];
  end

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign o_data = ram_data;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [MEMORY_WIDTH-1:0] doutb_reg = {MEMORY_WIDTH{1'b0}};

      always @(posedge i_clock)
        if (rstb)
          doutb_reg <= {MEMORY_WIDTH{1'b0}};
        else if (regceb)
          doutb_reg <= ram_data;

      assign o_data = doutb_reg;

    end
  endgenerate


endmodule