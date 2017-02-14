#---------------------------------------
# count days
#---------------------------------------

# set the address where you want this
# code segment
# current day   -> $25
# current month -> $26
# current year  -> $27
	
  org 0x0000
#initialization
  ori	$29, $0, 0xFFFC
  ori	$28, $0, 0
  ori	$27, $0, 2016 #current year
  ori	$26, $0, 8
  ori	$25, $0, 19
	
#year
  addiu $27, $27, -2000
  ori	$1, $0, 365
  push 	$1
  push  $27
  jal	multiplication
#month
  addiu $26, $26, -1
  ori	$1, $0, 30
  push 	$1
  push  $26
  jal	multiplication

  pop	$2
  pop 	$1
  addu  $1, $1, $2
  addu  $1, $1, $25
  halt
	
multiplication:
  ori	$3, $0, 0
  pop	$2
  pop	$1
add_loop:
  beq	$2, $0, break
  add   $3, $3, $1
positive:
  addi	$2, $2, -1
  j 	add_loop

break:
  push 	$3
  jr	$31
