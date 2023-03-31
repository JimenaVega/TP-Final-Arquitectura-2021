`timescale 1ns / 1ps

module registers_bank#(
        parameter   NB_DATA     =   32,
        parameter   NB_ADDR     =   5,
        parameter   BANK_DEPTH  =   32 // 32 Registros diferentes
    )
    (
        input               i_clock,
        input               i_reset,
        input               i_reg_write,  // Señal de control RegWrite proveniente de WB
        input               i_jr_jalr,
        input [NB_ADDR-1:0] i_read_reg_a,
        input [NB_ADDR-1:0] i_read_reg_b,
        input [NB_ADDR-1:0] i_write_reg,  // Address 
        input [NB_DATA-1:0] i_write_data, // Data
              
        output [NB_DATA-1:0] o_data_a,
        output [NB_DATA-1:0] o_data_b 
    );
    
    reg [NB_DATA-1:0] o_data_a_next;
    reg [NB_DATA-1:0] o_data_b_next;
    
    reg [NB_DATA-1:0]  registers [BANK_DEPTH-1:0];
    
    always@(posedge i_clock)begin
        if(i_reset)begin:reset
            integer reg_index;
            
            for (reg_index = 0; reg_index < BANK_DEPTH; reg_index = reg_index + 1)
              registers[reg_index] = {NB_DATA{1'b0}};
              
            o_data_a_next  =  {NB_DATA{1'b0}};
            o_data_b_next  =  {NB_DATA{1'b0}};
        end 
        else begin
            // Lectura de registros
            if(i_jr_jalr)begin
                o_data_a_next <= registers[5'd31]; // Lectura de r31 
            end
            else begin
                o_data_a_next <= registers[i_read_reg_a];
            end
            
            o_data_b_next <= registers[i_read_reg_b];
            
            // Escritura de registros
            if(i_reg_write)
                registers[i_write_reg] <= i_write_data;
        end
    end
    
    assign o_data_a = o_data_a_next;
    assign o_data_b = o_data_b_next;
    
endmodule