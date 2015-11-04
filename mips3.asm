.data

    myAge: .word 25 # This is a word or integer

.text
    
    # Print an integer to the screen
    li $v0, 1
    lw $a0, myAge
    syscall
