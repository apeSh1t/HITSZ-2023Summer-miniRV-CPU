`timescale 1ns / 1ps

`include "defines.vh"

module ALUB_SEL(
    input  wire [1:0]  alub_sel,
    input  wire [31:0] rD2,
    input  wire [31:0] ext,
    output reg  [31:0] alub
);

always @(*) begin
    case(alub_sel)
        `ALUB_SEL_DEFAULT: begin alub = 32'b0; end
        `ALUB_SEL_RD2: begin alub = rD2; end
        `ALUB_SEL_EXT: begin alub = ext; end
    endcase
end

endmodule