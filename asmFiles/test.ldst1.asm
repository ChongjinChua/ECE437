
  #------------------------------------------------------------------
  # Test lw sw
  #------------------------------------------------------------------

  org   0x0000
  ori   $1, $zero, 0xF0
  ori   $2, $zero, 0x100
  ori   $3, $zero, 0x200
  ori   $4, $zero, 0x300
  ori   $5, $zero, 0x400
  lw    $6, 0($1)
  lw    $7, 4($1)
  lw    $8, 8($1)
  ori   $4, $zero, 0x500#4
  ori   $5, $zero, 0x600#5
  sub   $2, $1, $3
  and   $4, $2, $5
  or    $4, $4, $2
  add   $9, $4, $2
  add   $9, $9, $2
  add   $9, $9, $2
  ori   $9, $8, 0xDEAD
  add   $9, $9, $2
  add   $9, $8, $2
  ori   $8, $9, 0xDEAD
  ori   $9, $8, 0xBEEF
  sw    $9, 8($2)
  sw    $8, 8($2)
  sw    $6, 0($2)
  sw    $7, 4($2)

  halt      # that's all

  org   0x00F0
  cfw   0x7337
  cfw   0x2701
  cfw   0x1337
