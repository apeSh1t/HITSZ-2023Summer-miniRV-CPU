`timescale 1ns / 1ps

`include "defines.vh"

module IF_ID(
    input  wire clk,
    input  wire rst,
    input  wire load_use_flag,
    input  wire [1:0]  jump_flag,
    input  wire [31:0] if_inst,
    input  wire [31:0] if_pc4,
    input  wire [31:0] if_pc,
    output reg         id_have_inst_flag,
    output reg  [31:0] id_inst,
    output reg  [31:0] id_pc4,
    output reg  [31:0] id_pc
);

always @(posedge clk or posedge rst) begin
    if (~rst) begin
        if (load_use_flag) begin id_inst <= id_inst; end
        else if (jump_flag == `NPC_BR_JUMP) begin id_inst <= 32'b0; end
        else               begin id_inst <= if_inst; end
    end
    else begin
        id_inst <= 32'b0;
    end
end

always @(posedge clk or posedge rst) begin
    if (~rst) begin
        if (load_use_flag) begin id_pc4 <= id_pc4; end
        else if (jump_flag == `NPC_BR_JUMP) begin id_pc4 <= 32'b0; end
        else               begin id_pc4 <= if_pc4; end
    end
    else begin
        id_pc4 <= 32'b0;
    end
end

always @(posedge clk or posedge rst) begin
    if (~rst) begin
        if (load_use_flag) begin id_pc <= id_pc; end
        else if (jump_flag == `NPC_BR_JUMP) begin id_pc <= 32'b0; end
        else               begin id_pc <= if_pc; end
    end
    else begin
        id_pc <= 32'b0;
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin id_have_inst_flag <= 1'b0; end
    else if (load_use_flag)     begin id_have_inst_flag <= 1'b1; end
    else if (jump_flag == `NPC_BR_JUMP) begin id_have_inst_flag <= 1'b0; end
    else     begin id_have_inst_flag <= 1'b1; end
end

endmodule