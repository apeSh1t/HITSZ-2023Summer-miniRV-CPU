`timescale 1ns / 1ps

`include "defines.vh"

module ID_EX(
    input  wire clk,
    input  wire rst,
    input  wire load_use_flag,
    input  wire id_have_inst_flag,
    input  wire       id_wr_flag ,
    input  wire       id_rR1_flag,
    input  wire       id_rR2_flag,
    input  wire [1:0] jump_flag,
    input  wire [1:0] id_npc_op,
    input  wire       id_ram_we,
    input  wire       id_ram_re,
    input  wire [3:0] id_alu_op,
    input  wire [1:0] id_alub_sel,
    input  wire       id_rf_we,
    input  wire [2:0] id_rf_wsel,
    input  wire [4:0] id_rf_wr,
    input  wire [4:0] id_rR1,
    input  wire [4:0] id_rR2,
    input  wire [6:0] id_opcode,
    input  wire [31:0] id_rD1,
    input  wire [31:0] id_rD2,
    input  wire [31:0] id_ext,
    input  wire [31:0] id_pc4,
    input  wire [31:0] id_pc,
    output reg        ex_have_inst_flag,
    output reg        ex_wr_flag ,
    output reg        ex_rR1_flag,
    output reg        ex_rR2_flag,
    output reg  [1:0] ex_npc_op,
    output reg        ex_ram_we,
    output reg        ex_ram_re,
    output reg  [3:0] ex_alu_op,
    output reg  [1:0] ex_alub_sel,
    output reg        ex_rf_we,
    output reg  [2:0] ex_rf_wsel,
    output reg  [4:0] ex_rf_wr,
    output reg  [4:0] ex_rR1,
    output reg  [4:0] ex_rR2,
    output reg  [6:0] ex_opcode,
    output reg  [31:0] ex_A,
    output reg  [31:0] ex_rD2,
    output reg  [31:0] ex_ext,
    output reg  [31:0] ex_pc4,
    output reg  [31:0] ex_pc
);

always @(posedge clk or posedge rst) begin
    if (rst) begin ex_npc_op <= 2'b0;      end
    else if (load_use_flag) begin ex_npc_op <= 2'b0; end
    else if (jump_flag == `NPC_BR_JUMP) begin ex_npc_op <= 2'b0; end
    else     begin ex_npc_op <= id_npc_op; end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin ex_ram_we <= 1'b0;      end
    else if (load_use_flag) begin ex_ram_we <= 1'b0; end
    else if (jump_flag == `NPC_BR_JUMP) begin ex_ram_we <= 1'b0; end
    else     begin ex_ram_we <= id_ram_we; end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin ex_ram_re <= 1'b0;      end
    else if (load_use_flag) begin ex_ram_re <= 1'b0; end
    else if (jump_flag == `NPC_BR_JUMP) begin ex_ram_re <= 1'b0; end
    else     begin ex_ram_re <= id_ram_re; end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin ex_alu_op <= 4'b0;      end
    else if (load_use_flag) begin ex_alu_op <= 4'b0; end
    else if (jump_flag == `NPC_BR_JUMP) begin ex_alu_op <= 4'b0; end
    else     begin ex_alu_op <= id_alu_op; end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin ex_alub_sel <= 2'b0;        end
    else if (load_use_flag) begin ex_alub_sel <= 2'b0; end
    else if (jump_flag == `NPC_BR_JUMP) begin ex_alub_sel <= 2'b0; end
    else     begin ex_alub_sel <= id_alub_sel; end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin ex_A <= 32'b0;  end
    else if (load_use_flag) begin ex_A <= 32'b0; end
    else if (jump_flag == `NPC_BR_JUMP) begin ex_A <= 32'b0; end
    else     begin ex_A <= id_rD1; end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin ex_rD2 <= 32'b0;  end
    else if (load_use_flag) begin ex_rD2 <= 32'b0; end
    else if (jump_flag == `NPC_BR_JUMP) begin ex_rD2 <= 32'b0; end
    else     begin ex_rD2 <= id_rD2; end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin ex_ext <= 32'b0;  end
    else if (load_use_flag) begin ex_ext <= 32'b0; end
    else if (jump_flag == `NPC_BR_JUMP) begin ex_ext <= 32'b0; end
    else     begin ex_ext <= id_ext; end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin ex_rf_we <= 1'b0;     end
    else if (load_use_flag) begin ex_rf_we <= 1'b0; end
    else if (jump_flag == `NPC_BR_JUMP) begin ex_rf_we <= 1'b0; end
    else     begin ex_rf_we <= id_rf_we; end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin ex_rf_wsel <= 3'b0;       end
    else if (load_use_flag) begin ex_rf_wsel <= 3'b0; end
    else if (jump_flag == `NPC_BR_JUMP) begin ex_rf_wsel <= 3'b0; end
    else     begin ex_rf_wsel <= id_rf_wsel; end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin ex_rf_wr <= 5'b0;     end
    else if (load_use_flag) begin ex_rf_wr <= 5'b0; end
    else if (jump_flag == `NPC_BR_JUMP) begin ex_rf_wr <= 5'b0; end
    else     begin ex_rf_wr <= id_rf_wr; end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin ex_rR1 <= 5'b0;   end
    else if (load_use_flag) begin ex_rR1 <= 5'b0; end
    else if (jump_flag == `NPC_BR_JUMP) begin ex_rR1 <= 5'b0; end
    else     begin ex_rR1 <= id_rR1; end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin ex_rR2 <= 5'b0;   end
    else if (load_use_flag) begin ex_rR2 <= 5'b0; end
    else if (jump_flag == `NPC_BR_JUMP) begin ex_rR2 <= 5'b0; end
    else     begin ex_rR2 <= id_rR2; end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin ex_pc4 <= 32'b0;   end
    else if (load_use_flag) begin ex_pc4 <= 32'b0; end
    else if (jump_flag == `NPC_BR_JUMP) begin ex_pc4 <= 32'b0; end
    else     begin ex_pc4 <= id_pc4; end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin ex_pc <= 32'b0;   end
    else if (load_use_flag) begin ex_pc <= 32'b0; end
    else if (jump_flag == `NPC_BR_JUMP) begin ex_pc <= 32'b0; end
    else     begin ex_pc <= id_pc; end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin ex_have_inst_flag <= 1'b0; end
    else if (load_use_flag) begin ex_have_inst_flag <= 1'b0; end
    else if (jump_flag == `NPC_BR_JUMP) begin ex_have_inst_flag <= 1'b0; end
    else     begin ex_have_inst_flag <= id_have_inst_flag;   end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin ex_wr_flag <= 1'b0; end
    else if (load_use_flag) begin ex_wr_flag <= 1'b0; end
    else if (jump_flag == `NPC_BR_JUMP) begin ex_wr_flag <= 1'b0; end
    else     begin ex_wr_flag <= id_wr_flag;   end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin ex_rR1_flag <= 1'b0; end
    else if (load_use_flag) begin ex_rR1_flag <= 1'b0; end
    else if (jump_flag == `NPC_BR_JUMP) begin ex_rR1_flag <= 1'b0; end
    else     begin ex_rR1_flag <= id_rR1_flag;   end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin ex_rR2_flag <= 1'b0; end
    else if (load_use_flag) begin ex_rR2_flag <= 1'b0; end
    else if (jump_flag == `NPC_BR_JUMP) begin ex_rR2_flag <= 1'b0; end
    else     begin ex_rR2_flag <= id_rR2_flag;   end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin ex_opcode <= 7'b0; end
    else if (load_use_flag) begin ex_opcode <= 7'b0; end
    else if (jump_flag == `NPC_BR_JUMP) begin ex_opcode <= 7'b0; end
    else     begin ex_opcode <= id_opcode;   end
end

endmodule