`timescale 1ns / 1ps

`include "defines.vh"

module RF(
    input  wire [4:0]  rR1,            // read address1
    input  wire [4:0]  rR2,            // read address2
    input  wire [4:0]  wR,             // write address
    input  wire        wE,             // write enable
    input  wire [31:0] wD,             // write data
    input  wire        cpu_clk,
    input  wire        rst,
    output reg  [31:0] rD1,
    output reg  [31:0] rD2
);

reg [31:0] reg_heap [0:31];

always @(*) begin
    if(rst == 1'b1) begin
        rD1 = 32'b0;
        rD2 = 32'b0;
    end
    rD1 = reg_heap[rR1];
    rD2 = reg_heap[rR2];
end

always @(posedge cpu_clk ) begin
//    if (rst == 1'b1) begin
//        reg_heap[0] <= 32'b0;
//        reg_heap[1] <= 32'b0;
//        reg_heap[2] <= 32'b0;
//        reg_heap[3] <= 32'b0;
//        reg_heap[4] <= 32'b0;
//        reg_heap[5] <= 32'b0;
//        reg_heap[6] <= 32'b0;
//        reg_heap[7] <= 32'b0;
//        reg_heap[8] <= 32'b0;
//        reg_heap[9] <= 32'b0;
//        reg_heap[10] <= 32'b0;
//        reg_heap[11] <= 32'b0;
//        reg_heap[12] <= 32'b0;
//        reg_heap[13] <= 32'b0;
//        reg_heap[14] <= 32'b0;
//        reg_heap[15] <= 32'b0;
//        reg_heap[16] <= 32'b0;
//        reg_heap[17] <= 32'b0;
//        reg_heap[18] <= 32'b0;
//        reg_heap[19] <= 32'b0;
//        reg_heap[20] <= 32'b0;
//        reg_heap[21] <= 32'b0;
//        reg_heap[22] <= 32'b0;
//        reg_heap[23] <= 32'b0;
//        reg_heap[24] <= 32'b0;
//        reg_heap[25] <= 32'b0;
//        reg_heap[26] <= 32'b0;
//        reg_heap[27] <= 32'b0;
//        reg_heap[28] <= 32'b0;
//        reg_heap[29] <= 32'b0;
//        reg_heap[30] <= 32'b0;
//        reg_heap[31] <= 32'b0; 
//    end
    if ((wE == `RF_WE) && (wR != 32'b0)) begin
        reg_heap[wR] <= wD;
    end
end


endmodule