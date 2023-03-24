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
        input      [NB_OPCODE-1    : 0] i_alu_op,     // opcode
        output reg [NB_ALU_CTRLI-1 : 0] o_alu_ctrl,   // Senial que indica a la ALU que tipo de operacion ejecutar
        output reg                      o_shamt_ctrl  // Senial de MUX: 0 -> shamt  1 -> data_a
    );
    
    always@(*) begin
        case(i_alu_op)
            RTYPE_OPCODE: begin
                case(i_funct_code)
                        SLL_FCODE   : begin
                            o_alu_ctrl = 4'h00;
                            o_shamt_ctrl = 1'b0; // Elige shamt
                        end 
                        SRL_FCODE   : begin
                            o_alu_ctrl = 4'h01;
                            o_shamt_ctrl = 1'b0; // Elige shamt
                        end
                        SRA_FCODE   : begin
                            o_alu_ctrl = 4'h02;
                            o_shamt_ctrl = 1'b0; // Elige shamt
                        end
                        SLLV_FCODE  : begin
                            o_alu_ctrl = 4'h00;
                            o_shamt_ctrl = 1'b1; // Elige data_a (rs)
                        end
                        SRLV_FCODE  : begin
                            o_alu_ctrl = 4'h01;
                            o_shamt_ctrl = 1'b1; // Elige data_a (rs)
                        end
                        SRAV_FCODE  : begin
                            o_alu_ctrl = 4'h02;
                            o_shamt_ctrl = 1'b1; // Elige data_a (rs)

                        end
                        ADD_FCODE   : begin
                            o_alu_ctrl = 4'h03;
                            o_shamt_ctrl = 1'b1; // Elige data_a
                        end
                        ADDU_FCODE  : begin
                            o_alu_ctrl = 4'h03;
                            o_shamt_ctrl = 1'b1; // Elige data_a
                        end
                        SUB_FCODE   : begin
                            o_alu_ctrl = 4'h04;
                            o_shamt_ctrl = 1'b1; // Elige data_a
                        end
                        SUBU_FCODE  : begin
                            o_alu_ctrl = 4'h04;
                            o_shamt_ctrl = 1'b1; // Elige data_a
                        end
                        AND_FCODE   : begin
                            o_alu_ctrl = 4'h05;
                            o_shamt_ctrl = 1'b1; // Elige data_a
                        end
                        OR_FCODE    : begin
                            o_alu_ctrl = 4'h06;
                            o_shamt_ctrl = 1'b1; // Elige data_a
                        end
                        XOR_FCODE   : begin
                            o_alu_ctrl = 4'h07;
                            o_shamt_ctrl = 1'b1; // Elige data_a
                        end
                        NOR_FCODE   : begin
                            o_alu_ctrl = 4'h08;
                            o_shamt_ctrl = 1'b1; // Elige data_a
                        end
                        SLT_FCODE   : begin
                            o_alu_ctrl = 4'h09;
                            o_shamt_ctrl = 1'b1; // Elige data_a
                        end
                        default     : begin
                            o_alu_ctrl = o_alu_ctrl;
                            o_shamt_ctrl = o_shamt_ctrl;
                        end                      
                endcase
            end       
            LB_OPCODE   : begin
                o_alu_ctrl = 4'h03;  // INSTRUCCION ITYPE - ADDI -> ADD de ALU
                o_shamt_ctrl = 1'b1; // Elige data_a
            end
            LH_OPCODE   : begin
                o_alu_ctrl = 4'h03;
                o_shamt_ctrl = 1'b1; // Elige data_a
            end
            LW_OPCODE   : begin
                o_alu_ctrl = 4'h03;
                o_shamt_ctrl = 1'b1; // Elige data_a
            end
            LWU_OPCODE  : begin
                o_alu_ctrl = 4'h03;
                o_shamt_ctrl = 1'b1; // Elige data_a
            end
            LBU_OPCODE  : begin
                o_alu_ctrl = 4'h03;
                o_shamt_ctrl = 1'b1; // Elige data_a
            end
            LHU_OPCODE  : begin
                o_alu_ctrl = 4'h03;
                o_shamt_ctrl = 1'b1; // Elige data_a
            end
            SB_OPCODE   : begin
                o_alu_ctrl = 4'h03;
                o_shamt_ctrl = 1'b1; // Elige data_a
            end
            SH_OPCODE   : begin
                o_alu_ctrl = 4'h03;
                o_shamt_ctrl = 1'b1; // Elige data_a
            end
            SW_OPCODE   : begin
                o_alu_ctrl = 4'h03;
                o_shamt_ctrl = 1'b1; // Elige data_a
            end
            ADDI_OPCODE : begin
                o_alu_ctrl = 4'h03;
                o_shamt_ctrl = 1'b1; // Elige data_a
            end
            ANDI_OPCODE : begin
                o_alu_ctrl = 4'h05;
                o_shamt_ctrl = 1'b1; // Elige data_a
            end
            ORI_OPCODE  : begin
                o_alu_ctrl = 4'h06;
                o_shamt_ctrl = 1'b1; // Elige data_a
            end
            XORI_OPCODE : begin
                o_alu_ctrl = 4'h07;
                o_shamt_ctrl = 1'b1; // Elige data_a
            end
            LUI_OPCODE  : begin
                o_alu_ctrl = 4'h0a;
                o_shamt_ctrl = 1'b1; // Elige data_a
            end
            SLTI_OPCODE : begin
                o_alu_ctrl = 4'h09;
                o_shamt_ctrl = 1'b1; // Elige data_a
            end
            BEQ_OPCODE  : begin
                o_alu_ctrl = 4'h0b;
                o_shamt_ctrl = 1'b1; // Elige data_a
            end
            BNE_OPCODE  : begin
                o_alu_ctrl = 4'h0c;
                o_shamt_ctrl = 1'b1; // Elige data_a
            end
            default     : begin
                o_alu_ctrl = o_alu_ctrl;
                o_shamt_ctrl = o_shamt_ctrl;
            end
        endcase
    end
    
endmodule