`timescale 1ns / 1ps

module tb_instruction_memory();

    parameter MEMORY_WIDTH = 32;
    parameter MEMORY_DEPTH = 64;
    parameter NB_ADDR = 6;
    
    reg [NB_ADDR-1:0] write_addr;
    reg [NB_ADDR-1:0] read_addr;
    reg [MEMORY_WIDTH-1:0] data;
    reg clock;
    reg write_enable;
    reg read_enable;
    reg rstb;
    reg regceb;
    wire [MEMORY_WIDTH-1:0] o_data;
    
    initial begin
    
        clock = 1'b0;
        write_enable = 1'b0;
        read_enable = 1'b0;
        rstb = 1'b0;
        regceb = 1'b0;
        write_addr = 6'd0;
        read_addr = 6'd0;
        data = 32'd0;
        
        // Se escriben datos en la memoria
        #40
        data = 32'd10;
        write_addr = 6'd0;
        write_enable = 1'b1;
        #40
        data = 32'd20;
        write_addr = 6'd1;
        #40
        data = 32'd30;
        write_addr = 6'd2;
        #40
        data = 32'd40;
        write_addr = 6'd5;
        
        #20
        write_enable = 1'b0;
        
        // Se leen datos de la memoria
        #40
        read_addr = 6'd0;
        read_enable = 1'b1;
        #40
        read_addr = 6'd1;
        #40
        read_addr = 6'd2;
        #40
        read_addr = 6'd5;
        
        #20
        read_enable = 1'b0;
        
        #200
        
        $finish;
    
    end
    
    always #10 clock = ~clock;
    
    instruction_memory instruction_memory(.i_write_addr(write_addr),
                                          .i_read_addr(read_addr),
                                          .i_data(data),
                                          .i_clock(clock),
                                          .i_write_enable(write_enable),
                                          .i_read_enable(read_enable),
                                          .rstb(rstb),
                                          .regceb(regceb),
                                          .o_data(o_data)
                                          );

endmodule
