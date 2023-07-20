`timescale 1ns / 1ps

`include "defines.vh"

module RF_WSEL(
    input  wire [2:0]  rf_wsel,
    input  wire [31:0] pc4,
    input  wire [31:0] ext,
    input  wire [31:0] aluc,
    input  wire [31:0] rdo,
    input  wire        cpu_clk,
    output reg  [31:0] wD
);

always @(*) begin
    case (rf_wsel) 
        `RF_WSEL_DEFAULT: begin wD = 32'b0; end
        `RF_WSEL_PC4:  begin wD = pc4;  end
        `RF_WSEL_EXT:  begin wD = ext;  end
        `RF_WSEL_ALUC: begin wD = aluc; end
        `RF_WSEL_RDO:  begin wD = rdo;  end
    endcase
end

endmodule