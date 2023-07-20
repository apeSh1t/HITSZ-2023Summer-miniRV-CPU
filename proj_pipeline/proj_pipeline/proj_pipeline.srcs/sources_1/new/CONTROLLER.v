`timescale 1ns / 1ps

`include "defines.vh"

module CONTROLLER(
    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,
    output reg  [2:0] sext_op,
    output reg  [1:0] npc_op,
    output reg        ram_we,
    output reg        ram_re,
    output reg  [3:0] alu_op,
    output reg  [1:0] alub_sel,
    output reg        rf_we,
    output reg  [2:0] rf_wsel,
    output reg        wr_flag,
    output reg        rR1_flag,
    output reg        rR2_flag          // 1'b1 => register, 1'b0 => imm
);

always @(*) begin
    case(opcode)
        `CONTROLLER_OPCODE_R:      //R_Type
            begin
                sext_op = `SEXT_OP_R ;
                npc_op  = `NPC_OP_PC4;
                ram_we  = 0;
                ram_re  = 0;
                alub_sel = `ALUB_SEL_RD2;
                rf_we    = 1;
                rf_wsel  = `RF_WSEL_ALUC;

                rR1_flag = 1'b1;
                rR2_flag = 1'b1;
                wr_flag = 1'b1;
                case(funct7)
                  7'b0000000: begin
                        case(funct3)
                            3'b000: begin alu_op = `ALU_OP_ADD; end    //add
                            3'b111: begin alu_op = `ALU_OP_AND; end    //and
                            3'b110: begin alu_op = `ALU_OP_OR ; end    //or
                            3'b100: begin alu_op = `ALU_OP_XOR; end    //xor
                            3'b001: begin alu_op = `ALU_OP_SLL; end    //sll
                            3'b101: begin alu_op = `ALU_OP_SRL; end    //srl
                        endcase
                  end

                  7'b0100000: begin
                        case(funct3)
                            3'b000: begin alu_op = `ALU_OP_SUB; end    //sub
                            3'b101: begin alu_op = `ALU_OP_SRA; end    //sra
                        endcase
                  end
                endcase
            end

        `CONTROLLER_OPCODE_I:
            begin
                sext_op = `SEXT_OP_I;
                npc_op  = `NPC_OP_PC4;
                ram_we  = 0;
                ram_re  = 0;
                alub_sel = `ALUB_SEL_EXT;
                rf_we    = 1;

                rR1_flag = 1'b1;
                rR2_flag = 1'b0;
                wr_flag = 1'b1;

                case(funct3)
                    3'b000: begin
                        alu_op = `ALU_OP_ADD;                           //addi
                        rf_wsel = `RF_WSEL_ALUC;
                    end

                    3'b111: begin                                       
                        alu_op = `ALU_OP_AND;                          //andi
                        rf_wsel = `RF_WSEL_ALUC;
                    end

                    3'b110: begin
                        alu_op = `ALU_OP_OR;                            //ori
                        rf_wsel = `RF_WSEL_ALUC;
                    end

                    3'b100: begin
                        alu_op = `ALU_OP_XOR;                           //xori
                        rf_wsel = `RF_WSEL_ALUC;
                    end

                    3'b001: begin
                        alu_op = `ALU_OP_SLL;                           //slli
                        rf_wsel = `RF_WSEL_ALUC;
                    end

                    3'b010: begin
                        
                    end

                    3'b101: begin
                        if (funct7 == 7'b0000000) begin                 //srli
                            alu_op = `ALU_OP_SRL;
                            rf_wsel = `RF_WSEL_ALUC;
                        end

                        if (funct7 == 7'b0100000) begin                 //srai
                            alu_op = `ALU_OP_SRA;
                            rf_wsel = `RF_WSEL_ALUC;
                        end
                    end
                    
                endcase
            end

        `CONTROLLER_OPCODE_I_LW:                                       //lw
            begin
                sext_op = `SEXT_OP_I;
                npc_op  = `NPC_OP_PC4;
                ram_we  = 0;
                ram_re  = 1;
                alub_sel = `ALUB_SEL_EXT;
                rf_we    = 1;
                alu_op = `ALU_OP_ADD;                                   
                rf_wsel = `RF_WSEL_RDO;

                rR1_flag = 1'b1;
                rR2_flag = 1'b0;
                wr_flag = 1'b1;
            end

        `CONTROLLER_OPCODE_I_JALR:                                      //jalr
            begin
                sext_op = `SEXT_OP_I;
                npc_op  = `NPC_OP_JALR;
                ram_we  = 0;
                ram_re  = 0;
                alu_op  = `ALU_OP_JALR;
                alub_sel= `ALUB_SEL_EXT;
                rf_we   = 1;
                rf_wsel = `RF_WSEL_PC4;

                rR1_flag = 1'b1;
                rR2_flag = 1'b0;
                wr_flag = 1'b1;
            end

        `CONTROLLER_OPCODE_S:                                          //sw
            begin
                sext_op = `SEXT_OP_S;
                npc_op  = `NPC_OP_PC4;
                ram_we  = 1;
                ram_re  = 0;
                alu_op  = `ALU_OP_ADD;
                alub_sel= `ALUB_SEL_EXT;
                rf_we   = 0;
                rf_wsel = `RF_WSEL_DEFAULT;

                rR1_flag = 1'b1;
                rR2_flag = 1'b1;
                wr_flag = 1'b0;
            end

        `CONTROLLER_OPCODE_B:
            begin
                sext_op = `SEXT_OP_B;
                npc_op  = `NPC_OP_OFFSET;
                ram_we  = 0;
                ram_re  = 0;
                alub_sel= `ALUB_SEL_RD2;
                rf_we   = 0;
                rf_wsel = `RF_WSEL_DEFAULT;
                
                rR1_flag = 1'b1;
                rR2_flag = 1'b1;
                wr_flag = 1'b0;
                case (funct3)
                    3'b000: begin alu_op = `ALU_OP_BEQ; end         //beq
                    3'b001: begin alu_op = `ALU_OP_BNE; end         //bne
                    3'b100: begin alu_op = `ALU_OP_BLT; end         //blt
                    3'b101: begin alu_op = `ALU_OP_BGE; end         //bge  
                endcase
            end

        `CONTROLLER_OPCODE_U:                                       //lui
            begin
                sext_op = `SEXT_OP_U;
                npc_op  = `NPC_OP_PC4;
                ram_we  = 0;
                ram_re  = 0;
                alu_op  = `ALU_OP_DEFAULT;
                alub_sel= `ALUB_SEL_EXT;
                rf_we   = 1;
                rf_wsel = `RF_WSEL_EXT;

                rR1_flag = 1'b0;
                rR2_flag = 1'b0;
                wr_flag = 1'b1;
            end

        `CONTROLLER_OPCODE_J:                                       //jal
            begin
                sext_op = `SEXT_OP_J;
                npc_op  = `NPC_OP_OFFSET;
                ram_we  = 0;
                ram_re  = 0;
                alu_op  = `ALU_OP_JAL;
                alub_sel= `ALUB_SEL_EXT;
                rf_we   = 1;
                rf_wsel = `RF_WSEL_PC4;

                rR1_flag = 1'b0;
                rR2_flag = 1'b0;
                wr_flag = 1'b1;
            end

        default:
            begin
                sext_op = `SEXT_OP_DEFAULT;
                npc_op  = `NPC_OP_DEFAULT;
                ram_we  = 0;
                ram_re  = 0;
                alu_op  = `ALU_OP_DEFAULT;
                alub_sel= `ALUB_SEL_DEFAULT;
                rf_we   = 0;
                rf_wsel = `RF_WSEL_DEFAULT;

                rR1_flag = 1'b0;
                rR2_flag = 1'b0;
                wr_flag = 1'b0;
            end
    endcase

end


endmodule