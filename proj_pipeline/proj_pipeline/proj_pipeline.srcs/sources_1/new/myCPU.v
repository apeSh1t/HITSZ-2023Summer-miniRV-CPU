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

    //ALUA_SEL
    wire [31:0] ALUA_SEL_alua;
    ALUA_SEL ALUA_SEL(
        .load_use_flag(wb_load_use_flag),
        .wb_opcode(wb_opcode),
        .forwardA(forwardA),
        .ex_rD1(ex_A),
        .mem_c(mem_c),
        .wb_c(wb_c),
        //.mem_rdo(Bus_rdata),
        .wb_rdo(wb_rdo),
        .alua(ALUA_SEL_alua)
    );

    //ALUB_SEL
    wire [1:0]  ALUB_SEL_alub_sel;
    wire [31:0] ALUB_SEL_rD2;
    wire [31:0] ALUB_SEL_ext;
    wire [31:0] ALUB_SEL_alub;
    ALUB_SEL ALUB_SEL(
        .load_use_flag(wb_load_use_flag),
        .wb_opcode(wb_opcode),
        .forwardB(forwardB),
        .alub_sel(ALUB_SEL_alub_sel),
        .ex_rD2(ALUB_SEL_rD2),
        .ext(ALUB_SEL_ext),
        .mem_c(mem_c),
        .wb_c(wb_c),
        //.mem_rdo(Bus_rdata),
        .wb_rdo(wb_rdo),
        .alub(ALUB_SEL_alub)
    );

    //CONTROLLER
    wire [6:0] CONTROLLER_opcode  ;
    wire [2:0] CONTROLLER_funct3  ;
    wire [6:0] CONTROLLER_funct7  ;
    wire [2:0] CONTROLLER_sext_op ;
    wire [1:0] CONTROLLER_npc_op  ;
    wire       CONTROLLER_ram_we  ;
    wire       CONTROLLER_ram_re  ;
    wire [3:0] CONTROLLER_alu_op  ;
    wire [1:0] CONTROLLER_alub_sel;
    wire       CONTROLLER_rf_we   ;
    wire [2:0] CONTROLLER_rf_wsel ;
    wire       id_wr_flag ;
    wire       id_rR1_flag;
    wire       id_rR2_flag;
    CONTROLLER CONTROLLER(
        .opcode  (CONTROLLER_opcode),
        .funct3  (CONTROLLER_funct3),
        .funct7  (CONTROLLER_funct7),
        .sext_op (CONTROLLER_sext_op),
        .npc_op  (CONTROLLER_npc_op),
        .ram_we  (CONTROLLER_ram_we),
        .ram_re  (CONTROLLER_ram_re),
        .alu_op  (CONTROLLER_alu_op),
        .alub_sel(CONTROLLER_alub_sel),
        .rf_we   (CONTROLLER_rf_we),
        .rf_wsel (CONTROLLER_rf_wsel),
        .wr_flag (id_wr_flag),
        .rR1_flag(id_rR1_flag),
        .rR2_flag(id_rR2_flag)
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
        .load_use_flag(load_use_flag),
        .op     (NPC_op     ),
        .pc     (NPC_pc     ),
        .jump_pc(ex_pc),
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

    //SEXT
    wire [2:0]     SEXT_op;
    wire [31:0]    SEXT_din;
    wire [31:0]    SEXT_ext;
    SEXT SEXT(
        .cpu_clk(cpu_clk),
        .op(SEXT_op),
        .din(SEXT_din),
        .ext(SEXT_ext)
    );

    //IF_ID
    wire id_have_inst_flag;
    wire [31:0] id_inst;
    wire [31:0] id_pc4;
    wire [31:0] id_pc;
    IF_ID IF_ID(
        .clk(cpu_clk),
        .rst(cpu_rst),
        .load_use_flag(load_use_flag),
        .jump_flag(ALU_f),
        .if_inst(inst),
        .if_pc4(NPC_pc4),
        .if_pc(PC_pc),
        .id_have_inst_flag(id_have_inst_flag),
        .id_inst(id_inst),
        .id_pc4(id_pc4),
        .id_pc(id_pc)
    );

    //ID_EX
    wire ex_have_inst_flag;
    wire ex_wr_flag ;
    wire ex_rR1_flag;
    wire ex_rR2_flag;
    wire [1:0] ex_npc_op;
    wire       ex_ram_we;
    wire       ex_ram_re;
    wire [3:0] ex_alu_op;
    wire [1:0] ex_alub_sel;
    wire       ex_rf_we;
    wire [2:0] ex_rf_wsel;
    wire [4:0] ex_rf_wr;
    wire [4:0] ex_rR1;
    wire [4:0] ex_rR2;
    wire [6:0] ex_opcode;
    wire [31:0] ex_A;
    wire [31:0] ex_rD2;
    wire [31:0] ex_ext;
    wire [31:0] ex_pc4;
    wire [31:0] ex_pc;
    ID_EX ID_EX(
        .clk(cpu_clk),
        .rst(cpu_rst),
        .load_use_flag(load_use_flag),
        .id_have_inst_flag(id_have_inst_flag),
        .id_wr_flag (id_wr_flag),
        .id_rR1_flag(id_rR1_flag),
        .id_rR2_flag(id_rR2_flag),
        .jump_flag(ALU_f),
        .id_npc_op(CONTROLLER_npc_op),
        .id_ram_we(CONTROLLER_ram_we),
        .id_ram_re(CONTROLLER_ram_re),
        .id_alu_op(CONTROLLER_alu_op),
        .id_alub_sel(CONTROLLER_alub_sel),
        .id_rf_we(CONTROLLER_rf_we),
        .id_rf_wsel(CONTROLLER_rf_wsel),
        .id_rf_wr(id_inst[11:7]),
        .id_rR1(RF_rR1),
        .id_rR2(RF_rR2),
        .id_opcode(CONTROLLER_opcode),
        .id_rD1(RF_rD1),
        .id_rD2(RF_rD2),
        .id_ext(SEXT_ext),
        .id_pc4(id_pc4),
        .id_pc(id_pc),
        .ex_have_inst_flag(ex_have_inst_flag),
        .ex_wr_flag (ex_wr_flag),
        .ex_rR1_flag(ex_rR1_flag),
        .ex_rR2_flag(ex_rR2_flag),
        .ex_npc_op(ex_npc_op),
        .ex_ram_we(ex_ram_we),
        .ex_ram_re(ex_ram_re),
        .ex_alu_op(ex_alu_op),
        .ex_alub_sel(ex_alub_sel),
        .ex_rf_we(ex_rf_we),
        .ex_rf_wsel(ex_rf_wsel),
        .ex_rf_wr(ex_rf_wr),
        .ex_rR1(ex_rR1),
        .ex_rR2(ex_rR2),
        .ex_opcode(ex_opcode),
        .ex_A(ex_A),
        .ex_rD2(ex_rD2),
        .ex_ext(ex_ext),
        .ex_pc4(ex_pc4),
        .ex_pc(ex_pc)
    );

    //EX_MEM
    wire         mem_have_inst_flag;
    wire         mem_load_use_flag;
    wire         mem_wr_flag ;
    wire         mem_rR1_flag;
    wire         mem_rR2_flag;
    wire         mem_ram_we;
    wire  [6:0]  mem_opcode;
    wire  [31:0] mem_c;
    wire  [31:0] mem_rD2;
    wire         mem_rf_we;
    wire  [2:0]  mem_rf_wsel;
    wire  [4:0]  mem_rf_wr;
    wire  [31:0] mem_ext;
    wire  [31:0] mem_pc4;
    wire  [31:0] mem_pc;
    wire  [31:0] mem_wdin;
    EX_MEM EX_MEM(
        .clk(cpu_clk),
        .rst(cpu_rst),
        .ex_have_inst_flag(ex_have_inst_flag),
        .load_use_flag(load_use_flag),
        .ex_wr_flag (ex_wr_flag),
        .ex_rR1_flag(ex_rR1_flag),
        .ex_rR2_flag(ex_rR2_flag),
        .ex_ram_we(ex_ram_we),
        .ex_rf_we(ex_rf_we),
        .ex_rf_wsel(ex_rf_wsel),
        .ex_rf_wr(ex_rf_wr),
        .ex_opcode(ex_opcode),
        .ex_c(ALU_C),
        .ex_rD2(ex_rD2),
        .ex_ext(ex_ext),
        .ex_pc4(ex_pc4),
        .ex_pc(ex_pc),
        .ex_wdin(ex_wdin),
        .mem_have_inst_flag(mem_have_inst_flag),
        .mem_load_use_flag(mem_load_use_flag),
        .mem_wr_flag (mem_wr_flag),
        .mem_rR1_flag(mem_rR1_flag),
        .mem_rR2_flag(mem_rR2_flag),
        .mem_ram_we(mem_ram_we),
        .mem_rf_we(mem_rf_we),
        .mem_rf_wsel(mem_rf_wsel),
        .mem_rf_wr(mem_rf_wr),
        .mem_opcode(mem_opcode),
        .mem_c(mem_c),
        .mem_rD2(mem_rD2),
        .mem_ext(mem_ext),
        .mem_pc4(mem_pc4),
        .mem_pc(mem_pc),
        .mem_wdin(mem_wdin)
    );

    //MEM_WB
    wire        wb_have_inst_flag;
    wire        wb_load_use_flag;
    wire        wb_wr_flag ;
    wire        wb_rR1_flag;
    wire        wb_rR2_flag;
    wire        wb_rf_we;
    wire [2:0]  wb_rf_wsel;
    wire [4:0]  wb_rf_wr;
    wire [6:0]  wb_opcode;
    wire [31:0] wb_rdo;
    wire [31:0] wb_c;
    wire [31:0] wb_ext;
    wire [31:0] wb_pc4;
    wire [31:0] wb_pc;
    MEM_WB MEM_WB(
        .clk(cpu_clk),
        .rst(cpu_rst),
        .mem_have_inst_flag(mem_have_inst_flag),
        .mem_load_use_flag(mem_load_use_flag),
        .mem_wr_flag (mem_wr_flag),
        .mem_rR1_flag(mem_rR1_flag),
        .mem_rR2_flag(mem_rR2_flag),
        .mem_rf_we(mem_rf_we),
        .mem_rf_wsel(mem_rf_wsel),
        .mem_rf_wr(mem_rf_wr),
        .mem_rdo(Bus_rdata),
        .mem_opcode(mem_opcode),
        .mem_c(mem_c),
        .mem_ext(mem_ext),
        .mem_pc4(mem_pc4),
        .mem_pc(mem_pc),
        .wb_have_inst_flag(wb_have_inst_flag),
        .wb_load_use_flag(wb_load_use_flag),
        .wb_wr_flag (wb_wr_flag),
        .wb_rR1_flag(wb_rR1_flag),
        .wb_rR2_flag(wb_rR2_flag),
        .wb_rf_we(wb_rf_we),
        .wb_rf_wsel(wb_rf_wsel),
        .wb_rf_wr(wb_rf_wr),
        .wb_rdo(wb_rdo),
        .wb_opcode(wb_opcode),
        .wb_c(wb_c),
        .wb_ext(wb_ext),
        .wb_pc4(wb_pc4),
        .wb_pc(wb_pc)
    );

    //HAZARD_CONTROLLER
    wire [1:0] forwardA;
    wire [1:0] forwardB;
    wire       load_use_flag;
    wire [1:0] forward_ram;
    HAZARD_CONTROLLER HAZARD_CONTROLLER(
        .rst(cpu_rst),
        .mem_rf_we(mem_rf_we),
        .wb_rf_we(wb_rf_we),
        .ex_ram_re(ex_ram_re),
        .id_rR1_flag(id_rR1_flag),
        .id_rR2_flag(id_rR2_flag),
        .ex_rR1_flag(ex_rR1_flag),
        .ex_rR2_flag(ex_rR2_flag),
        .ex_wr_flag (ex_wr_flag ),
        .mem_wr_flag(mem_wr_flag),
        .wb_wr_flag (wb_wr_flag ),
        .id_rf_rR1(RF_rR1),
        .id_rf_rR2(RF_rR2),
        .ex_rf_rR1(ex_rR1),   
        .ex_rf_rR2(ex_rR2),   
        .ex_rf_wr(ex_rf_wr),    
        .mem_rf_wr(mem_rf_wr),   
        .wb_rf_wr(wb_rf_wr),   
        .ex_opcode(ex_opcode), 
        .forwardA(forwardA),
        .forwardB(forwardB),
        .forward_ram(forward_ram),
        .load_use_flag(load_use_flag)
    );

    // RAM_SEL
    wire [31:0] ex_wdin;
    RAM_SEL RAM_SEL(
        .rst(cpu_rst),
        .forward_ram(forward_ram),
        .mem_c(mem_c),
        .ex_rD2(ex_rD2),
        .wb_c(wb_c),
        .wdin(ex_wdin)
    );

    //assign
    assign NPC_op      = ex_npc_op;
    assign NPC_pc      = PC_pc;
    assign NPC_br      = ALU_f;
    assign NPC_offset  = ex_ext;
    assign NPC_jalr_pc = ALU_C;

    assign PC_din = NPC_npc;

    assign inst_addr = PC_pc[15:2];

    assign SEXT_op = CONTROLLER_sext_op;
    assign SEXT_din = id_inst;

    assign RF_WSEL_rf_wsel = wb_rf_wsel;
    assign RF_WSEL_pc4 = wb_pc4;
    assign RF_WSEL_ext = wb_ext;
    assign RF_WSEL_aluc = wb_c;
    assign RF_WSEL_rdo = wb_rdo;

    assign CONTROLLER_opcode = id_inst[6:0];
    assign CONTROLLER_funct3 = id_inst[14:12];
    assign CONTROLLER_funct7 = id_inst[31:25];

    assign RF_rR1 = id_inst[19:15];
    assign RF_rR2 = id_inst[24:20];
    assign RF_wR = wb_rf_wr;
    assign RF_wE = wb_rf_we;
    assign RF_wD = RF_WSEL_wD;

    assign ALUB_SEL_rD2 = ex_rD2;
    assign ALUB_SEL_ext = ex_ext;
    assign ALUB_SEL_alub_sel = ex_alub_sel;

    assign ALU_A = ALUA_SEL_alua;
    assign ALU_B = ALUB_SEL_alub;
    assign ALU_op = ex_alu_op;

    assign Bus_addr = mem_c;
    assign Bus_wen = mem_ram_we;
    assign Bus_wdata = mem_wdin;


`ifdef RUN_TRACE
    // Debug Interface
    assign debug_wb_have_inst =  wb_have_inst_flag/* TODO */;
    assign debug_wb_pc        = wb_pc  /* TODO */;
    assign debug_wb_ena       = wb_rf_we    /* TODO */;
    assign debug_wb_reg       = wb_rf_wr  /* TODO */;
    assign debug_wb_value     = RF_WSEL_wD  /* TODO */;
`endif

endmodule
