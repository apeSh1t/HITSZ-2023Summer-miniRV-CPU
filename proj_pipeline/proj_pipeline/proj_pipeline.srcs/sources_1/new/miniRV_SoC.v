`timescale 1ns / 1ps

`include "defines.vh"

module miniRV_SoC (
    input  wire         fpga_rst,   // High active
    input  wire         fpga_clk,
    input  wire [23:0]  switches,
    input  wire [ 4:0]  button,
    output wire [ 7:0]  dig_en,
    output wire         DN_A,
    output wire         DN_B,
    output wire         DN_C,
    output wire         DN_D,
    output wire         DN_E,
    output wire         DN_F,
    output wire         DN_G,
    output wire         DN_DP,
    output wire [23:0]  led

`ifdef RUN_TRACE
    ,// Debug Interface
    output wire         debug_wb_have_inst, // 当前时钟周期是否有指令写�???? (对单周期CPU，可在复位后恒置1)
    output wire [31:0]  debug_wb_pc,        // 当前写回的指令的PC (若wb_have_inst=0，此项可为任意�??)
    output              debug_wb_ena,       // 指令写回时，寄存器堆的写使能 (若wb_have_inst=0，此项可为任意�??)
    output wire [ 4:0]  debug_wb_reg,       // 指令写回时，写入的寄存器�???? (若wb_ena或wb_have_inst=0，此项可为任意�??)
    output wire [31:0]  debug_wb_value      // 指令写回时，写入寄存器的�???? (若wb_ena或wb_have_inst=0，此项可为任意�??)
`endif
);

    wire        pll_lock;
    wire        pll_clk;
    wire        cpu_clk;

    // Interface between CPU and IROM
`ifdef RUN_TRACE
    wire [15:0] inst_addr;
`else
    wire [13:0] inst_addr;
`endif
    wire [31:0] inst;

    // Interface between CPU and Bridge
    wire [31:0] Bus_rdata;
    wire [31:0] Bus_addr;
    wire        Bus_wen;
    wire [31:0] Bus_wdata;
    
    // Interface between bridge and DRAM
    // wire         rst_bridge2dram;
    wire         clk_bridge2dram;
    wire [31:0]  addr_bridge2dram;
    wire [31:0]  rdata_dram2bridge;
    wire         wen_bridge2dram;
    wire [31:0]  wdata_bridge2dram;
    
    // Interface between bridge and peripherals
    // TODO: 在此定义总线桥与外设I/O接口电路模块的连接信�????
    //
    wire        Bridge_rst_to_dig;
    wire        Bridge_clk_to_dig;
    wire [11:0] Bridge_addr_to_dig;
    wire        Bridge_wen_to_dig;
    wire [31:0] Bridge_wdata_to_dig;

    wire        Bridge_rst_to_led;
    wire        Bridge_clk_to_led;
    wire [11:0] Bridge_addr_to_led;
    wire        Bridge_wen_to_led;
    wire [31:0] Bridge_wdata_to_led;

    wire        Bridge_rst_to_sw;
    wire        Bridge_clk_to_sw;
    wire [11:0] Bridge_addr_to_sw;
    wire [31:0] Bridge_rdata_from_sw;

    wire        Bridge_rst_to_btn;
    wire        Bridge_clk_to_btn;
    wire [11:0] Bridge_addr_to_btn;
    wire [31:0] Bridge_rdata_from_btn;
    

    
`ifdef RUN_TRACE
    // Trace调试时，直接使用外部输入时钟
    assign cpu_clk = fpga_clk;
`else
    // 下板时，使用PLL分频后的时钟
    assign cpu_clk = pll_clk & pll_lock;
    cpuclk Clkgen (
        // .resetn     (!fpga_rst),
        .clk_in1    (fpga_clk),
        .clk_out1   (pll_clk),
        .locked     (pll_lock)
    );
`endif
    
    myCPU Core_cpu (
        .cpu_rst            (fpga_rst),
        .cpu_clk            (cpu_clk),

        // Interface to IROM
        .inst_addr          (inst_addr),
        .inst               (inst),

        // Interface to Bridge
        .Bus_addr           (Bus_addr),
        .Bus_rdata          (Bus_rdata),
        .Bus_wen            (Bus_wen),
        .Bus_wdata          (Bus_wdata)

`ifdef RUN_TRACE
        ,// Debug Interface
        .debug_wb_have_inst (debug_wb_have_inst),
        .debug_wb_pc        (debug_wb_pc),
        .debug_wb_ena       (debug_wb_ena),
        .debug_wb_reg       (debug_wb_reg),
        .debug_wb_value     (debug_wb_value)
`endif
    );
    
    IROM Mem_IROM (
        .a          (inst_addr),
        .spo        (inst)
    );
    
    Bridge Bridge (       
        // Interface to CPU
        .rst_from_cpu       (fpga_rst),
        .clk_from_cpu       (cpu_clk),
        .addr_from_cpu      (Bus_addr),
        .wen_from_cpu       (Bus_wen),
        .wdata_from_cpu     (Bus_wdata),
        .rdata_to_cpu       (Bus_rdata),
        
        // Interface to DRAM
        // .rst_to_dram    (rst_bridge2dram),
        .clk_to_dram        (clk_bridge2dram),
        .addr_to_dram       (addr_bridge2dram),
        .rdata_from_dram    (rdata_dram2bridge),
        .wen_to_dram        (wen_bridge2dram),
        .wdata_to_dram      (wdata_bridge2dram),
        
        // Interface to 7-seg digital LEDs
        .rst_to_dig         (Bridge_rst_to_dig),
        .clk_to_dig         (Bridge_clk_to_dig),
        .addr_to_dig        (Bridge_addr_to_dig),
        .wen_to_dig         (Bridge_wen_to_dig),
        .wdata_to_dig       (Bridge_wdata_to_dig),

        // Interface to LEDs
        .rst_to_led         (Bridge_rst_to_led),
        .clk_to_led         (Bridge_clk_to_led),
        .addr_to_led        (Bridge_addr_to_led),
        .wen_to_led         (Bridge_wen_to_led),
        .wdata_to_led       (Bridge_wdata_to_led),

        // Interface to switches
        .rst_to_sw          (Bridge_rst_to_sw),
        .clk_to_sw          (Bridge_clk_to_sw),
        .addr_to_sw         (Bridge_addr_to_sw),
        .rdata_from_sw      (Bridge_rdata_from_sw),

        // Interface to buttons
        .rst_to_btn         (Bridge_rst_to_btn),
        .clk_to_btn         (Bridge_clk_to_btn),
        .addr_to_btn        (Bridge_addr_to_btn),
        .rdata_from_btn     (Bridge_rdata_from_btn)
    );

    wire [31:0] waddr_temp = addr_bridge2dram - 32'h4000;

    DRAM Mem_DRAM (
        .clk        (clk_bridge2dram),
        .a          (waddr_temp[15:2]),
        .spo        (rdata_dram2bridge),
        .we         (wen_bridge2dram),
        .d          (wdata_bridge2dram)
    );
    
    // TODO: 在此实例化你的外设I/O接口电路模块
    //
    DIGITAL_LED Digital_LED(
        .rst(Bridge_rst_to_dig),
        .clk(Bridge_clk_to_dig),
        .wen(Bridge_wen_to_dig),
        .addr(Bridge_addr_to_dig),
        .wdata(Bridge_wdata_to_dig),
        .en(dig_en),
        .DN_A(DN_A),
        .DN_B(DN_B),
        .DN_C(DN_C),
        .DN_D(DN_D),
        .DN_E(DN_E),
        .DN_F(DN_F),
        .DN_G(DN_G),
        .DN_DP(DN_DP)
    );

    LED Led(
        .rst(Bridge_rst_to_led),
        .clk(Bridge_clk_to_led),
        .wen(Bridge_wen_to_led),
        .addr(Bridge_addr_to_led),
        .wdata(Bridge_wdata_to_led),
        .led(led)
    );

    SWITCH Switch(
        .rst(Bridge_rst_to_sw),
        .clk(Bridge_clk_to_sw),
        .addr(Bridge_addr_to_sw),
        .switches(switches),
        .rdata(Bridge_rdata_from_sw)
    );

    BUTTON Button(
        .rst(Bridge_rst_to_btn),
        .clk(Bridge_clk_to_btn),
        .addr(Bridge_addr_to_btn),
        .button(button),
        .rdata(Bridge_rdata_from_btn)
    );


endmodule
