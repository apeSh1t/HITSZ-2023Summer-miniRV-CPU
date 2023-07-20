onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib DRAM_opt

do {wave.do}

view wave
view structure
view signals

do {DRAM.udo}

run -all

quit -force
