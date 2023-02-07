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
        input i_enable;
        input i_reset;                // Necesario para flush en controls hazard
        input opcode[NB_OPCODE-1:0];
        
        output regDst;                // EX
        output aluOp[NB_OPCODE-1:0];  // EX REG?
        output aluSrc;                // EX
        output memRead;               // MEM
        output memWrite;              // MEM
        output branch;                // MEM
        output regWrite;              // WB
        output memToReg;              // WB
    )


    always@(*) begin
        if(i_reset) begin
            aluOp = {NB_OPCODE{1'b0}};
            regDst = 1'b0;
            aluSrc = 1'b0;
            memRead = 1'b0;
            memWrite = 1'b0;
            branch = 1'b0; // VER
            regWrite = 1'b0;
            memToReg = 1'b0;
        end
        if(i_enable) begin
            aluOp = opcode;
            // VER señales con X
            case(opcode)
                RTYPE_OPCODE:
                    regDst = 1'b1; // rt
                    aluSrc = 1'b0; // rs
                    memRead = 1'b0; // no accede a mem
                    memWrite = 1'b0; // no accede a mem
                    branch = 1'b0; 
                    regWrite = 1'b1; // escribe en rt
                    memToReg = 1'b0; // no accede a mem

                BEQ_OPCODE:
                    regDst = 1'b0; // X no se usa
                    aluSrc = 1'b0; // immediate
                    memRead = 1'b0;
                    memWrite = 1'b0;
                    branch = 1'b1; 
                    regWrite = 1'b0; // no accede a regs
                    memToReg = 1'b0; // X no accede a mem

                BNE_OPCODE:
                    regDst = 1'b0; // X no se usa
                    aluSrc = 1'b0; // immediate
                    memRead = 1'b0;
                    memWrite = 1'b0;
                    branch = 1'b1; // VER QUE PASA CON ZERO FLAG
                    regWrite = 1'b0; // no accede a regs
                    memToReg = 1'b0; // X no accede a mem

                ADDI_OPCODE:

                SLTI_OPCODE:

                ANDI_OPCODE:  
                ORI_OPCODE:  
                XORI_OPCODE: 
                LUI_OPCODE:    
                LB_OPCODE:       
                LH_OPCODE:     
                LHU_OPCODE:     
                LW_OPCODE: 
                    regDst = 1'b0; 
                    aluSrc = 1'b1;
                    memRead = 1'b1;
                    memWrite = 1'b0;
                    branch = 1'b0; 
                    regWrite = 1'b1;
                    memToReg = 1'b1;   
                LWU_OPCODE:    
                LBU_OPCODE:    
                SB_OPCODE:      
                SH_OPCODE:   
                SW_OPCODE:
                    regDst = 1'b0; // X
                    aluSrc = 1'b1; 
                    memRead = 1'b0;
                    memWrite = 1'b1;
                    branch = 1'b0; 
                    regWrite = 1'b0;
                    memToReg = 1'b0; // X 

            endcase

        end
    
    end
endmodule
    