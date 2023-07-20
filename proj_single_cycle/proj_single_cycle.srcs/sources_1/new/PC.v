`timescale 1ns / 1ps

`include "defines.vh"

module PC(
    input wire         cpu_clk,
    input wire         rst,
    input wire [31:0]  din,
    output reg [31:0]  pc
);

reg [1:0] flag = 2'b0;

always @(posedge cpu_clk) begin
    if (rst == `RESET_EN) begin
        flag <= 2'b00;
    end
    else if (flag == 2'b00) begin
        flag <= 2'b01;
    end
    else if (flag >= 2'b01) begin
        flag <= 2'b10;
    end
end

always @(posedge cpu_clk or posedge rst) begin
    if (rst == `RESET_EN) begin
        pc <= 32'h0000_0000;
    end
    else if (flag >= 2'b01) begin
        pc <= din;
    end
end

endmodule