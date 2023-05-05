`timescale 1ns / 1ps

module tb_concat_module();
    parameter NB_ADDR = 26;    // Jump address in J type instructions          
    parameter NB_PC = 32;            
    parameter NB_UPPER_PC = 4; // Number of bits of upper PC+1
    parameter NB_LOWER_BITS = 2;
    
    // concat module
    reg instruction[NB_PC-1:0]; // instruccion completa
    // reg next_pc[NB_PC-1:0]; // PC completo
    wire [NB_PC-1:0] jump_addr;

    // PC
    reg enable;
    reg clock;
    reg reset;
    reg[NB_PC-1:0] mux_pc;
        
    wire  [NB_PC-1:0] next_pc;

    // mux
    reg select;
    wire [NB_PC-1:0] address;
    
    initial begin
    
        clock = 1'b0;
        pc_reset = 1'b1;
        pc_enable = 1'b0;
        address = 32'b0;
        select = 1'b0;
        #20
        pc_reset = 1'b0;
        #20
        select = 1'b1; // jump
        
        #200
        
        $finish;
    
    end
    always #10 clock = ~clock;

    program_counter program_counter(.i_enable(enable),
                                    .i_clock(clock),
                                    .i_reset(reset),
                                    .i_mux_pc(address),
                                    .o_pc_mem(next_pc)
                                    );
    mux2 mux2(.i_select(select), // jump=1 pc+1=0
              .i_a(next_pc), // pc+1
              .i_b(jump_addr), // jump_address
              .o_data(address)
             );
    
    concat_module concat_module(.i_inst(instruction[NB_ADDR-1:0]),
                                .i_next_pc(next_pc[NB_PC-1:28]),
                                .o_jump_addr(jump_addr)
                                );

endmodule