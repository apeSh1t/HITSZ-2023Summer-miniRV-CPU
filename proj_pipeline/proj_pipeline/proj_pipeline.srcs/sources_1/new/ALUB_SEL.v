`timescale 1ns / 1ps

`include "defines.vh"

module ALUB_SEL(
    input  wire        load_use_flag,
    input  wire [6:0]  wb_opcode,
    input  wire [1:0]  forwardB,
    input  wire [1:0]  alub_sel,
    input  wire [31:0] ex_rD2,
    input  wire [31:0] ext,
    input  wire [31:0] mem_c,
    input  wire [31:0] wb_c,
    input  wire [31:0] wb_rdo,
    output reg  [31:0] alub
);

always @(*) begin
    if (forwardB == `HAZARD_CONTROLLER_FORWARD_ID_EX) begin
        case(alub_sel)
            `ALUB_SEL_DEFAULT: begin alub = 32'b0; end
            `ALUB_SEL_RD2: begin alub = ex_rD2; end
            `ALUB_SEL_EXT: begin alub = ext; end
            default      : begin alub = 32'b0; end
        endcase
    end
    else if (forwardB == `HAZARD_CONTROLLER_FORWARD_EX_MEM) begin alub = mem_c; end
    else if (forwardB == `HAZARD_CONTROLLER_FORWARD_MEM_WB) begin 
                                                                if (load_use_flag || (wb_opcode == `CONTROLLER_OPCODE_I_LW)) begin alub = wb_rdo; end
                                                                else               begin alub = wb_c; end
                                                            end
    else                                                    begin alub = 32'b0; end
end

endmodule