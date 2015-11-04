.data

.text

.globl main

main:
     addi $t0, $t0, 26 # Character value
     addi $t1, $t1, 1
     addi $t2, $t2, 1
     sll $t2, $t2, 6
     xor $t1, $t1, $t2