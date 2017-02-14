#---------------------------------------
# multiplication of two values
#---------------------------------------

# set the address where you want this
# code segment
  org 0x0000
  ori	$29, $0, 0xFFFC
  
  ori   $1, $0, 10
  ori   $2, $0, 3
  push 	$1
  push  $2
  jal	multiplication
  pop 	$1
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
