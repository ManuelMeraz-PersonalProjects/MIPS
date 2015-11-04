.data
    
.text
    addi $s0, $zero, 100000
    srl  $t0, $s0, 2
    srl  $t1, $s0, 0
    add $a0, $t0, $t1
    
    
    li $v0, 1
    add $a0, $zero, $t0
    syscall