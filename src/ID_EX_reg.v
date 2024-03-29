`timescale 1ns / 1ps

module ID_EX_reg#(
        parameter NB_ALU_OP   = 6,
        parameter NB_IMM      = 32,
        parameter NB_PC       = 32,
        parameter NB_DATA     = 32,
        parameter NB_REG      = 5
    )
    (
        input                    i_clock,
        input                    i_reset,
        input                    i_pipeline_enable,
        input                    ID_signed,
        input                    ID_reg_write,
        input                    ID_mem_to_reg,
        input                    ID_mem_read,
        input                    ID_mem_write,
        input                    ID_branch,
        input                    ID_alu_src,
        input                    ID_reg_dest,
        input  [NB_ALU_OP-1:0]   ID_alu_op,
        input  [NB_PC-1:0]       ID_pc,
        input  [NB_DATA-1:0]     ID_data_a,
        input  [NB_DATA-1:0]     ID_data_b,
        input  [NB_IMM-1:0]      ID_immediate,
        input  [NB_DATA-1:0]     ID_shamt,
        input  [NB_REG-1:0]      ID_rt,
        input  [NB_REG-1:0]      ID_rd,
        input  [NB_REG-1:0]      ID_rs,
        input                    ID_byte_en,
        input                    ID_halfword_en,
        input                    ID_word_en,
        input                    ID_hlt,
        input                    ID_jump,
        input                    ID_jr_jalr,
        
        output                   EX_signed,
        output                   EX_reg_write,
        output                   EX_mem_to_reg,
        output                   EX_mem_read,
        output                   EX_mem_write,
        output                   EX_branch,
        output                   EX_alu_src,
        output                   EX_reg_dest,
        output [NB_ALU_OP-1:0]   EX_alu_op,
        output [NB_PC-1:0]       EX_pc,
        output [NB_DATA-1:0]     EX_data_a,
        output [NB_DATA-1:0]     EX_data_b,
        output [NB_IMM-1:0]      EX_immediate,
        output [NB_DATA-1:0]     EX_shamt,
        output [NB_REG-1:0]      EX_rt,
        output [NB_REG-1:0]      EX_rd,
        output  [NB_REG-1:0]      EX_rs,
        output                   EX_byte_en,
        output                   EX_halfword_en,
        output                   EX_word_en,
        output                   EX_hlt,
        output                   EX_jump,
        output                   EX_jr_jalr
    );
    
    reg                 signed_flag;
    reg                 reg_write;
    reg                 mem_to_reg;
    reg                 mem_read;
    reg                 mem_write;
    reg                 branch;
    reg                 alu_src;
    reg                 reg_dest;
    reg [NB_ALU_OP-1:0] alu_op;
    reg [NB_PC-1:0]     pc;
    reg [NB_DATA-1:0]   data_a;
    reg [NB_DATA-1:0]   data_b;
    reg [NB_IMM-1:0]    immediate;
    reg [NB_DATA-1:0]   shamt;
    reg [NB_REG-1:0]    rt;
    reg [NB_REG-1:0]    rd;
    reg [NB_REG-1:0]    rs;
    reg                 byte_en;
    reg                 halfword_en;
    reg                 word_en;
    reg                 hlt;
    reg                 jump;
    reg                 jr_jalr;

    always @(negedge i_clock) begin
        if(i_reset) begin
            signed_flag <= 1'b0;
            reg_write   <= 1'b0;
            mem_to_reg  <= 1'b0;
            mem_read    <= 1'b0;
            mem_write   <= 1'b0;
            branch      <= 1'b0;
            alu_src     <= 1'b0;
            reg_dest    <= 1'b0;
            alu_op      <= 6'b0;
            pc          <= 32'b0;
            data_a      <= 32'b0;
            data_b      <= 32'b0;
            immediate   <= 32'b0;
            shamt       <= 32'b0;
            rt          <= 5'b0;
            rd          <= 5'b0;
            rs          <= 5'b0;
            byte_en     <= 1'b0;
            halfword_en <= 1'b0;
            word_en     <= 1'b0;
            hlt         <= 1'b0;
            jump        <= 1'b0;
            jr_jalr     <= 1'b0;
        end
        else begin
            if(i_pipeline_enable) begin
                signed_flag <= ID_signed;
                reg_write   <= ID_reg_write;
                mem_to_reg  <= ID_mem_to_reg;
                mem_read    <= ID_mem_read;
                mem_write   <= ID_mem_write;
                branch      <= ID_branch;
                alu_src     <= ID_alu_src;
                reg_dest    <= ID_reg_dest;
                alu_op      <= ID_alu_op;
                pc          <= ID_pc;
                data_a      <= ID_data_a;
                data_b      <= ID_data_b;
                immediate   <= ID_immediate;
                shamt       <= ID_shamt;
                rt          <= ID_rt;
                rd          <= ID_rd;
                rs          <= ID_rs;
                byte_en     <= ID_byte_en;
                halfword_en <= ID_halfword_en;
                word_en     <= ID_word_en;
                hlt         <= ID_hlt;
                jump        <= ID_jump;
                jr_jalr     <= ID_jr_jalr;
            end
            else begin
                signed_flag <= signed_flag;
                reg_write   <= reg_write;
                mem_to_reg  <= mem_to_reg;
                mem_read    <= mem_read;
                mem_write   <= mem_write;
                branch      <= branch;
                alu_src     <= alu_src;
                reg_dest    <= reg_dest;
                alu_op      <= alu_op;
                pc          <= pc;
                data_a      <= data_a;
                data_b      <= data_b;
                immediate   <= immediate;
                shamt       <= shamt;
                rt          <= rt;
                rd          <= rd;
                rs          <= rs;
                byte_en     <= byte_en;
                halfword_en <= halfword_en;
                word_en     <= word_en;
                hlt         <= hlt;
                jump        <= jump;
                jr_jalr     <= jr_jalr;
            end
        end
    end

    assign EX_signed        = signed_flag;
    assign EX_reg_write     = reg_write;
    assign EX_mem_to_reg    = mem_to_reg;
    assign EX_mem_read      = mem_read;
    assign EX_mem_write     = mem_write;
    assign EX_branch        = branch;
    assign EX_alu_src       = alu_src;
    assign EX_reg_dest      = reg_dest;
    assign EX_alu_op        = alu_op;
    assign EX_pc            = pc;
    assign EX_data_a        = data_a;
    assign EX_data_b        = data_b;
    assign EX_immediate     = immediate;
    assign EX_shamt         = shamt;
    assign EX_rt            = rt;
    assign EX_rd            = rd;
    assign EX_rs            = rs;
    assign EX_byte_en       = byte_en;
    assign EX_halfword_en   = halfword_en;
    assign EX_word_en       = word_en;
    assign EX_hlt           = hlt;
    assign EX_jump          = jump;
    assign EX_jr_jalr       = jr_jalr;
    
endmodule
