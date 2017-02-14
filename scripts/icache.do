onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /icache_tb/CLK
add wave -noupdate /icache_tb/nRST
add wave -noupdate /icache_tb/DUT/cacheHit
add wave -noupdate /icache_tb/DUT/state
add wave -noupdate /icache_tb/DUT/nextstate
add wave -noupdate /icache_tb/DUT/icache_ds
add wave -noupdate /icache_tb/dcif/ihit
add wave -noupdate /icache_tb/dcif/imemREN
add wave -noupdate /icache_tb/dcif/imemload
add wave -noupdate /icache_tb/dcif/imemaddr
add wave -noupdate /icache_tb/cif/iREN
add wave -noupdate /icache_tb/cif/iload
add wave -noupdate /icache_tb/cif/iwait
add wave -noupdate /icache_tb/DUT/cif/iaddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {83 ns} 0}
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
WaveRestoreZoom {0 ns} {147 ns}
