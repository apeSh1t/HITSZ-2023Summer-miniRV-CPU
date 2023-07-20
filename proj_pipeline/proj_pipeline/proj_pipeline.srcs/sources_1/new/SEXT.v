`timescale 1ns / 1ps

`include "defines.vh"

module SEXT(
    input wire           cpu_clk,
    input wire [2:0]     op,
    input wire [31:0]    din,
    output reg [31:0]    ext
);

always @(*) begin
    case (op)
        `SEXT_OP_R: begin ext = 32'b0;                                                end
        //`SEXT_OP_I: begin ext = {{20{din[31]}}, din[31:20]};                          end
        `SEXT_OP_I: begin ext = $signed({din[31], din[31:20]});                          end
        `SEXT_OP_S: begin ext = {{20{din[31]}}, din[31:25], din[11:7]};               end
        // `SEXT_OP_B: begin ext = {{20{din[31]}}, din[7], din[30:25], din[11:8], 1'b0}; end
        `SEXT_OP_B: begin ext = $signed({din[31], din[7], din[30:25], din[11:8], 1'b0}); end
        `SEXT_OP_U: begin ext = {din[31:12], 12'b0};                                  end
        `SEXT_OP_J: begin ext = {{11{din[31]}}, din[19:12], din[20], din[30:21], 1'b0};     end
        default   : begin ext = 32'b0; end 
    endcase
end

endmodule
