`timescale 1ns / 1ps

`include "defines.vh"

module HAZARD_CONTROLLER(
    input  wire rst,
    input  wire mem_rf_we,
    input  wire wb_rf_we,
    input  wire ex_ram_re,
    input  wire       id_rR1_flag,
    input  wire       id_rR2_flag,
    input  wire       ex_rR1_flag,
    input  wire       ex_rR2_flag,
    input  wire       ex_wr_flag,
    input  wire       mem_wr_flag,
    input  wire       wb_wr_flag,
    input  wire [4:0] id_rf_rR1,                 // IF/ID.Rs1
    input  wire [4:0] id_rf_rR2,                 // IF/ID.Rs2
    input  wire [4:0] ex_rf_rR1,           // ID/EX.Rs1
    input  wire [4:0] ex_rf_rR2,           // ID/EX.Rs2
    input  wire [4:0] ex_rf_wr,            // ID/EX.Rd
    input  wire [4:0] mem_rf_wr,        // EX/MEM.Rd
    input  wire [4:0] wb_rf_wr,         // MEM/WB.Rd
    input  wire [6:0] ex_opcode,
    output reg  [1:0] forwardA,
    output reg  [1:0] forwardB,
    output reg  [1:0] forward_ram,
    output reg        load_use_flag
);

always @(*) begin
    if (rst) begin forwardA = 2'b0; end
    else if (mem_rf_we && (mem_rf_wr != 0) && (mem_rf_wr == ex_rf_rR1) && ex_rR1_flag) begin forwardA = `HAZARD_CONTROLLER_FORWARD_EX_MEM; end
    else if (wb_rf_we && (wb_rf_wr != 0) && ~(mem_rf_we && (mem_rf_wr != 0) && (mem_rf_wr == ex_rf_rR1) && ex_rR1_flag) && (wb_rf_wr == ex_rf_rR1) && ex_rR1_flag) begin forwardA = `HAZARD_CONTROLLER_FORWARD_MEM_WB; end
    else begin forwardA = 2'b0; end
end

always @(*) begin
    if (rst) begin 
                forwardB = 2'b0; 
                forward_ram = 1'b0;
            end
    else if (mem_rf_we && (mem_rf_wr != 0) && (mem_rf_wr == ex_rf_rR2) && ex_rR2_flag) begin 
                                                                                            if (ex_opcode == `CONTROLLER_OPCODE_S) begin 
                                                                                                                                        forwardB = `HAZARD_CONTROLLER_FORWARD_ID_EX; 
                                                                                                                                        forward_ram = 2'b01;
                                                                                                                                    end
                                                                                            else                                   begin 
                                                                                                                                        forwardB = `HAZARD_CONTROLLER_FORWARD_EX_MEM; 
                                                                                                                                        forward_ram = 2'b0; 
                                                                                                                                    end
                                                                                        end
    else if (wb_rf_we && (wb_rf_wr != 0) && ~(mem_rf_we && (mem_rf_wr != 0) && (mem_rf_wr == ex_rf_rR2) && ex_rR2_flag) && (wb_rf_wr == ex_rf_rR2) && ex_rR2_flag) begin 
                                                                                                                                                                         if (ex_opcode == `CONTROLLER_OPCODE_S) begin 
                                                                                                                                                                             forwardB = `HAZARD_CONTROLLER_FORWARD_ID_EX; 
                                                                                                                                                                             forward_ram = 2'b10;
                                                                                                                                                                         end
                                                                                            else                                                                        begin 
                                                                                                                                                                             forwardB = `HAZARD_CONTROLLER_FORWARD_MEM_WB; 
                                                                                                                                                                             forward_ram = 2'b0; 
                                                                                                                                                                         end
                                                                                                                                                                    end
    else begin 
            forwardB = 2'b0; 
            forward_ram = 1'b0;
        end
end

always @(*) begin
    if (rst) begin load_use_flag = 1'b0; end
    //else if (ex_ram_re && (((ex_rf_wr == id_rf_rR1) && id_rR1_flag) || ((ex_rf_wr == id_rf_rR2) && id_rR2_flag))) begin load_use_flag = 1'b1; end 
    else if (ex_ram_re && ((ex_rf_wr == id_rf_rR1) || (ex_rf_wr == id_rf_rR2 ))) begin load_use_flag = 1'b1; end 
    else begin load_use_flag = 1'b0; end
end


endmodule