onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/CLK
add wave -noupdate /system_tb/DUT/CPU/DP/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/opCode
add wave -noupdate /system_tb/DUT/CPU/DP/rs
add wave -noupdate /system_tb/DUT/CPU/DP/rt
add wave -noupdate /system_tb/DUT/CPU/DP/rd
add wave -noupdate /system_tb/DUT/CPU/DP/imm
add wave -noupdate /system_tb/DUT/CPU/DP/shamt
add wave -noupdate /system_tb/DUT/CPU/DP/funct
add wave -noupdate /system_tb/DUT/CPU/DP/PC
add wave -noupdate /system_tb/DUT/CPU/DP/PC4
add wave -noupdate /system_tb/DUT/CPU/DP/interPC
add wave -noupdate /system_tb/DUT/CPU/DP/nextPC
add wave -noupdate /system_tb/DUT/CPU/DP/jAddr
add wave -noupdate /system_tb/DUT/CPU/DP/branchFlag
add wave -noupdate /system_tb/DUT/RAM/ramif/ramREN
add wave -noupdate /system_tb/DUT/RAM/ramif/ramWEN
add wave -noupdate /system_tb/DUT/RAM/ramif/ramaddr
add wave -noupdate /system_tb/DUT/RAM/ramif/ramstore
add wave -noupdate /system_tb/DUT/RAM/ramif/ramload
add wave -noupdate /system_tb/DUT/RAM/ramif/ramstate
add wave -noupdate /system_tb/DUT/RAM/ramif/memREN
add wave -noupdate /system_tb/DUT/RAM/ramif/memWEN
add wave -noupdate /system_tb/DUT/RAM/ramif/memaddr
add wave -noupdate /system_tb/DUT/RAM/ramif/memstore
add wave -noupdate /system_tb/DUT/CPU/DP/REGISTER_FILE/registers
add wave -noupdate /system_tb/DUT/CPU/DP/ALU/aluIf/ops
add wave -noupdate /system_tb/DUT/CPU/DP/ALU/aluIf/portA
add wave -noupdate /system_tb/DUT/CPU/DP/ALU/aluIf/portB
add wave -noupdate /system_tb/DUT/CPU/DP/ALU/aluIf/portOut
add wave -noupdate /system_tb/DUT/CPU/DP/ALU/aluIf/negativeFlag
add wave -noupdate /system_tb/DUT/CPU/DP/ALU/aluIf/zeroFlag
add wave -noupdate /system_tb/DUT/CPU/DP/ALU/aluIf/overflowFlag
add wave -noupdate /system_tb/DUT/CPU/DP/exmem/beqFlag_out
add wave -noupdate /system_tb/DUT/CPU/DP/exmem/bneFlag_out
add wave -noupdate /system_tb/DUT/CPU/DP/exmem/zeroFlag_out
add wave -noupdate /system_tb/DUT/CPU/DP/CONTROL_UNIT/cuif/beqFlag
add wave -noupdate /system_tb/DUT/CPU/DP/CONTROL_UNIT/cuif/bneFlag
add wave -noupdate /system_tb/DUT/CPU/DP/ID_EX/idex/beqFlag_in
add wave -noupdate /system_tb/DUT/CPU/DP/ID_EX/idex/bneFlag_in
add wave -noupdate /system_tb/DUT/CPU/DP/ID_EX/idex/beqFlag_out
add wave -noupdate /system_tb/DUT/CPU/DP/ID_EX/idex/bneFlag_out
add wave -noupdate /system_tb/DUT/CPU/DP/cuif/halt
add wave -noupdate /system_tb/DUT/CPU/DP/ID_EX/idex/halt_in
add wave -noupdate /system_tb/DUT/CPU/DP/ID_EX/idex/halt_out
add wave -noupdate /system_tb/DUT/CPU/DP/EX_MEM/exmem/halt_in
add wave -noupdate /system_tb/DUT/CPU/DP/EX_MEM/exmem/halt_out
add wave -noupdate /system_tb/DUT/CPU/DP/MEM_WB/memwb/halt_in
add wave -noupdate /system_tb/DUT/CPU/DP/MEM_WB/memwb/halt_out
add wave -noupdate /system_tb/DUT/CPU/DP/ID_EX/idex/EN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {575793 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 380
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {380020 ps} {1140078 ps}