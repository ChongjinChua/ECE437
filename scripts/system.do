onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/DUT/CPUCLK
add wave -noupdate /system_tb/DUT/CLK
add wave -noupdate /system_tb/DUT/nRST
add wave -noupdate /system_tb/DUT/halt
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/nextLinkReg
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/linkReg
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/nextLinkValid
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/linkValid
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/CLK
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/nRST
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/opCode
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/idex/opCode_out
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/exmem/opCode_out
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/memwb/opCode_out
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/funct
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/idex/funct_out
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/exmem/funct_out
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/memwb/funct_out
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/rs
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/rt
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/rd
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/imm
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/shamt
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/PC
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/PC4
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/interPC
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/nextPC
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/wbData
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/branchAddr
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/jAddr
add wave -noupdate -expand -group DP0 /system_tb/DUT/CPU/DP0/branchFlag
add wave -noupdate -expand -group DP0 -expand /system_tb/DUT/CPU/DP0/REGISTER_FILE/registers
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/DP1/CLK
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/DP1/nRST
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/DP1/opCode
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/DP1/idex/opCode_out
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/DP1/exmem/opCode_out
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/DP1/memwb/opCode_out
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/DP1/funct
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/DP1/rs
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/DP1/rt
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/DP1/rd
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/DP1/imm
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/DP1/shamt
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/DP1/PC
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/DP1/PC4
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/DP1/interPC
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/DP1/nextPC
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/DP1/wbData
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/DP1/branchAddr
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/DP1/jAddr
add wave -noupdate -expand -group DP1 /system_tb/DUT/CPU/DP1/branchFlag
add wave -noupdate -expand -group DP1 -expand /system_tb/DUT/CPU/DP1/REGISTER_FILE/registers
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/iwait
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/dwait
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/iREN
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/dREN
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/dWEN
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/iload
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/dload
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/dstore
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/iaddr
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/daddr
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ccwait
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ccinv
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ccwrite
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/cctrans
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ccsnoopaddr
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ramWEN
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ramREN
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ramstate
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ramaddr
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ramstore
add wave -noupdate -expand -group ccif /system_tb/DUT/CPU/ccif/ramload
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/iwait
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/dwait
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/iREN
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/dREN
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/dWEN
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/iload
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/dload
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/dstore
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/iaddr
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/daddr
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/ccwait
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/ccinv
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/ccwrite
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/cctrans
add wave -noupdate -expand -group cif0 /system_tb/DUT/CPU/cif0/ccsnoopaddr
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/iwait
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dwait
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/iREN
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dREN
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dWEN
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/iload
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dload
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dstore
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/iaddr
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/daddr
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/ccwait
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/ccinv
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/ccwrite
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/cctrans
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/ccsnoopaddr
add wave -noupdate -expand -group CC /system_tb/DUT/CPU/CC/CLK
add wave -noupdate -expand -group CC /system_tb/DUT/CPU/CC/nRST
add wave -noupdate -expand -group CC /system_tb/DUT/CPU/CC/state
add wave -noupdate -expand -group CC /system_tb/DUT/CPU/CC/nextstate
add wave -noupdate -expand -group CC /system_tb/DUT/CPU/CC/target
add wave -noupdate -expand -group CC /system_tb/DUT/CPU/CC/nexttarget
add wave -noupdate -expand -group CC /system_tb/DUT/CPU/CC/daddr
add wave -noupdate -expand -group CC /system_tb/DUT/CPU/CC/ccwrite
add wave -noupdate -group RAM /system_tb/DUT/RAM/CLK
add wave -noupdate -group RAM /system_tb/DUT/RAM/nRST
add wave -noupdate -group RAM /system_tb/DUT/RAM/count
add wave -noupdate -group RAM /system_tb/DUT/RAM/rstate
add wave -noupdate -group RAM /system_tb/DUT/RAM/q
add wave -noupdate -group RAM /system_tb/DUT/RAM/addr
add wave -noupdate -group RAM /system_tb/DUT/RAM/wren
add wave -noupdate -group RAM /system_tb/DUT/RAM/en
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/halt
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/ihit
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/imemREN
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/imemload
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/imemaddr
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/dhit
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/datomic
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/dmemREN
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/dmemWEN
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/flushed
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/dmemload
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/dmemstore
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/dmemaddr
add wave -noupdate /system_tb/DUT/CPU/dcif0/scValid
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/halt
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/ihit
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/imemREN
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/imemload
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/imemaddr
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dhit
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/datomic
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemREN
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemWEN
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/flushed
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemload
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemstore
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemaddr
add wave -noupdate /system_tb/DUT/CPU/dcif1/scValid
add wave -noupdate /system_tb/DUT/CPU/DP0/ifid/instr_out
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/CLK
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/nRST
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/lru
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/nextlru
add wave -noupdate -expand -group dcache0 -expand -subitemconfig {/system_tb/DUT/CPU/CM0/DCACHE/dc.ds -expand} /system_tb/DUT/CPU/CM0/DCACHE/dc
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/dcache_addr
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/snoop_addr
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/dcache_data
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/hit0
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/hit1
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/snoopHit0
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/snoopHit1
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/hit
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/snoopHit
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/count
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/addr_load
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/addr_store
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/addr_flush
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/addr_snoop
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/asmBlkoff
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/hitcount
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/next_hitcount
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/misscount
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/next_misscount
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/nextdREN
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/nextdWEN
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/_dhit
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/state
add wave -noupdate -expand -group dcache0 /system_tb/DUT/CPU/CM0/DCACHE/nextstate
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/CLK
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/nRST
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/lru
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/nextlru
add wave -noupdate -expand -group dcache1 -expand -subitemconfig {/system_tb/DUT/CPU/CM1/DCACHE/dc.ds -expand} /system_tb/DUT/CPU/CM1/DCACHE/dc
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/dcache_addr
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/snoop_addr
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/dcache_data
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/hit0
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/hit1
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/snoopHit0
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/snoopHit1
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/hit
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/snoopHit
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/count
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/addr_load
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/addr_store
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/addr_flush
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/addr_snoop
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/asmBlkoff
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/hitcount
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/next_hitcount
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/misscount
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/next_misscount
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/nextdREN
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/nextdWEN
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/_dhit
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/state
add wave -noupdate -expand -group dcache1 /system_tb/DUT/CPU/CM1/DCACHE/nextstate
add wave -noupdate /system_tb/DUT/CPU/DP0/memwb/scStatus_out
add wave -noupdate /system_tb/DUT/CPU/DP0/FU/fuif/forwardA
add wave -noupdate /system_tb/DUT/CPU/DP0/FU/fuif/forwardB
add wave -noupdate /system_tb/DUT/CPU/DP0/FU/fuif/forwarddmemstore
add wave -noupdate /system_tb/DUT/CPU/DP1/fuif/forwardA
add wave -noupdate /system_tb/DUT/CPU/DP1/fuif/forwardB
add wave -noupdate /system_tb/DUT/CPU/DP1/fuif/forwarddmemstore
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {21298680 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 368
configure wave -valuecolwidth 176
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
WaveRestoreZoom {20420291 ps} {24946958 ps}
