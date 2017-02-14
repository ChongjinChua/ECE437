onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /alu_tb/CLK
add wave -noupdate /alu_tb/nRST
add wave -noupdate /alu_tb/v1
add wave -noupdate /alu_tb/v2
add wave -noupdate /alu_tb/v3
add wave -noupdate -radix decimal /alu_tb/PROG/testcase
add wave -noupdate /alu_tb/aluIf/ops
add wave -noupdate /alu_tb/aluIf/portA
add wave -noupdate /alu_tb/aluIf/portB
add wave -noupdate /alu_tb/aluIf/portOut
add wave -noupdate /alu_tb/aluIf/negative_flag
add wave -noupdate /alu_tb/aluIf/zero_flag
add wave -noupdate /alu_tb/aluIf/overflow_flag
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ns} {64 ns}
