`timescale 1ns / 1ps

`include "defines.vh"

module NPC(
    input  wire [1:0]   op,
    input  wire [31:0]  pc,
    input  wire [1:0]   br,
    input  wire [31:0]  offset,
    input  wire [31:0]  jalr_pc,
    output reg  [31:0]  pc4,
    output reg  [31:0]  npc
);
 

always @(*) begin
    pc4 = pc + 4;
end

always @(*) begin
    if (br == `NPC_BR_DEFAULT) begin
        npc = pc;
    end

    else if (br == `NPC_BR_KEEP) begin
        npc = pc + 4;
    end

    else if (br == `NPC_BR_JUMP) begin
        if (op == `NPC_OP_OFFSET) begin
            npc = pc + offset;
        end

        else if (op == `NPC_OP_JALR) begin
            npc = jalr_pc;
        end
    end
end

endmodule
