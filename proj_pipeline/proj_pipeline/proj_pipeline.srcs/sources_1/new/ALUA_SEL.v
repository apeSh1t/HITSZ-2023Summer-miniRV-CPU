`timescale 1ns / 1ps

`include "defines.vh"

module ALUA_SEL(
    input  wire       load_use_flag,
    input  wire [6:0] wb_opcode,
    input  wire [1:0] forwardA,
    input  wire [31:0] ex_rD1,
    input  wire [31:0] mem_c,
    input  wire [31:0] wb_c,
    input  wire [31:0] wb_rdo,
    output reg  [31:0] alua
);

always @(*) begin
    case (forwardA)
        `HAZARD_CONTROLLER_FORWARD_ID_EX  : begin alua = ex_rD1; end
        `HAZARD_CONTROLLER_FORWARD_EX_MEM : begin alua = mem_c; end
        `HAZARD_CONTROLLER_FORWARD_MEM_WB : begin 
                                                if (load_use_flag || (wb_opcode == `CONTROLLER_OPCODE_I_LW)) begin alua = wb_rdo; end
                                                else               begin alua = wb_c; end
                                            end
        default                           : begin alua = 32'b0; end
    endcase
end

endmodule