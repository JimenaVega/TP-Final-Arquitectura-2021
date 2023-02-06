`timescale 1ns / 1ps

module alu_control#(
        parameter   NB_FCODE        = 6,
        parameter   NB_OPCODE       = 6,
        parameter   NB_ALU_CTRLI    = 4,
        //Function codes
        parameter   SLL_FCODE   = 6'h00,
        parameter   SRL_FCODE   = 6'h02,
        parameter   SRA_FCODE   = 6'h03,
        parameter   SLLV_FCODE  = 6'h04,
        parameter   SRLV_FCODE  = 6'h06,
        parameter   SRAV_FCODE  = 6'h07,
        parameter   ADD_FCODE   = 6'h20,
        parameter   ADDU_FCODE  = 6'h21,
        parameter   SUB_FCODE   = 6'h22,
        parameter   SUBU_FCODE  = 6'h23,
        parameter   AND_FCODE   = 6'h24,
        parameter   OR_FCODE    = 6'h25,
        parameter   XOR_FCODE   = 6'h26,
        parameter   NOR_FCODE   = 6'h27,
        parameter   SLT_FCODE   = 6'h2a,
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
        input      [NB_FCODE-1     : 0] i_funct_code, // Codigo de funcion para instrucciones tipo R
        input      [NB_OPCODE-1    : 0] i_opcode,     // Tipo de instruccion
        output reg [NB_ALU_CTRLI-1 : 0] o_alu_op      // Senial que indica a la ALU que tipo de operaci�n ejecutar
    );
    
    always@(*) begin
        case(i_opcode)
            RTYPE_OPCODE: // R-Type
                case(i_funct_code)
                    SLL_FCODE   : o_alu_op = 4'h00;
                    SRL_FCODE   : o_alu_op = 4'h01;
                    SRA_FCODE   : o_alu_op = 4'h02;
                    SLLV_FCODE  : o_alu_op = 4'h00;
                    SRLV_FCODE  : o_alu_op = 4'h01;
                    SRAV_FCODE  : o_alu_op = 4'h02;
//                    JR_FCODE    : o_alu_op = 4'h00;
//                    JALR_FCODE  : o_alu_op = 4'h00;
                    ADD_FCODE   : o_alu_op = 4'h03;
                    ADDU_FCODE  : o_alu_op = 4'h03;
                    SUB_FCODE   : o_alu_op = 4'h04;
                    SUBU_FCODE  : o_alu_op = 4'h04;
                    AND_FCODE   : o_alu_op = 4'h05;
                    OR_FCODE    : o_alu_op = 4'h06;
                    XOR_FCODE   : o_alu_op = 4'h07;
                    NOR_FCODE   : o_alu_op = 4'h08;
                    SLT_FCODE   : o_alu_op = 4'h09;
                    default     : o_alu_op = o_alu_op;                      
                endcase                
            LB_OPCODE   : o_alu_op = 4'h03;  // INSTRUCCION ITYPE - ADDI -> ADD de ALU
            LH_OPCODE   : o_alu_op = 4'h03;
            LW_OPCODE   : o_alu_op = 4'h03;
            LWU_OPCODE  : o_alu_op = 4'h03;
            LBU_OPCODE  : o_alu_op = 4'h03;
            LHU_OPCODE  : o_alu_op = 4'h03;
            SB_OPCODE   : o_alu_op = 4'h03;
            SH_OPCODE   : o_alu_op = 4'h03;
            SW_OPCODE   : o_alu_op = 4'h03;
            ADDI_OPCODE : o_alu_op = 4'h03;
            ANDI_OPCODE : o_alu_op = 4'h05;
            ORI_OPCODE  : o_alu_op = 4'h06;
            XORI_OPCODE : o_alu_op = 4'h07;
            LUI_OPCODE  : o_alu_op = 4'h0d;
            SLTI_OPCODE : o_alu_op = 4'h09;
            BEQ_OPCODE  : o_alu_op = 4'h0e;
            BNE_OPCODE  : o_alu_op = 4'h0f;
            default     : o_alu_op = o_alu_op;
        endcase
    end
    
endmodule