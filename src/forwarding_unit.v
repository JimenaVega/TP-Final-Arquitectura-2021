`timescale 1ns / 1ps

module forwarding_unit #(
        parameter NB_REG    = 5,
        parameter NB_MUX    = 2
    )    
    (   
        input                      i_reset,
        input       [NB_REG-1 : 0] i_EX_MEM_rd,
        input       [NB_REG-1 : 0] i_MEM_WB_rd,
        input       [NB_REG-1 : 0] i_rt, // data_b
        input       [NB_REG-1 : 0] i_rs, // data_a
        input                      i_EX_mem_write,  // Hay: SW,SH,SB
        input                      i_MEM_write_reg,
        input                      i_WB_write_reg,
        output reg  [NB_MUX-1:0]   o_forwarding_a,
        output reg  [NB_MUX-1:0]   o_forwarding_b,
        output reg  [NB_MUX-1:0]   o_forwarding_mux_12
    );
    always@(*) begin
        if(i_reset) begin
            o_forwarding_a = 2'b0;
            o_forwarding_b = 2'b0;
            o_forwarding_mux_12 = 2'b10; // Dato normal
        end
        else begin
            if((i_MEM_write_reg == 0) && (i_WB_write_reg==0)) begin
                o_forwarding_a = 2'b0;
                o_forwarding_b = 2'b0;
                o_forwarding_mux_12 = 2'b10; // Dato normal
            end
            // Operando A
            if((i_EX_MEM_rd == i_rs) && i_MEM_write_reg) begin
                o_forwarding_a      = 2'b01; // El dato viene de MEM
                o_forwarding_mux_12 = 2'b10; // Dato normal
            end
            else if ((i_MEM_WB_rd == i_rs) && i_WB_write_reg) begin
                o_forwarding_a      = 2'b10; // El dato viene de WB
                o_forwarding_mux_12 = 2'b10; // Dato normal
            end
            else begin
                o_forwarding_a      = 2'b0;  // No hay forwarding para A
                o_forwarding_mux_12 = 2'b10; // Dato normal
            end
            
            // Operando B
            if((i_EX_MEM_rd == i_rt) && i_MEM_write_reg) begin
                if(i_EX_mem_write) begin         // Hay Store
                    o_forwarding_b = 2'b00;      // No forwardeo
                    o_forwarding_mux_12 = 2'b00; // forwardea reg de EX_MEM para store
                end
                else begin
                    o_forwarding_b      = 2'b01; // El dato viene de MEM
                    o_forwarding_mux_12 = 2'b10; // Dato normal
                end
            end
            else if ((i_MEM_WB_rd == i_rt) && i_WB_write_reg) begin
                if(i_EX_mem_write) begin    // Hay store
                    o_forwarding_b = 2'b00; // No forwardeo
                    o_forwarding_mux_12 = 2'b01;
                end
                else begin
                    o_forwarding_b = 2'b10;      // El dato viene de WB
                    o_forwarding_mux_12 = 2'b10; // Dato normal
                end
            end
            else begin
                o_forwarding_b = 2'b0;  // No hay forwarding para B
                o_forwarding_mux_12 = 2'b10; // Dato normal
            end
        end
    end
    
endmodule