`timescale 1ns / 1ps

module tb_sign_extend();

    parameter NB_IN = 16;
    parameter NB_OUT = 32;
    
    reg [NB_IN-1:0] i_data;
   
    wire [NB_OUT-1:0] o_data;
    
    initial begin
    
        i_data = 16'd7;
        
        #40
        i_data = 16'd57;
        
        #40
        i_data = 16'd273;
        
        #200
        
        $finish;
    
    end
    
    sign_extend sign_extend(.i_data(i_data),
                            .o_data(o_data)
                            );

endmodule