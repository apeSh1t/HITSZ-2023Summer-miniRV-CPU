onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib IROM_opt

do {wave.do}

view wave
view structure
view signals

do {IROM.udo}

run -all

quit -force
