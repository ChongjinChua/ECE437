#------------------------------------------
# Originally Test and Set example by Eric Villasenor
# Modified to be LL and SC example by Yue Du
#------------------------------------------
	
#----------------------------------------------------------
# First Processor
#----------------------------------------------------------
  org   0x0000              # first processor p0
  ori   $sp, $zero, 0x3ffc  # stack
  ori   $s2, $zero, icsp  # intercomm stack
  jal   mainp0              # go to program
  halt

# pass in an address to lock function in argument register 0
# returns when lock is available
lock:
aquire:
  ll    $t0, 0($a0)         # load lock location
  bne   $t0, $0, aquire     # wait on lock to be open
  addiu $t0, $t0, 1
  sc    $t0, 0($a0)
  beq   $t0, $0, lock       # if sc failed retry
  jr    $ra


# pass in an address to unlock function in argument register 0
# returns when lock is free
unlock:
  sw    $0, 0($a0)
  jr    $ra

# main function does something ugly but demonstrates beautifully
mainp0:
  push  $ra                 # save return address
  ori   $v0, $0, 0x5EED
  ori   $s0, $0, 256
	
produce:	
  ori $a0, $v0, 0
  jal crc32                 # calculate crc
  ori   $a0, $zero, lockptr      # move lock to arguement register
  jal   lock                # try to aquire the lock
	
  # critical code segment
  ori $s2, $0, icsp            # move ic-sp address to $s2
  lw $s7, 0($s2)               # load ic-sp to $29
  addi $s7, $s7, -4            # push result
  sw   $v0, 0($s7)
  ori $s2, $0, icsp            # move ic-sp address to $s2
  sw $s7, 0($s2)               # store ic-sp to memory
  # critical code segment
	
  ori   $a0, $zero, lockptr      # move lock to arguement register
  jal   unlock              # release the lock

  addi $s0, $s0, -1         #increment counter
  bne $s0, $0, produce      #branch if not eq 256

  pop   $ra                 # get return address
  jr    $ra                 # return to caller
lockptr:
  cfw 0x0
icsp:
  cfw 0xbffc

#----------------------------------------------------------
# Second Processor
#----------------------------------------------------------
  org   0x200               # second processor p1
  ori   $sp, $zero, 0x7ffc  # stack
  jal   mainp1              # go to program
  halt

# main function does something ugly but demonstrates beautifully
mainp1:
  push  $ra                 # save return address
  ori $s6, $0, 0xbffc          # initial addr for ic-sp
  ori $s0, $0, 256	
  ori $s3, $0, 0xFFFF
	
consume:	
  ori $s2, $0, icsp            # move ic-sp address to $s2
  lw $s7, 0($s2)               # load ic-sp to $29
  beq $s7, $s6, consume   
  
  ori   $a0, $zero, lockptr      # move lock to arguement register
  jal   lock                # try to aquire the lock
	
  # critical code segment
  ori  $s2, $0, icsp            # move ic-sp address to $s2
  lw   $s7, 0($s2)              # load ic-sp to $29
  lw   $s5, 0($s7)              # pop new number
  sw   $0, 0($s7)
  addi $s7, $s7, 4
  ori $s2, $0, icsp            # move ic-sp address to $s2
  sw $s7, 0($s2)               # store ic-sp to memory
  # critical code segment
	
  ori   $a0, $zero, lockptr      # move lock to arguement register
  jal   unlock              # release the lock

  #s1 = avg
  #s3 = min
  #s4 = max

  andi $s5, $s5, 0x0000ffff   # get lower 16 bits of new number into $s5
  ori $a1, $s5, 0

  # find min
  ori $a0, $s3, 0
  jal min
  ori $s3, $v0, 0

  # find max
  ori $a0, $s4, 0
  jal max
  ori $s4, $v0, 0

  # add new number to running total
  add $s1, $s1, $s5

  # keep getting new numbers if we haven't gotten 256 yet
  addi $s0, $s0, -1         #increment counter
  bne $s0, $0, consume      #branch if not eq 256

  # divide $s1 by 256
  ori $a0, $s1, 0
  ori $a1, $0, 256
  jal divide

  # store average to $s1
  ori $s1, $v0, 0

  # store to memory
  ori $a0, $0, 0x8000
  sw  $s1, 0($a0)
  sw  $s3, 4($a0)
  sw  $s4, 8($a0)
	
  pop   $ra                 # get return address
  jr    $ra                 # return to caller

res:
  cfw 0x0                   # end result should be 3

#------------------------------------------------------
# $v0 = crc32($a0)
crc32:
  lui $t1, 0x04C1
  ori $t1, $t1, 0x1DB7
  or $t2, $0, $0
  ori $t3, $0, 32

l1:
  slt $t4, $t2, $t3
  beq $t4, $zero, l2

  srl $t4, $a0, 31
  sll $a0, $a0, 1
  beq $t4, $0, l3
  xor $a0, $a0, $t1
l3:
  addiu $t2, $t2, 1
  j l1
l2:
  or $v0, $a0, $0
  jr $ra
#------------------------------------------------------

#-max (a0=a,a1=b) returns v0=max(a,b)--------------
max:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a0, $a1
  beq   $t0, $0, maxrtn
  or    $v0, $0, $a1
maxrtn:
  pop   $a1
  pop   $a0
  pop   $ra
  jr    $ra
#--------------------------------------------------

#-min (a0=a,a1=b) returns v0=min(a,b)--------------
min:
  push  $ra
  push  $a0
  push  $a1
  or    $v0, $0, $a0
  slt   $t0, $a1, $a0
  beq   $t0, $0, minrtn
  or    $v0, $0, $a1
minrtn:
  pop   $a1
  pop   $a0
  pop   $ra
  jr    $ra
#--------------------------------------------------
#-divide(N=$a0,D=$a1) returns (Q=$v0,R=$v1)--------
divide:               # setup frame
  push  $ra           # saved return address
  push  $a0           # saved register
  push  $a1           # saved register
  or    $v0, $0, $0   # Quotient v0=0
  or    $v1, $0, $a0  # Remainder t2=N=a0
  beq   $0, $a1, divrtn # test zero D
  slt   $t0, $a1, $0  # test neg D
  bne   $t0, $0, divdneg
  slt   $t0, $a0, $0  # test neg N
  bne   $t0, $0, divnneg
divloop:
  slt   $t0, $v1, $a1 # while R >= D
  bne   $t0, $0, divrtn
  addiu $v0, $v0, 1   # Q = Q + 1
  subu  $v1, $v1, $a1 # R = R - D
  j     divloop
divnneg:
  subu  $a0, $0, $a0  # negate N
  jal   divide        # call divide
  subu  $v0, $0, $v0  # negate Q
  beq   $v1, $0, divrtn
  addiu $v0, $v0, -1  # return -Q-1
  j     divrtn
divdneg:
  subu  $a0, $0, $a1  # negate D
  jal   divide        # call divide
  subu  $v0, $0, $v0  # negate Q
divrtn:
  pop $a1
  pop $a0
  pop $ra
  jr  $ra
#-divide--------------------------------------------

	
