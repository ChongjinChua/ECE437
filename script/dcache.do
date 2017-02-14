onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcache_tb/CLK
add wave -noupdate /dcache_tb/nRST
add wave -noupdate /dcache_tb/PROG/testcase
add wave -noupdate /dcache_tb/PROG/command
add wave -noupdate /dcache_tb/DUT/lru
add wave -noupdate /dcache_tb/DUT/nextlru
add wave -noupdate -expand /dcache_tb/DUT/dcache_addr
add wave -noupdate -expand /dcache_tb/DUT/dcache_data
add wave -noupdate /dcache_tb/dcif/dhit
add wave -noupdate /dcache_tb/DUT/hit0
add wave -noupdate /dcache_tb/DUT/hit1
add wave -noupdate /dcache_tb/DUT/hit
add wave -noupdate /dcache_tb/DUT/count
add wave -noupdate /dcache_tb/DUT/addr_load
add wave -noupdate /dcache_tb/DUT/addr_store
add wave -noupdate /dcache_tb/DUT/addr_flush
add wave -noupdate /dcache_tb/DUT/asmBlkoff
add wave -noupdate /dcache_tb/DUT/state
add wave -noupdate /dcache_tb/DUT/nextstate
add wave -noupdate -expand /dcache_tb/DUT/dc
add wave -noupdate -expand -group dcif /dcache_tb/dcif/halt
add wave -noupdate -expand -group dcif /dcache_tb/dcif/ihit
add wave -noupdate -expand -group dcif /dcache_tb/dcif/imemREN
add wave -noupdate -expand -group dcif /dcache_tb/dcif/imemload
add wave -noupdate -expand -group dcif /dcache_tb/dcif/imemaddr
add wave -noupdate -expand -group dcif /dcache_tb/dcif/dhit
add wave -noupdate -expand -group dcif /dcache_tb/dcif/datomic
add wave -noupdate -expand -group dcif /dcache_tb/dcif/dmemREN
add wave -noupdate -expand -group dcif /dcache_tb/dcif/dmemWEN
add wave -noupdate -expand -group dcif /dcache_tb/dcif/flushed
add wave -noupdate -expand -group dcif /dcache_tb/dcif/dmemload
add wave -noupdate -expand -group dcif /dcache_tb/dcif/dmemstore
add wave -noupdate -expand -group dcif /dcache_tb/dcif/dmemaddr
add wave -noupdate -expand -group cif /dcache_tb/cif/iwait
add wave -noupdate -expand -group cif /dcache_tb/cif/dwait
add wave -noupdate -expand -group cif /dcache_tb/cif/iREN
add wave -noupdate -expand -group cif /dcache_tb/cif/dREN
add wave -noupdate -expand -group cif /dcache_tb/cif/dWEN
add wave -noupdate -expand -group cif /dcache_tb/cif/iload
add wave -noupdate -expand -group cif /dcache_tb/cif/dload
add wave -noupdate -expand -group cif /dcache_tb/cif/dstore
add wave -noupdate -expand -group cif /dcache_tb/cif/iaddr
add wave -noupdate -expand -group cif /dcache_tb/cif/daddr
add wave -noupdate -expand -group cif /dcache_tb/cif/ccwait
add wave -noupdate -expand -group cif /dcache_tb/cif/ccinv
add wave -noupdate -expand -group cif /dcache_tb/cif/ccwrite
add wave -noupdate -expand -group cif /dcache_tb/cif/cctrans
add wave -noupdate -expand -group cif /dcache_tb/cif/ccsnoopaddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {31 ns} 0}
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
WaveRestoreZoom {0 ns} {263 ns}
