#---------------------------------------
# multiplication procedure
#---------------------------------------

# set the address where you want this
# code segment
  org 0x0000
  ori	$29, $0, 0xFFFC
  ori	$30, $0, 0xFFFC
  ori	$28, $0, 0
  
  ori   $1, $0, 10
  push 	$1
  ori   $1, $0, 3	
  push  $1
  ori   $1, $0, 3	
  push  $1
	
mult_procedure:	
  jal	multiplication
  addiu $28, $29, 4
  bne	$28, $30, mult_procedure
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
