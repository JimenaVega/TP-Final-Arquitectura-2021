`timescale 1ns / 1ps

module control_unit#(
        parameter   NB_OPCODE       = 6,
        //Instruction OPCODEs
        parameter   RTYPE_OPCODE    = 6'h00,
        parameter   BEQ_OPCODE      = 6'h04, // ITYPE BEQ
        parameter   BNE_OPCODE      = 6'h05, // ITYPE BNE
        parameter   ADDI_OPCODE     = 6'h08, // ITYPE ADDI
        parameter   SLTI_OPCODE     = 6'h0a, // ITYPE SLTI
        parameter   ANDI_OPCODE     = 6'h0c, // ITYPE ANDI
        parameter   ORI_OPCODE      = 6'h0d, // ITYPE ORI
        parameter   XORI_OPCODE     = 6'h0e, // ITYPE XORI
        parameter   LUI_OPCODE      = 6'h0f, // ITYPE LUI
        parameter   LB_OPCODE       = 6'h20, // ITYPE LB
        parameter   LH_OPCODE       = 6'h21, // ITYPE LH
        parameter   LHU_OPCODE      = 6'h22, // ITYPE LHU
        parameter   LW_OPCODE       = 6'h23, // ITYPE LW
        parameter   LWU_OPCODE      = 6'h24, // ITYPE LWU
        parameter   LBU_OPCODE      = 6'h25, // ITYPE LBU
        parameter   SB_OPCODE       = 6'h28, // ITYPE SB
        parameter   SH_OPCODE       = 6'h29, // ITYPE SH
        parameter   SW_OPCODE       = 6'h2b  // ITYPE SW
    )
    (   
        input                       i_enable,
        input                       i_reset,        // Necesario para flush en controls hazard
        input [NB_OPCODE-1:0]       i_opcode,
        
        output reg                  o_reg_dest,     // EX
        output reg [NB_OPCODE-1:0]  o_alu_op,       // EX REG?
        output reg                  o_alu_src,      // EX
        output reg                  o_mem_read,     // MEM
        output reg                  o_mem_write,    // MEM
        output reg                  o_branch,       // MEM
        output reg                  o_reg_write,    // WB
        output reg                  o_mem_to_reg    // WB
    );

    always@(*) begin
        if(i_reset) begin
            o_alu_op        = {NB_OPCODE{1'b0}};
            o_reg_dest      = 1'b0;
            o_alu_src       = 1'b0;
            o_mem_read      = 1'b0;
            o_mem_write     = 1'b0;
            o_branch        = 1'b0;
            o_reg_write     = 1'b0;
            o_mem_to_reg    = 1'b0;
        end
        if(i_enable) begin
            o_alu_op = i_opcode;
            case(i_opcode)
                RTYPE_OPCODE:begin
                    o_reg_dest      = 1'b1; // rd
                    o_alu_src       = 1'b0; // rt
                    o_mem_read      = 1'b0; // no accede a mem
                    o_mem_write     = 1'b0; // no accede a mem
                    o_branch        = 1'b0; // no es branch
                    o_reg_write     = 1'b1; // escribe en bank register
                    o_mem_to_reg    = 1'b0; // read salida ALU
                end
                BEQ_OPCODE:begin
                    o_reg_dest      = 1'b0; // X
                    o_alu_src       = 1'b0; // rt
                    o_mem_read      = 1'b0; // no accede a mem
                    o_mem_write     = 1'b0; // no accede a mem
                    o_branch        = 1'b1; // es branch
                    o_reg_write     = 1'b0; // no escribe en bank register
                    o_mem_to_reg    = 1'b0; // X
                end
                BNE_OPCODE:begin
                    o_reg_dest      = 1'b0; // X
                    o_alu_src       = 1'b0; // rt
                    o_mem_read      = 1'b0; // no accede a mem
                    o_mem_write     = 1'b0; // no accede a mem
                    o_branch        = 1'b1; // es branch
                    o_reg_write     = 1'b0; // no escribe en bank register
                    o_mem_to_reg    = 1'b0; // X
                end
                ADDI_OPCODE:begin
                    o_reg_dest      = 1'b0; // rt
                    o_alu_src       = 1'b1; // immediate
                    o_mem_read      = 1'b0; // no accede a mem
                    o_mem_write     = 1'b0; // no accede a mem
                    o_branch        = 1'b0; // no es branch
                    o_reg_write     = 1'b1; // escribe en bank register
                    o_mem_to_reg    = 1'b0; // read salida ALU
                end
                SLTI_OPCODE:begin
                    o_reg_dest      = 1'b0; // rt
                    o_alu_src       = 1'b1; // immediate
                    o_mem_read      = 1'b0; // no accede a mem
                    o_mem_write     = 1'b0; // no accede a mem
                    o_branch        = 1'b0; // no es branch
                    o_reg_write     = 1'b1; // escribe en bank register
                    o_mem_to_reg    = 1'b0; // read salida ALU
                end
                ANDI_OPCODE:begin
                    o_reg_dest      = 1'b0; // rt
                    o_alu_src       = 1'b1; // immediate
                    o_mem_read      = 1'b0; // no accede a mem
                    o_mem_write     = 1'b0; // no accede a mem
                    o_branch        = 1'b0; // no es branch
                    o_reg_write     = 1'b1; // escribe en bank register
                    o_mem_to_reg    = 1'b0; // read salida ALU
                end
                ORI_OPCODE:begin
                    o_reg_dest      = 1'b0; // rt
                    o_alu_src       = 1'b1; // immediate
                    o_mem_read      = 1'b0; // no accede a mem
                    o_mem_write     = 1'b0; // no accede a mem
                    o_branch        = 1'b0; // no es branch
                    o_reg_write     = 1'b1; // escribe en bank register
                    o_mem_to_reg    = 1'b0; // read salida ALU
                end
                XORI_OPCODE:begin
                    o_reg_dest      = 1'b0; // rt
                    o_alu_src       = 1'b1; // immediate
                    o_mem_read      = 1'b0; // no accede a mem
                    o_mem_write     = 1'b0; // no accede a mem
                    o_branch        = 1'b0; // no es branch
                    o_reg_write     = 1'b1; // escribe en bank register
                    o_mem_to_reg    = 1'b0; // read salida ALU
                end
                LUI_OPCODE:begin
                    o_reg_dest      = 1'b0; // rt
                    o_alu_src       = 1'b1; // immediate
                    o_mem_read      = 1'b0; // no accede a mem
                    o_mem_write     = 1'b0; // no accede a mem
                    o_branch        = 1'b0; // no es branch
                    o_reg_write     = 1'b1; // escribe en bank register
                    o_mem_to_reg    = 1'b0; // read salida ALU
                end
                LB_OPCODE:begin
                    o_reg_dest      = 1'b0; // rt
                    o_alu_src       = 1'b1; // immediate
                    o_mem_read      = 1'b1; // read mem
                    o_mem_write     = 1'b0; // no write mem
                    o_branch        = 1'b0; // no es branch
                    o_reg_write     = 1'b1; // escribe en rt
                    o_mem_to_reg    = 1'b1; // read salida data memory
                end
                LH_OPCODE:begin
                    o_reg_dest      = 1'b0; // rt
                    o_alu_src       = 1'b1; // immediate
                    o_mem_read      = 1'b1; // read mem
                    o_mem_write     = 1'b0; // no write mem
                    o_branch        = 1'b0; // no es branch
                    o_reg_write     = 1'b1; // escribe en rt
                    o_mem_to_reg    = 1'b1; // read salida data memory
                end
                LHU_OPCODE:begin
                    o_reg_dest      = 1'b0; // rt
                    o_alu_src       = 1'b1; // immediate
                    o_mem_read      = 1'b1; // read mem
                    o_mem_write     = 1'b0; // no write mem
                    o_branch        = 1'b0; // no es branch
                    o_reg_write     = 1'b1; // escribe en rt
                    o_mem_to_reg    = 1'b1; // read salida data memory
                end
                LW_OPCODE:begin
                    o_reg_dest      = 1'b0; // rt
                    o_alu_src       = 1'b1; // immediate
                    o_mem_read      = 1'b1; // read mem
                    o_mem_write     = 1'b0; // no write mem
                    o_branch        = 1'b0; // no es branch
                    o_reg_write     = 1'b1; // escribe en rt
                    o_mem_to_reg    = 1'b1; // read salida data memory
                end
                LWU_OPCODE:begin
                    o_reg_dest      = 1'b0; // rt
                    o_alu_src       = 1'b1; // immediate
                    o_mem_read      = 1'b1; // read mem
                    o_mem_write     = 1'b0; // no write mem
                    o_branch        = 1'b0; // no es branch
                    o_reg_write     = 1'b1; // escribe en rt
                    o_mem_to_reg    = 1'b1; // read salida data memory
                end
                LBU_OPCODE:begin
                    o_reg_dest      = 1'b0; // rt
                    o_alu_src       = 1'b1; // immediate
                    o_mem_read      = 1'b1; // read mem
                    o_mem_write     = 1'b0; // no write mem
                    o_branch        = 1'b0; // no es branch
                    o_reg_write     = 1'b1; // escribe en rt
                    o_mem_to_reg    = 1'b1; // read salida data memory
                end
                SB_OPCODE:begin
                    o_reg_dest      = 1'b0; // rt
                    o_alu_src       = 1'b1; // immediate
                    o_mem_read      = 1'b0; // no read mem
                    o_mem_write     = 1'b1; // write mem
                    o_branch        = 1'b0; // no es branch
                    o_reg_write     = 1'b0; // escribe en rt
                    o_mem_to_reg    = 1'b0; // X
                end
                SH_OPCODE:begin
                    o_reg_dest      = 1'b0; // rt
                    o_alu_src       = 1'b1; // immediate
                    o_mem_read      = 1'b0; // no read mem
                    o_mem_write     = 1'b1; // write mem
                    o_branch        = 1'b0; // no es branch
                    o_reg_write     = 1'b0; // escribe en rt
                    o_mem_to_reg    = 1'b0; // X
                end
                SW_OPCODE:begin
                    o_reg_dest      = 1'b0; // rt
                    o_alu_src       = 1'b1; // immediate
                    o_mem_read      = 1'b0; // no read mem
                    o_mem_write     = 1'b1; // write mem
                    o_branch        = 1'b0; // no es branch
                    o_reg_write     = 1'b0; // escribe en rt
                    o_mem_to_reg    = 1'b0; // X
                end
            endcase
        end
    end
endmodule
    