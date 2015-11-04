.data
    myWord: .asciiz "cnf"
    null: .byte '\0'
    
.text

.globl main

main:
    la $t0, myWord
    lb $t1, null
    addi $v0, $v0, 11
    
 while:
     lb $t2, 0($t0)
     beq $t1, $t2, exit
     addi $t2, $t2, 1
     sb $t2, 0($t0)
     add $a0, $t2, $a0
     syscall
     add $a0, $zero, $zero
     addi $t0, $t0, 1
     j while
     
exit:
     
     
     
