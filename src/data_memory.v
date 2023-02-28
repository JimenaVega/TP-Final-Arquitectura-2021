`timescale 1ns / 1ps


//  Xilinx Simple Dual Port Single Clock RAM
//  This code implements a parameterizable SDP single clock memory.
//  If a reset or enable is not necessary, it may be tied off or removed from the code.

module data_memory#(
  parameter MEMORY_WIDTH = 32,              // Specify RAM data width
  parameter MEMORY_DEPTH = 128,              // Specify RAM depth (number of entries)
  parameter NB_ADDR = 7,
  parameter RAM_PERFORMANCE = "LOW_LATENCY",// Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
  parameter INIT_FILE = ""       // Specify name/location of RAM initialization file if using one (leave blank if not)
) 
(
  input  i_clock,                            // Clock
  input  i_mem_write_flag,                   // Write enable
  input  i_mem_read_flag,                    // Read Enable, for additional power savings, disable when not in use
  input  rstb,                               // Output reset (does not affect memory contents)
  input  regceb,                             // Output register enable
  input  [NB_ADDR-1:0]      i_address,       // Write and read address bus, width determined from RAM_DEPTH
  input  [MEMORY_WIDTH-1:0] i_write_data,    // RAM input data
  output [MEMORY_WIDTH-1:0] o_read_data           // RAM output data
);

  reg [MEMORY_WIDTH-1:0] BRAM [MEMORY_DEPTH-1:0];
  reg [MEMORY_WIDTH-1:0] ram_data = {MEMORY_WIDTH{1'b0}};


  always @(posedge i_clock) begin
    if (i_mem_write_flag)
      BRAM[i_address] <= i_write_data;
    if (i_mem_read_flag)
      ram_data <= BRAM[i_address];
  end

  //  The following code generates HIGH_PERFORMANCE (use output register) or LOW_LATENCY (no output register)
  generate
    if (RAM_PERFORMANCE == "LOW_LATENCY") begin: no_output_register

      // The following is a 1 clock cycle read latency at the cost of a longer clock-to-out timing
       assign o_read_data = ram_data;

    end else begin: output_register

      // The following is a 2 clock cycle read latency with improve clock-to-out timing

      reg [MEMORY_WIDTH-1:0] doutb_reg = {MEMORY_WIDTH{1'b0}};

      always @(posedge i_clock)
        if (rstb)
          doutb_reg <= {MEMORY_WIDTH{1'b0}};
        else if (regceb)
          doutb_reg <= ram_data;

      assign o_read_data = doutb_reg;

    end
  endgenerate


endmodule