onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /control_unit_tb/CLK
add wave -noupdate /control_unit_tb/nRST
add wave -noupdate /control_unit_tb/PROG/testcase
add wave -noupdate /control_unit_tb/PROG/command
add wave -noupdate -radix symbolic /control_unit_tb/instructionOp
add wave -noupdate -radix symbolic /control_unit_tb/funct
add wave -noupdate /control_unit_tb/overflow_flag
add wave -noupdate /control_unit_tb/zero_flag
add wave -noupdate -radix symbolic /control_unit_tb/aluCtrl
add wave -noupdate -radix symbolic /control_unit_tb/aluSrc
add wave -noupdate /control_unit_tb/instr
add wave -noupdate -radix symbolic /control_unit_tb/regWrite
add wave -noupdate /control_unit_tb/regDst
add wave -noupdate -radix symbolic /control_unit_tb/extension
add wave -noupdate /control_unit_tb/pcSrc
add wave -noupdate -radix symbolic /control_unit_tb/jump
add wave -noupdate -radix symbolic /control_unit_tb/jrFlag
add wave -noupdate -radix symbolic /control_unit_tb/halt
add wave -noupdate /control_unit_tb/dread
add wave -noupdate /control_unit_tb/iread
add wave -noupdate /control_unit_tb/dwrite
add wave -noupdate -radix symbolic /control_unit_tb/memToReg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {498 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 145
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
WaveRestoreZoom {337 ns} {593 ns}
