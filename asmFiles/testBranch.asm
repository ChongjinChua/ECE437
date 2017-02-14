
  org 0x0000
  ori   $1,$zero,0x15
  ori   $2,$zero,0x15
  ori   $3,$zero,0xBEEF
  ori   $4,$zero,0xDEAD
  ori   $21,$zero,0x80
  sw    $2, 0($21)

# Now running all R type instructions
  lw    $2, 0($21)
  beq   $1, $2, equal
  or    $6, $0, $4
  andi   $5, $0, 0xABCD
  andi   $5, $0, 0xABCD
  halt
equal:
  or    $6, $0, $3
  sw    $6,0($21)
  halt  # that's all

  org 0x80
  cfw 0xFEED
