`timescale 1ns / 1ps

`include "defines.vh"

module myCPU (
    input  wire         cpu_rst,
    input  wire         cpu_clk,

    // Interface to IROM
    output wire [13:0]  inst_addr,
    input  wire [31:0]  inst,
    
    // Interface to Bridge
    output wire [31:0]  Bus_addr,
    input  wire [31:0]  Bus_rdata,
    output wire         Bus_wen,
    output wire [31:0]  Bus_wdata

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst,
    output wire [31:0]  debug_wb_pc,
    output              debug_wb_ena,
    output wire [ 4:0]  debug_wb_reg,
    output wire [31:0]  debug_wb_value
`endif
);

    // TODO: 完成你自己的单周期CPU设计
    //ALU
    wire [31:0] ALU_A;
    wire [31:0] ALU_B;
    wire [3:0]  ALU_op;
    wire [31:0] ALU_C;
    wire [1:0]  ALU_f;
    ALU ALU(
        .A(ALU_A),
        .B(ALU_B),
        .op(ALU_op),
        .C(ALU_C),
        .f(ALU_f)
    );

    //ALUB_SEL
    wire [1:0]  ALUB_SEL_alub_sel;
    wire [31:0] ALUB_SEL_rD2;
    wire [31:0] ALUB_SEL_ext;
    wire [31:0] ALUB_SEL_alub;
    ALUB_SEL ALUB_SEL(
        .alub_sel(ALUB_SEL_alub_sel),
        .rD2(ALUB_SEL_rD2),
        .ext(ALUB_SEL_ext),
        .alub(ALUB_SEL_alub)
    );

    //CONTROLLER
    wire [6:0] CONTROLLER_opcode  ;
    wire [2:0] CONTROLLER_funct3  ;
    wire [6:0] CONTROLLER_funct7  ;
    wire [2:0] CONTROLLER_sext_op ;
    wire [1:0] CONTROLLER_npc_op  ;
    wire       CONTROLLER_ram_we  ;
    wire [3:0] CONTROLLER_alu_op  ;
    wire [1:0] CONTROLLER_alub_sel;
    wire       CONTROLLER_rf_we   ;
    wire [2:0] CONTROLLER_rf_wsel ;
    CONTROLLER CONTROLLER(
        .opcode  (CONTROLLER_opcode),
        .funct3  (CONTROLLER_funct3),
        .funct7  (CONTROLLER_funct7),
        .sext_op (CONTROLLER_sext_op),
        .npc_op  (CONTROLLER_npc_op),
        .ram_we  (CONTROLLER_ram_we),
        .alu_op  (CONTROLLER_alu_op),
        .alub_sel(CONTROLLER_alub_sel),
        .rf_we   (CONTROLLER_rf_we),
        .rf_wsel (CONTROLLER_rf_wsel)
    );

    //NPC
    wire [1:0]   NPC_op     ;
    wire [31:0]  NPC_pc     ;
    wire [1:0]   NPC_br     ;
    wire [31:0]  NPC_offset ;
    wire [31:0]  NPC_jalr_pc;
    wire [31:0]  NPC_pc4    ;
    wire [31:0]  NPC_npc    ;
    NPC NPC(
        .op     (NPC_op     ),
        .pc     (NPC_pc     ),
        .br     (NPC_br     ),
        .offset (NPC_offset ),
        .jalr_pc(NPC_jalr_pc),
        .pc4    (NPC_pc4    ),
        .npc    (NPC_npc    )
    );

    //PC
    wire [31:0]  PC_din;
    wire [31:0]   PC_pc ;
    PC PC(
        .cpu_clk(cpu_clk),
        .rst(cpu_rst),
        .din(PC_din),
        .pc(PC_pc)
    );

    //RF_WSEL
    wire [2:0]  RF_WSEL_rf_wsel;
    wire [31:0] RF_WSEL_pc4    ;
    wire [31:0] RF_WSEL_ext    ;
    wire [31:0] RF_WSEL_aluc   ;
    wire [31:0] RF_WSEL_rdo    ;
    wire [31:0] RF_WSEL_wD     ;
    RF_WSEL RF_WSEL(
        .rf_wsel(RF_WSEL_rf_wsel),
        .pc4    (RF_WSEL_pc4    ),
        .ext    (RF_WSEL_ext    ),
        .aluc   (RF_WSEL_aluc   ),
        .rdo    (RF_WSEL_rdo    ),
        .cpu_clk(cpu_clk        ),
        .wD     (RF_WSEL_wD     )
    );

    //RF
    wire [4:0]  RF_rR1;
    wire [4:0]  RF_rR2;
    wire [4:0]  RF_wR ;
    wire        RF_wE ;
    wire [31:0] RF_wD ;
    wire [31:0] RF_rD1;
    wire [31:0] RF_rD2;
    RF RF(
        .rR1    (RF_rR1 ),
        .rR2    (RF_rR2 ),
        .wR     (RF_wR  ),
        .wE     (RF_wE  ),
        .wD     (RF_wD  ),
        .cpu_clk(cpu_clk),
        .rst    (cpu_rst),
        .rD1    (RF_rD1 ),
        .rD2    (RF_rD2 )
    );

    //SEXT SEXT
    wire [2:0]     SEXT_op;
    wire [31:0]    SEXT_din;
    wire [31:0]    SEXT_ext;
    SEXT SEXT(
        .cpu_clk(cpu_clk),
        .op(SEXT_op),
        .din(SEXT_din),
        .ext(SEXT_ext)
    );

    //assign
    assign NPC_op      = CONTROLLER_npc_op;
    assign NPC_pc      = PC_pc;
    assign NPC_br      = ALU_f;
    assign NPC_offset  = SEXT_ext;
    assign NPC_jalr_pc = ALU_C;

    assign PC_din = NPC_npc;

    assign inst_addr = PC_pc[15:2];

    assign SEXT_op = CONTROLLER_sext_op;
    assign SEXT_din = inst;

    assign RF_WSEL_rf_wsel = CONTROLLER_rf_wsel;
    assign RF_WSEL_pc4 = NPC_pc4;
    assign RF_WSEL_ext = SEXT_ext;
    assign RF_WSEL_aluc = ALU_C;
    assign RF_WSEL_rdo = Bus_rdata;

    assign CONTROLLER_opcode = inst[6:0];
    assign CONTROLLER_funct3 = inst[14:12];
    assign CONTROLLER_funct7 = inst[31:25];

    assign RF_rR1 = inst[19:15];
    assign RF_rR2 = inst[24:20];
    assign RF_wR = inst[11:7];
    assign RF_wE = CONTROLLER_rf_we;
    assign RF_wD = RF_WSEL_wD;

    assign ALUB_SEL_rD2 = RF_rD2;
    assign ALUB_SEL_ext = SEXT_ext;
    assign ALUB_SEL_alub_sel = CONTROLLER_alub_sel;

    assign ALU_A = RF_rD1;
    assign ALU_B = ALUB_SEL_alub;
    assign ALU_op = CONTROLLER_alu_op;

    assign Bus_addr = ALU_C;
    assign Bus_wen = CONTROLLER_ram_we;
    assign Bus_wdata = RF_rD2;


`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst = 1          /* TODO */;
    assign debug_wb_pc        = PC_pc      /* TODO */;
    assign debug_wb_ena       = RF_wE      /* TODO */;
    assign debug_wb_reg       = RF_wR      /* TODO */;
    assign debug_wb_value     = RF_wD      /* TODO */;
`endif

endmodule
