#--------------------------------------
# Test branch and jumps
#--------------------------------------
  org 0x0000
  ori   $1, $zero, 0xBA5C
  ori   $2, $zero, 0x0080
  ori   $15, $zero, jmpR
  beq   $zero, $zero, braZ
  sw    $1, 0($2)
braZ:
  jal   braR
  sw    $1, 4($2)
end:
  sw    $ra, 16($2)
  HALT
braR:
  or    $3, $zero, $ra
  sw    $ra, 8($2)
  jal   jmpR
  sw    $1, 12($2)
jmpR:
  bne   $ra, $3, end
  ori   $31, $0, 0x00F0
  jal   testJ
  nop
	nop
	nop
	nop
testJ:	
  jr    $31
  nop
  nop
  nop
  org 0x00F0
  ori $9, $0, 0xBEEF
  ori $8, $0, 0x0F00
  sw  $9, 0($8)
  halt
