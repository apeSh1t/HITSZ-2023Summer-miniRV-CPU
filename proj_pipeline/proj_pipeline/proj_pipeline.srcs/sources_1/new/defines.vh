// Annotate this macro before synthesis
//`define RUN_TRACE

// TODO: 在此处定义你的宏
// PC
`define RESET_EN        32'h1

// NPC
`define NPC_OP_DEFAULT  32'h0
`define NPC_OP_PC4      32'h1
`define NPC_OP_OFFSET   32'h2
`define NPC_OP_JALR     32'h3

`define NPC_BR_DEFAULT  32'h0
`define NPC_BR_KEEP     32'h1
`define NPC_BR_JUMP     32'h2

// SEXT
`define SEXT_OP_DEFAULT 32'h0
`define SEXT_OP_R       32'h1
`define SEXT_OP_I       32'h2
`define SEXT_OP_S       32'h3
`define SEXT_OP_B       32'h4
`define SEXT_OP_U       32'h5
`define SEXT_OP_J       32'h6

// RF
`define RF_WE           32'h1

//RF_WSEL
`define RF_WSEL_DEFAULT 32'h0
`define RF_WSEL_PC4     32'h1
`define RF_WSEL_EXT     32'h2
`define RF_WSEL_ALUC    32'h3
`define RF_WSEL_RDO     32'h4

//ALUB_SEL
`define ALUB_SEL_DEFAULT 32'h0
`define ALUB_SEL_RD2    32'h1
`define ALUB_SEL_EXT    32'h2

//ALU
`define ALU_OP_DEFAULT  32'h0
`define ALU_OP_ADD      32'h1
`define ALU_OP_SUB      32'h2
`define ALU_OP_AND      32'h3
`define ALU_OP_OR       32'h4
`define ALU_OP_XOR      32'h5
`define ALU_OP_SLL      32'h6 
`define ALU_OP_SRL      32'h7
`define ALU_OP_SRA      32'h8
`define ALU_OP_BEQ      32'h9
`define ALU_OP_BNE      32'hA
`define ALU_OP_BLT      32'hB
`define ALU_OP_BGE      32'hC
`define ALU_OP_JAL      32'hD
`define ALU_OP_JALR     32'hE

//CONTROLLER
`define CONTROLLER_OPCODE_DEFAULT 7'b0000000
`define CONTROLLER_OPCODE_R       7'b0110011
`define CONTROLLER_OPCODE_I       7'b0010011
`define CONTROLLER_OPCODE_I_LW    7'b0000011
`define CONTROLLER_OPCODE_I_JALR  7'b1100111
`define CONTROLLER_OPCODE_S       7'b0100011
`define CONTROLLER_OPCODE_B       7'b1100011
`define CONTROLLER_OPCODE_U       7'b0110111
`define CONTROLLER_OPCODE_J       7'b1101111

//HAZARD_CONTROLLER
`define HAZARD_CONTROLLER_FORWARD_ID_EX  2'b00
`define HAZARD_CONTROLLER_FORWARD_EX_MEM 2'b01
`define HAZARD_CONTROLLER_FORWARD_MEM_WB 2'b10

// 外设I/O接口电路的端口地�???
`define PERI_ADDR_DIG   32'hFFFF_F000
`define PERI_ADDR_LED   32'hFFFF_F060
`define PERI_ADDR_SW    32'hFFFF_F070
`define PERI_ADDR_BTN   32'hFFFF_F078
