# HITSZ-2023Summer-miniRV-CPU
> HITSZ 2023夏季学期基于miniRV 指令集的单周期和五级流水线CPU开发



```
│   data_ram.coe                               --- 提供的ram数据
│   inst_rom.coe                               --- 提供的rom指令（用于trace仿真）
│   lab1.asm                                   --- 实验一写的计算器汇编
│   
├───proj_pipeline                              --- 五级流水线文件
│   │   proj_pipeline.rar
│   │   
│   └───proj_pipeline
│       │   data_ram.coe                      
│       │   program.coe                        --- 实现多种计算功能的16进制汇编（用于上板）
│       │   proj_pipeline.xpr                  --- vivado，启动！
│       │   
│       ├───proj_pipeline.sim
│       └───proj_pipeline.srcs
│           ├───constrs_1                      --- 引脚xdc文件
│           │   └───new
│           │           miniRV_clock.xdc
│           │           miniRV_SoC.xdc
│           │           
│           ├───sim_1                          --- 上板仿真
│           │   └───new
│           │           miniRV_sim.v
│           │           
│           └───sources_1                     
│               └───new                        --- 源代码
│                       ALU.v
│                       ALUA_SEL.v
│                       ALUB_SEL.v
│                       Bridge.v
│                       BUTTON.v
│                       CONTROLLER.v
│                       defines.vh
│                       DIGITAL_LED.v
│                       EX_MEM.v
│                       HAZARD_CONTROLLER.v    --- 冒险控制器
│                       ID_EX.v
│                       IF_ID.v
│                       LED.v
│                       MEM_WB.v
│                       miniRV_SoC.v
│                       myCPU.v
│                       NPC.v
│                       PC.v
│                       RAM_SEL.v
│                       RF.V
│                       RF_WSEL.v
│                       SEXT.v
│                       SWITCH.v
│                       
└───proj_single_cycle                           --- 单周期
    │   miniRV_sim_behav.wcfg
    │   program.coe
    │   proj_single_cycle.xpr
    │   
    ├───.Xil
    │                           
    └───proj_single_cycle.srcs
        ├───constrs_1
        │   └───new
        │           miniRV_clock.xdc
        │           miniRV_SoC.xdc
        │           
        ├───sim_1
        │   └───new
        │           cpuclk_sim.v
        │           miniRV_sim.v
        │           
        └───sources_1
            ├───ip
            └───new
                    ALU.v
                    ALUB_SEL.v
                    Bridge.v
                    BUTTON.v
                    CONTROLLER.v
                    defines.vh
                    DIGITAL_LED.v
                    LED.v
                    miniRV_SoC.v
                    myCPU.v
                    NPC.v
                    PC.v
                    RF.V
                    RF_WSEL.v
                    SEXT.v
                    SWITCH.v
```                 
