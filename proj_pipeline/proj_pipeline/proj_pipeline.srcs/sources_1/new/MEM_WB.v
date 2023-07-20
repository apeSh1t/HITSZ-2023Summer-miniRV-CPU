`timescale 1ns / 1ps

`include "defines.vh"

module MEM_WB(
    input  wire clk,
    input  wire rst,
    input  wire mem_have_inst_flag,
    input  wire mem_load_use_flag,
    input  wire        mem_wr_flag ,
    input  wire        mem_rR1_flag,
    input  wire        mem_rR2_flag,
    input  wire        mem_rf_we,
    input  wire [2:0]  mem_rf_wsel,
    input  wire [4:0]  mem_rf_wr,
    input  wire [6:0]  mem_opcode,
    input  wire [31:0] mem_rdo,
    input  wire [31:0] mem_c,
    input  wire [31:0] mem_ext,
    input  wire [31:0] mem_pc4,
    input  wire [31:0] mem_pc,
    output reg         wb_have_inst_flag,
    output reg         wb_load_use_flag,
    output reg         wb_wr_flag ,
    output reg         wb_rR1_flag,
    output reg         wb_rR2_flag,
    output reg         wb_rf_we,
    output reg  [2:0]  wb_rf_wsel,
    output reg  [4:0]  wb_rf_wr,
    output reg  [6:0]  wb_opcode,
    output reg  [31:0] wb_rdo,
    output reg  [31:0] wb_c,
    output reg  [31:0] wb_ext,
    output reg  [31:0] wb_pc4,
    output reg  [31:0] wb_pc
);

always @(posedge clk or posedge rst) begin
    if (rst) begin wb_rdo <= 32'b0;        end
    else     begin wb_rdo <= mem_rdo;      end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin wb_c <= 32'b0;        end
    else     begin wb_c <= mem_c;        end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin wb_rf_we <= 1'b0;        end
    else     begin wb_rf_we <= mem_rf_we;        end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin wb_rf_wsel <= 3'b0;        end
    else     begin wb_rf_wsel <= mem_rf_wsel;        end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin wb_rf_wr <= 5'b0;        end
    else     begin wb_rf_wr <= mem_rf_wr;        end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin wb_ext <= 32'b0;        end
    else     begin wb_ext <= mem_ext;        end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin wb_pc4 <= 32'b0;        end
    else     begin wb_pc4 <= mem_pc4;        end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin wb_pc <= 32'b0;        end
    else     begin wb_pc <= mem_pc;        end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin wb_have_inst_flag <= 1'b0; end
    else     begin wb_have_inst_flag <= mem_have_inst_flag; end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin wb_wr_flag <= 1'b0; end
    else     begin wb_wr_flag <= mem_wr_flag; end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin wb_rR1_flag <= 1'b0; end
    else     begin wb_rR1_flag <= mem_rR1_flag; end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin wb_rR2_flag <= 1'b0; end
    else     begin wb_rR2_flag <= mem_rR2_flag; end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin wb_load_use_flag <= 1'b0; end
    else     begin wb_load_use_flag <= mem_load_use_flag; end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin wb_opcode <= 7'b0; end
    else     begin wb_opcode <= mem_opcode; end
end

endmodule 