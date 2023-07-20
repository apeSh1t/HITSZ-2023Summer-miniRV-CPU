`timescale 1ns / 1ps

`include "defines.vh"

module EX_MEM(
    input  wire        clk,
    input  wire        rst,
    input  wire        ex_have_inst_flag,
    input  wire        load_use_flag,
    input  wire        ex_wr_flag ,
    input  wire        ex_rR1_flag,
    input  wire        ex_rR2_flag,
    input  wire        ex_ram_we,
    input  wire        ex_rf_we,
    input  wire [2:0]  ex_rf_wsel,
    input  wire [4:0]  ex_rf_wr,
    input  wire [6:0]  ex_opcode,
    input  wire [31:0] ex_c,
    input  wire [31:0] ex_rD2,
    input  wire [31:0] ex_ext,
    input  wire [31:0] ex_pc4,
    input  wire [31:0] ex_pc,
    input  wire [31:0] ex_wdin,
    output reg         mem_have_inst_flag,
    output reg         mem_load_use_flag,
    output reg         mem_wr_flag ,
    output reg         mem_rR1_flag,
    output reg         mem_rR2_flag,
    output reg         mem_ram_we,
    output reg         mem_rf_we,
    output reg  [2:0]  mem_rf_wsel,
    output reg  [4:0]  mem_rf_wr,
    output reg  [6:0]  mem_opcode,
    output reg  [31:0] mem_c,
    output reg  [31:0] mem_rD2,
    output reg  [31:0] mem_ext,
    output reg  [31:0] mem_pc4,
    output reg  [31:0] mem_pc,
    output reg  [31:0] mem_wdin
); 

always @(posedge clk or posedge rst) begin
    if (rst) begin mem_ram_we <= 1'b0;      end
    else     begin mem_ram_we <= ex_ram_we; end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin mem_c <= 32'b0;          end
    else     begin mem_c <= ex_c;           end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin mem_rD2 <= 32'b0;        end
    else     begin mem_rD2 <= ex_rD2;       end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin mem_rf_we <= 1'b0;        end
    else     begin mem_rf_we <= ex_rf_we;       end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin mem_rf_wsel <= 3'b0;        end
    else     begin mem_rf_wsel <= ex_rf_wsel;       end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin mem_rf_wr <= 5'b0;        end
    else     begin mem_rf_wr <= ex_rf_wr;       end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin mem_ext <= 32'b0;        end
    else     begin mem_ext <= ex_ext;       end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin mem_pc4 <= 32'b0;        end
    else     begin mem_pc4 <= ex_pc4;       end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin mem_pc <= 32'b0;        end
    else     begin mem_pc <= ex_pc;       end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin mem_have_inst_flag <= 1'b0; end
    else     begin mem_have_inst_flag <= ex_have_inst_flag; end 
end

always @(posedge clk or posedge rst) begin
    if (rst) begin mem_wr_flag <= 1'b0; end
    else     begin mem_wr_flag <= ex_wr_flag; end 
end

always @(posedge clk or posedge rst) begin
    if (rst) begin mem_rR1_flag <= 1'b0; end
    else     begin mem_rR1_flag <= ex_rR1_flag; end 
end

always @(posedge clk or posedge rst) begin
    if (rst) begin mem_rR2_flag <= 1'b0; end
    else     begin mem_rR2_flag <= ex_rR2_flag; end 
end

always @(posedge clk or posedge rst) begin
    if (rst) begin mem_load_use_flag <= 1'b0; end
    else     begin mem_load_use_flag <= load_use_flag; end 
end

always @(posedge clk or posedge rst) begin
    if (rst) begin mem_opcode <= 7'b0; end
    else     begin mem_opcode <= ex_opcode; end 
end

always @(posedge clk or posedge rst) begin
    if (rst) begin mem_wdin <= 32'b0; end
    else     begin mem_wdin <= ex_wdin; end 
end

endmodule